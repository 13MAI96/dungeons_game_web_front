extends ColorRect
## First-run "how to play" tutorial (DNG-6).
##
## A full-screen overlay with one dialog card showing one page at a time: title, optional icon,
## body text and a "N / total" counter. Next and Skip move on or close; the last page shows Done.
## The rule numbers come from CombatRules, so the text always matches the real game rules.
## The overlay does not persist anything itself: it emits `closed` and the owner (main.gd)
## stores the "tutorial seen" flag through SettingsStore.

const UiTheme := preload("res://scripts/ui_theme.gd")
const CombatRules := preload("res://scripts/combat_rules.gd")

## Emitted when the tutorial is dismissed. `completed` is true for Done, false for Skip/back.
signal closed(completed: bool)

const TITLE_KEY := "TUTORIAL_TITLE"
const PAGE_COUNTER_KEY := "TUTORIAL_PAGE_COUNTER"
const NEXT_KEY := "TUTORIAL_NEXT"
const SKIP_KEY := "TUTORIAL_SKIP"
const DONE_KEY := "TUTORIAL_DONE"
## Page definitions: translation keys for title and body, plus an optional icon and its tint.
## Body arguments are filled by `_get_body_arguments` from CombatRules constants.
const PAGES := [
	{"id": "grid", "title": "TUTORIAL_GRID_TITLE", "body": "TUTORIAL_GRID_BODY", "icon": "res://assets/icons/arrow_up.svg", "color": "#f2e8d8"},
	{"id": "energy", "title": "TUTORIAL_ENERGY_TITLE", "body": "TUTORIAL_ENERGY_BODY", "icon": "res://assets/icons/energy.svg", "color": "#e7e757"},
	{"id": "experience", "title": "TUTORIAL_EXPERIENCE_TITLE", "body": "TUTORIAL_EXPERIENCE_BODY", "icon": "res://assets/icons/dungeon_experience.svg", "color": "#38bdf8"},
	{"id": "retreat", "title": "TUTORIAL_RETREAT_TITLE", "body": "TUTORIAL_RETREAT_BODY", "icon": "res://assets/icons/arrow_left.svg", "color": "#33b361"},
	{"id": "rest", "title": "TUTORIAL_REST_TITLE", "body": "TUTORIAL_REST_BODY", "icon": "res://assets/icons/mana.svg", "color": "#82c4c4"},
	{"id": "sanctuary", "title": "TUTORIAL_SANCTUARY_TITLE", "body": "TUTORIAL_SANCTUARY_BODY", "icon": "res://assets/icons/sanctuary.svg", "color": "#4fb3d1"},
]

## Minimum card height (logical px): fits the longest page and leaves room on an 844 px screen.
const CARD_MIN_HEIGHT := 460

## Index of the page on screen (0-based).
var page_index: int = 0
var heading_label: Label
var page_title_label: Label
var page_icon: TextureRect
var body_label: Label
var counter_label: Label
var skip_button: Button
var next_button: Button
var done_button: Button
var card: PanelContainer

func _init() -> void:
	name = "TutorialOverlay"
	color = Color(UiTheme.BACKGROUND, 0.96)
	visible = false
	# Blocks taps so the screen behind (the dungeon on first run) cannot be used meanwhile.
	mouse_filter = Control.MOUSE_FILTER_STOP
	set_anchors_preset(Control.PRESET_FULL_RECT)
	_build_card()

## Number of pages in the tutorial.
func page_count() -> int:
	return PAGES.size()

## Opens the tutorial on its first page.
func open() -> void:
	page_index = 0
	_show_page()
	visible = true
	next_button.grab_focus.call_deferred()

## True while the tutorial is showing.
func is_open() -> bool:
	return visible

## Advances one page; on the last page it behaves like Done.
func next_page() -> void:
	if page_index >= page_count() - 1:
		finish()
		return
	page_index += 1
	_show_page()

## Closes the tutorial before the end (Skip button or Android back).
func skip() -> void:
	_close(false)

## Closes the tutorial after the last page (Done button).
func finish() -> void:
	_close(true)

## Re-applies the texts of the current page (used after a language change).
func refresh_texts() -> void:
	if visible:
		_show_page()

## Hides the overlay without emitting `closed` (a screen change from code, not a player choice).
func dismiss_silently() -> void:
	visible = false

## Hides the overlay and reports how it was closed (ignored when already hidden).
func _close(completed: bool) -> void:
	if not visible:
		return
	visible = false
	closed.emit(completed)

## Values substituted into a page body, read from the real rule constants.
static func _get_body_arguments(page_id: String) -> Array:
	match page_id:
		"energy":
			return [str(CombatRules.ENERGY_MOVE_COST), str(CombatRules.ENERGY_ATTACK_COST),
				str(CombatRules.ENERGY_MOVE_COST), str(CombatRules.ENERGY_QUEST_COST)]
		"retreat":
			return [str(CombatRules.ENERGY_RETREAT_COST)]
		"rest":
			# Rest restores fixed percentages (DNG-16): cost, life percent, energy percent.
			return [str(CombatRules.REST_MANA_COST),
				str(CombatRules.REST_LIFE_PERCENT), str(CombatRules.REST_ENERGY_PERCENT)]
		"sanctuary":
			return [str(CombatRules.SANCTUARY_PERCENT_MIN), str(CombatRules.SANCTUARY_PERCENT_MAX),
				str(CombatRules.ENERGY_QUEST_COST), str(CombatRules.QUEST_SUCCESS_ROLL),
				str(CombatRules.QUEST_REWARD_EXPERIENCE), str(CombatRules.QUEST_FAILURE_DAMAGE)]
	return []

