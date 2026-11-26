extends ColorRect
## Reusable stat help popup (DNG-7).
##
## One instance lives on the root `Main` node. Any stat bar (hub, exploration HUD, Level Up,
## fight panel) is wired to it with `attach(row, stat_key)`: tapping the bar shows the stat's
## name and a short description, and a tap anywhere closes it. The texts are also exposed as
## static helpers (`get_stat_name`, `get_stat_description`) so other screens, such as the
## Level Up stat guide, show exactly the same wording.

const UiTheme := preload("res://scripts/ui_theme.gd")
const CombatRules := preload("res://scripts/combat_rules.gd")

## Translation keys for each stat: display name and short description.
const STAT_TEXT_KEYS := {
	"life": {"name": "STAT_LIFE", "description": "STAT_LIFE_HELP"},
	"energy": {"name": "STAT_ENERGY", "description": "STAT_ENERGY_HELP"},
	"mana": {"name": "STAT_MANA", "description": "STAT_MANA_HELP"},
	"armor": {"name": "STAT_ARMOR", "description": "STAT_ARMOR_HELP"},
	"strength": {"name": "STAT_STRENGTH", "description": "STAT_STRENGTH_HELP"},
	"speed": {"name": "STAT_SPEED", "description": "STAT_SPEED_HELP"},
	"reputation": {"name": "STAT_REPUTATION", "description": "STAT_REPUTATION_HELP"},
	"experience": {"name": "STAT_EXPERIENCE", "description": "STAT_EXPERIENCE_HELP"},
	"dungeon_experience": {"name": "STAT_DUNGEON_EXPERIENCE", "description": "STAT_DUNGEON_EXPERIENCE_HELP"},
}
const CLOSE_HINT_KEY := "STAT_HELP_CLOSE_HINT"
## A press and release further apart than this (logical px) is a drag/scroll, not a tap.
const TAP_SLOP := 16.0
## Meta key used on a wired stat bar to remember where the current press started.
const PRESS_POSITION_META := &"stat_help_press_position"

## Stat currently shown, or "" when the popup is closed (read by tests).
var shown_stat_key: String = ""
var icon: TextureRect
var name_label: Label
var description_label: Label
var close_hint_label: Label

func _init() -> void:
	name = "StatHelpPopup"
	color = Color(UiTheme.SCRIM, 0.7)
	visible = false
	# The scrim takes every tap: one tap anywhere closes the popup and never reaches the screen.
	mouse_filter = Control.MOUSE_FILTER_STOP
	set_anchors_preset(Control.PRESET_FULL_RECT)
	_build_card()

## Localized display name of a stat (for example "Life" / "Vida").
static func get_stat_name(stat_key: String) -> String:
	var keys: Dictionary = STAT_TEXT_KEYS.get(stat_key, {})
	return TranslationServer.translate(String(keys.get("name", stat_key)))

## Localized short description of a stat, with the real rule numbers from CombatRules filled in.
static func get_stat_description(stat_key: String) -> String:
	var keys: Dictionary = STAT_TEXT_KEYS.get(stat_key, {})
	if keys.is_empty():
		return ""
	var text := TranslationServer.translate(String(keys["description"]))
	var arguments := _get_description_arguments(stat_key)
	return text % arguments if not arguments.is_empty() else text

## Values substituted into each description, so the help never drifts from the rules.
static func _get_description_arguments(stat_key: String) -> Array:
	match stat_key:
		"energy":
			return [str(CombatRules.ENERGY_MOVE_COST), str(CombatRules.ENERGY_ATTACK_COST)]
		"mana":
			return [str(CombatRules.REST_MANA_COST)]
		"strength":
			return [str(CombatRules.STRENGTH_DAMAGE_BASELINE)]
		"experience":
			return [str(CombatRules.LEVEL_UP_POINTS)]
	return []

## Makes `target` (a stat bar row) open this popup for `stat_key` when tapped; `icon_color` tints
## the popup icon like the bar. Children stop intercepting input so a tap on the icon, label or
## bar all count.
func attach(target: Control, stat_key: String, icon_color: Color = UiTheme.TEXT) -> void:
	# PASS keeps scroll containers (Level Up screen) able to scroll when the drag starts on a bar.
	target.mouse_filter = Control.MOUSE_FILTER_PASS
	_ignore_input_recursive(target)
	target.gui_input.connect(Callable(self, "_on_target_gui_input").bind(target, stat_key, icon_color))

