extends Control
## Floating combat numbers over the fighters' portraits (DNG-13).
##
## When an attack lands, its damage ("-3") rises from the target's portrait and fades out in
## FLOAT_SECONDS; an attack that does no damage floats its outcome word instead ("Dodged",
## "Blocked").
##
## The layer is a full-screen Control on the root `Main` node, placed just above the damage
## overlay and below every modal. That way the number stays readable while the dark damage
## overlay flashes, and a modal (victory result, monster info, confirmations) still covers it.
## It never takes input (MOUSE_FILTER_IGNORE).
##
## The animation is a Tween on each label and nothing waits for it: code that calls the combat
## methods directly (tests, the playtest bot) is never blocked. Each label frees itself when its
## tween ends; clear() removes them all at once (the encounter closes).

const UiTheme := preload("res://scripts/ui_theme.gd")

## How long a number rises and fades, in seconds.
const FLOAT_SECONDS := 0.8
## How far a number rises, in logical pixels.
const RISE_DISTANCE := 56.0
## Height of a floating label; it is as wide as the portrait it floats over.
const LABEL_HEIGHT := 40.0
const DAMAGE_FONT_SIZE := 34
const WORD_FONT_SIZE := 24
## Safety cap: callers that never let frames run (the playtest bot fights many rounds in a row)
## cannot pile up labels; the oldest are dropped first.
const MAX_ACTIVE_LABELS := 6

## Colours: damage to the player is red, damage to the monster gold, no damage pale blue.
const COLOR_DAMAGE_TO_PLAYER := Color("ff6b4f")
const COLOR_DAMAGE_TO_MONSTER := UiTheme.ACCENT_BRIGHT
const COLOR_NO_DAMAGE := Color("bfe3f5")

func _init() -> void:
	name = "DamageNumbers"
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_anchors_preset(Control.PRESET_FULL_RECT)

## Floats `text` over `anchor` (a portrait). `is_damage` picks the bigger number style.
## Returns the label so callers can inspect it.
func spawn(anchor: Control, text: String, color: Color, is_damage: bool) -> Label:
	_drop_oldest_beyond_cap()
	var label := Label.new()
	label.name = "FloatingNumber"
	label.text = text
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", DAMAGE_FONT_SIZE if is_damage else WORD_FONT_SIZE)
	label.add_theme_color_override("font_color", color)
	label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.9))
	label.add_theme_constant_override("outline_size", 8)
	add_child(label)

	# Start centred on the portrait, in this layer's coordinates.
	var anchor_rect := anchor.get_global_rect()
	var to_local := get_global_transform().affine_inverse()
	var start := to_local * (anchor_rect.get_center() - Vector2(anchor_rect.size.x / 2.0, LABEL_HEIGHT / 2.0))
	label.size = Vector2(anchor_rect.size.x, LABEL_HEIGHT)
	label.position = start

	# Rise and fade together, then free the label. The tween belongs to the label, so freeing
	# the label early (clear()) also stops its tween.
	var tween := label.create_tween().set_parallel(true)
	tween.tween_property(label, "position:y", start.y - RISE_DISTANCE, FLOAT_SECONDS) \
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(label, "modulate:a", 0.0, FLOAT_SECONDS) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.chain().tween_callback(label.queue_free)
	return label

## Removes every floating label at once.
func clear() -> void:
	for child: Node in get_children():
		remove_child(child)
		child.queue_free()

## Texts of the labels still floating, oldest first (read by tests).
func get_active_texts() -> Array[String]:
	var texts: Array[String] = []
	for child: Node in get_children():
		if child is Label and not child.is_queued_for_deletion():
			texts.append((child as Label).text)
	return texts

## Colour for a float: damage to the player, damage to the monster, or no damage.
static func color_for(is_damage: bool, target_is_player: bool) -> Color:
	if not is_damage:
		return COLOR_NO_DAMAGE
	return COLOR_DAMAGE_TO_PLAYER if target_is_player else COLOR_DAMAGE_TO_MONSTER

func _drop_oldest_beyond_cap() -> void:
	while get_child_count() >= MAX_ACTIVE_LABELS:
		var oldest := get_child(0)
		remove_child(oldest)
		oldest.queue_free()