## Localized body text of page `index`, with its rule numbers filled in.
func get_page_body(index: int) -> String:
	var page: Dictionary = PAGES[index]
	var text := tr(String(page["body"]))
	var arguments := _get_body_arguments(String(page["id"]))
	return text % arguments if not arguments.is_empty() else text

## Fills the card with the current page and swaps Next/Skip for Done on the last page.
func _show_page() -> void:
	var page: Dictionary = PAGES[page_index]
	var is_last := page_index == page_count() - 1
	heading_label.text = tr(TITLE_KEY)
	page_title_label.text = tr(String(page["title"]))
	page_icon.texture = load(String(page["icon"])) as Texture2D
	page_icon.modulate = Color.html(String(page["color"]))
	body_label.text = get_page_body(page_index)
	counter_label.text = tr(PAGE_COUNTER_KEY) % [str(page_index + 1), str(page_count())]
	skip_button.text = tr(SKIP_KEY)
	next_button.text = tr(NEXT_KEY)
	done_button.text = tr(DONE_KEY)
	skip_button.visible = not is_last
	next_button.visible = not is_last
	done_button.visible = is_last

## Builds the dialog card: heading, page counter, icon + page title, body and the action row.
func _build_card() -> void:
	var margin := MarginContainer.new()
	margin.name = "Margin"
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	for side: String in ["left", "right"]:
		margin.add_theme_constant_override("margin_%s" % side, UiTheme.SCREEN_GUTTER)
	for side: String in ["top", "bottom"]:
		margin.add_theme_constant_override("margin_%s" % side, 24)
	add_child(margin)
	card = PanelContainer.new()
	card.name = "Card"
	card.theme_type_variation = &"DialogPanel"
	card.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	# Same height on every page, so Next/Done stay under the player's thumb while paging.
	card.custom_minimum_size = Vector2(0, CARD_MIN_HEIGHT)
	margin.add_child(card)
	var content := VBoxContainer.new()
	content.name = "Content"
	content.add_theme_constant_override("separation", 14)
	card.add_child(content)

	heading_label = _create_label("Heading", &"CaptionLabel")
	content.add_child(heading_label)
	var title_row := HBoxContainer.new()
	title_row.name = "TitleRow"
	title_row.alignment = BoxContainer.ALIGNMENT_CENTER
	title_row.add_theme_constant_override("separation", 10)
	content.add_child(title_row)
	page_icon = TextureRect.new()
	page_icon.name = "PageIcon"
	page_icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	page_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	page_icon.custom_minimum_size = Vector2(36, 36)
	title_row.add_child(page_icon)
	page_title_label = _create_label("PageTitle", &"TitleLabel")
	# Long titles (Spanish) wrap next to the icon instead of widening the card past the screen.
	page_title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	page_title_label.custom_minimum_size = Vector2(160, 0)
	title_row.add_child(page_title_label)

	body_label = _create_label("Body")
	body_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	# A minimum width lets the wrapping label compute its height inside the shrinking card.
	body_label.custom_minimum_size = Vector2(240, 0)
	body_label.add_theme_font_size_override("font_size", 17)
	# The body takes the spare card height, which keeps the counter and buttons at the bottom.
	body_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content.add_child(body_label)

	counter_label = _create_label("PageCounter", &"CaptionLabel")
	content.add_child(counter_label)

	var actions := HBoxContainer.new()
	actions.name = "Actions"
	actions.add_theme_constant_override("separation", 10)
	content.add_child(actions)
	# Skip is neutral on the left; the forward action is the emphasised one on the right.
	skip_button = _create_button("SkipButton", &"")
	skip_button.pressed.connect(Callable(self, "skip"))
	actions.add_child(skip_button)
	next_button = _create_button("NextButton", &"PrimaryButton")
	next_button.pressed.connect(Callable(self, "next_page"))
	actions.add_child(next_button)
	done_button = _create_button("DoneButton", &"PrimaryButton")
	done_button.pressed.connect(Callable(self, "finish"))
	actions.add_child(done_button)

## Centred, wrapping label with an optional theme variation.
func _create_label(node_name: String, variation: StringName = &"") -> Label:
	var label := Label.new()
	label.name = node_name
	label.theme_type_variation = variation
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return label

## Action button that shares the row width with its siblings, at the primary touch height.
func _create_button(node_name: String, variation: StringName) -> Button:
	var button := Button.new()
	button.name = node_name
	button.theme_type_variation = variation
	button.custom_minimum_size = Vector2(0, UiTheme.PRIMARY_HEIGHT)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return button