## Shows the popup with the stat's icon (tinted `icon_color`), name and description.
func show_stat(stat_key: String, icon_color: Color = UiTheme.TEXT) -> void:
	if not STAT_TEXT_KEYS.has(stat_key):
		return
	shown_stat_key = stat_key
	icon.texture = _load_stat_icon(stat_key)
	icon.modulate = icon_color
	name_label.text = get_stat_name(stat_key)
	description_label.text = get_stat_description(stat_key)
	close_hint_label.text = tr(CLOSE_HINT_KEY)
	visible = true

## Hides the popup (tap anywhere, Android back, or a screen change).
func close() -> void:
	visible = false
	shown_stat_key = ""

## True while the popup is showing.
func is_open() -> bool:
	return visible

## A tap anywhere on the popup closes it. Closing on press (not release) means the matching
## release is captured by this popup and cannot trigger a button underneath.
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and (event as InputEventMouseButton).pressed:
		close()
		accept_event()

## Opens the popup on a tap (press and release close together) over a wired stat bar.
func _on_target_gui_input(event: InputEvent, target: Control, stat_key: String, icon_color: Color) -> void:
	if not event is InputEventMouseButton:
		return
	var button_event := event as InputEventMouseButton
	if button_event.button_index != MOUSE_BUTTON_LEFT:
		return
	if button_event.pressed:
		target.set_meta(PRESS_POSITION_META, button_event.position)
		return
	if not target.has_meta(PRESS_POSITION_META):
		return
	var press_position: Vector2 = target.get_meta(PRESS_POSITION_META)
	target.remove_meta(PRESS_POSITION_META)
	if press_position.distance_to(button_event.position) <= TAP_SLOP:
		show_stat(stat_key, icon_color)

## Centred dialog card: icon and name on one row, the description, then a "tap to close" hint.
func _build_card() -> void:
	var margin := MarginContainer.new()
	margin.name = "Margin"
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	for side: String in ["left", "right"]:
		margin.add_theme_constant_override("margin_%s" % side, UiTheme.SCREEN_GUTTER)
	for side: String in ["top", "bottom"]:
		margin.add_theme_constant_override("margin_%s" % side, 24)
	add_child(margin)
	var card := PanelContainer.new()
	card.name = "Card"
	card.theme_type_variation = &"DialogPanel"
	card.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	margin.add_child(card)
	var content := VBoxContainer.new()
	content.name = "Content"
	content.add_theme_constant_override("separation", 12)
	card.add_child(content)

	var header := HBoxContainer.new()
	header.name = "Header"
	header.alignment = BoxContainer.ALIGNMENT_CENTER
	header.add_theme_constant_override("separation", 10)
	content.add_child(header)
	icon = TextureRect.new()
	icon.name = "Icon"
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.custom_minimum_size = Vector2(32, 32)
	header.add_child(icon)
	name_label = Label.new()
	name_label.name = "StatName"
	name_label.theme_type_variation = &"HeaderLabel"
	header.add_child(name_label)

	description_label = Label.new()
	description_label.name = "Description"
	description_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	description_label.custom_minimum_size = Vector2(200, 0)
	content.add_child(description_label)

	close_hint_label = Label.new()
	close_hint_label.name = "CloseHint"
	close_hint_label.theme_type_variation = &"CaptionLabel"
	close_hint_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	close_hint_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(close_hint_label)
	# Only the scrim handles input; the card is purely visual.
	_ignore_input_recursive(self)

## Sets every descendant of `node` to ignore mouse input, so the parent receives the taps.
func _ignore_input_recursive(node: Node) -> void:
	for child: Node in node.get_children():
		if child is Control:
			(child as Control).mouse_filter = Control.MOUSE_FILTER_IGNORE
		_ignore_input_recursive(child)

## Icon of a stat; every stat key has a matching SVG in assets/icons.
func _load_stat_icon(stat_key: String) -> Texture2D:
	return load("res://assets/icons/%s.svg" % stat_key) as Texture2D

