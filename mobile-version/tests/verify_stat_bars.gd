extends SceneTree
## Verifies the readable-stat-bars change (DNG-18): the "current/max" number of every stat bar
## is drawn beside the bar, right-aligned in a fixed-width column, never over the coloured fill
## or the dark empty track, so it reads the same at any fill level. On a small (1080x2220) and
## a large (1440x3088) phone, with large values, the hub, the exploration HUD, the Level Up rows
## and both sides of the fight panel fit the screen width, and a real tap on the number still
## opens the stat help.
## Run: godot --headless --path . -s res://tests/verify_stat_bars.gd

const SaveGame := preload("res://scripts/save_game.gd")
const SettingsStore := preload("res://scripts/settings_store.gd")
const CombatRules := preload("res://scripts/combat_rules.gd")
const DungeonGenerator := preload("res://scripts/dungeon_generator.gd")
const UiTheme := preload("res://scripts/ui_theme.gd")
const TEST_SAVE_PATH := "user://verify_stat_bars.json"
const TEST_SETTINGS_PATH := "user://verify_stat_bars.cfg"
## Phone resolutions in physical pixels: the small and large phones from the ticket, plus a
## tall 20:9 phone, the narrowest logical width of the three.
const PHONE_SIZES := [Vector2i(1080, 2220), Vector2i(1440, 3088), Vector2i(1080, 2400)]
## WCAG AA contrast for normal-size text; the numbers must reach it on every row background.
const MIN_TEXT_CONTRAST := 4.5
## A stat bar must keep at least this much track (logical px) to still show its fill.
const MIN_TRACK_WIDTH := 24.0
## Layout tolerance in logical px (rects are floats after the stretch scaling).
const EPSILON := 0.5
## Both game languages: the Spanish XP labels are the longest stat row texts.
const LOCALES := ["en", "es"]
## Large values for every player stat: the widest numbers a late-game hero can show.
const STRESS_PLAYER_VALUES := {
	"life": 999, "current_life": 1,
	"energy": 999, "current_energy": 500,
	"mana": 999, "current_mana": 0,
	"armor": 999, "strength": 999, "speed": 999,
	"reputation": 999,
	"current_experience": 12345, "experience_next_level": 23456,
	"dungeon_experience": 12345,
}

var main: Control

func _init() -> void:
	for locale: String in LOCALES:
		for phone_size: Vector2i in PHONE_SIZES:
			_reset_files(locale)
			get_root().size = phone_size
			main = _new_main()
			await process_frame
			var checks: Array[Callable] = [
				_check_value_colours,
				_check_hub,
				_check_level_up,
				_check_exploration_and_fight,
				_check_tap_on_value_opens_help,
			]
			for check: Callable in checks:
				var passed: bool = await check.call(phone_size)
				if not passed:
					return
			_free_main()
	_reset_files("en")
	TranslationServer.set_locale("en")
	quit(0)

# --- helpers ----------------------------------------------------------------------------

## Clears the test save and writes settings for `locale` with the tutorial already seen.
func _reset_files(locale: String) -> void:
	SaveGame.delete_save(TEST_SAVE_PATH)
	SettingsStore.delete_settings(TEST_SETTINGS_PATH)
	SettingsStore.save_locale(locale, TEST_SETTINGS_PATH)
	# The first-run tutorial has its own test; mark it seen so it does not cover the bars.
	SettingsStore.save_tutorial_seen(true, TEST_SETTINGS_PATH)

## Instantiates the real main scene with test-only save and settings paths.
func _new_main() -> Control:
	var instance := (load("res://scenes/main.tscn") as PackedScene).instantiate() as Control
	instance.save_path = TEST_SAVE_PATH
	instance.settings_path = TEST_SETTINGS_PATH
	get_root().add_child(instance)
	return instance

func _free_main() -> void:
	if is_instance_valid(main):
		get_root().remove_child(main)
		main.free()

func _fail(message: String) -> bool:
	push_error("[%s] %s" % [TranslationServer.get_locale(), message])
	_free_main()
	_reset_files("en")
	quit(1)
	return false

## Lets containers lay out after a screen change so global rects are final.
func _settle_layout() -> void:
	for i in 3:
		await process_frame

## Sends a real tap (press and release) at `position`, after the screen-change input
## cooldown (DNG-9) runs out, as a player's deliberate tap would.
func _tap(position: Vector2) -> void:
	while main.is_input_cooldown_active():
		await process_frame
	for pressed: bool in [true, false]:
		var event := InputEventMouseButton.new()
		event.button_index = MOUSE_BUTTON_LEFT
		event.pressed = pressed
		event.position = position
		event.global_position = position
		get_root().push_input(event, true)
	await process_frame

## WCAG relative luminance of an sRGB colour (channels linearized first).
func _relative_luminance(colour: Color) -> float:
	var linear := colour.srgb_to_linear()
	return 0.2126 * linear.r + 0.7152 * linear.g + 0.0722 * linear.b

## WCAG contrast ratio between two colours (1 to 21).
func _contrast_ratio(first: Color, second: Color) -> float:
	var lighter := maxf(_relative_luminance(first), _relative_luminance(second))
	var darker := minf(_relative_luminance(first), _relative_luminance(second))
	return (lighter + 0.05) / (darker + 0.05)

## Starts a new game and gives the hero the widest values a late-game hero can show.
func _start_stressed_game() -> void:
	main._start_new_game()
	for key: String in STRESS_PLAYER_VALUES:
		main.player_state[key] = STRESS_PLAYER_VALUES[key]
	main._apply_player_stats()

## Checks every stat row of `rows` on `screen_name`: the Value label is a sibling of the bar
## (not drawn on it), sits right of the track without overlapping it, shows "current/max",
## is not clipped, and the row fits the viewport width. All numbers share one right edge.
func _check_rows(rows: Array, screen_name: String) -> bool:
	if rows.is_empty():
		return _fail("%s should show stat bars." % screen_name)
	var viewport_width: float = main.get_viewport_rect().size.x
	var right_edge := -1.0
	for row_variant: Variant in rows:
		var row := row_variant as Control
		var bar := row.get_node_or_null("Bar") as ProgressBar
		var value := row.get_node_or_null("Value") as Label
		if bar == null or value == null:
			return _fail("%s %s should have a Bar and a Value beside it." % [screen_name, row.name])
		if bar.get_node_or_null("Value") != null:
			return _fail("%s %s should not draw its number over the bar." % [screen_name, row.name])
		var bar_rect := bar.get_global_rect()
		var value_rect := value.get_global_rect()
		if value_rect.position.x < bar_rect.end.x - EPSILON:
			return _fail("%s %s: the number should sit right of the bar, not on it (bar %s, value %s)." % [screen_name, row.name, bar_rect, value_rect])
		if value.horizontal_alignment != HORIZONTAL_ALIGNMENT_RIGHT or value_rect.size.x < main.STAT_VALUE_MIN_WIDTH - EPSILON:
			return _fail("%s %s: the number should be right-aligned in a fixed-width column." % [screen_name, row.name])
		if value_rect.size.x < value.get_minimum_size().x - EPSILON:
			return _fail("%s %s: the number '%s' should not be clipped." % [screen_name, row.name, value.text])
		if not value.text.contains("/"):
			return _fail("%s %s should show current/max (got '%s')." % [screen_name, row.name, value.text])
		var label := row.get_node_or_null("Label") as Label
		if label != null:
			var text_width := label.get_theme_font("font").get_string_size(label.text, HORIZONTAL_ALIGNMENT_LEFT, -1, label.get_theme_font_size("font_size")).x
			if text_width > label.size.x + EPSILON:
				return _fail("%s %s: the label '%s' should fit without being trimmed (%.1f > %.1f)." % [screen_name, row.name, label.text, text_width, label.size.x])
		if bar_rect.size.x < MIN_TRACK_WIDTH:
			return _fail("%s %s: the bar track should keep at least %d px (got %.1f)." % [screen_name, row.name, MIN_TRACK_WIDTH, bar_rect.size.x])
		var row_rect := row.get_global_rect()
		if row_rect.position.x < -EPSILON or row_rect.end.x > viewport_width + EPSILON or value_rect.end.x > viewport_width + EPSILON:
			return _fail("%s %s should fit the %.0f px wide screen (row %s)." % [screen_name, row.name, viewport_width, row_rect])
		if right_edge >= 0.0 and absf(value_rect.end.x - right_edge) > EPSILON:
			return _fail("%s: the numbers should line up on one right edge (%s at %.1f, expected %.1f)." % [screen_name, row.name, value_rect.end.x, right_edge])
		right_edge = value_rect.end.x
	return true

# --- checks -----------------------------------------------------------------------------

## The numbers use light text on the dark row backgrounds (not the stat colour or an outline
## over the fill), with at least AA contrast on the screen background and on the cards
## (exploration HUD) where stat rows are drawn.
func _check_value_colours(_phone_size: Vector2i) -> bool:
	_start_stressed_game()
	await _settle_layout()
	var value := main.stats_column.get_node("LifeStatBar/Value") as Label
	var text_colour := value.get_theme_color("font_color")
	for background: Color in [UiTheme.BACKGROUND, UiTheme.SURFACE]:
		var ratio := _contrast_ratio(text_colour, background)
		if ratio < MIN_TEXT_CONTRAST:
			return _fail("Stat numbers should contrast at least %.1f:1 with %s (got %.2f)." % [MIN_TEXT_CONTRAST, background.to_html(), ratio])
	if value.get_theme_font_size("font_size") < UiTheme.FONT_STAT_VALUE:
		return _fail("Stat numbers should use at least the stat value font size.")
	return true

func _check_hub(phone_size: Vector2i) -> bool:
	_start_stressed_game()
	await _settle_layout()
	if (main.stats_column.get_node("LifeStatBar/Value") as Label).text != "1/999":
		return _fail("The hub life number should read 1/999 at a nearly empty bar.")
	return _check_rows(main.stats_column.get_children(), "Hub %s" % phone_size)

## Level Up rows: the StatPreview bar and its number fit next to the points and +/- buttons,
## and the + button stays inside the visible scroll area.
func _check_level_up(phone_size: Vector2i) -> bool:
	_start_stressed_game()
	main._show_level_allocation_view()
	await _settle_layout()
	var screen_name := "Level Up %s" % phone_size
	var rows: Array = []
	var scroll_rect := Rect2(Vector2.ZERO, main.get_viewport_rect().size)
	var scroll: Node = main.allocation_buttons_container.get_parent()
	while scroll != null and not scroll is ScrollContainer:
		scroll = scroll.get_parent()
	if scroll != null:
		scroll_rect = (scroll as ScrollContainer).get_global_rect()
	for allocation_row: Node in main.allocation_buttons_container.get_children():
		if allocation_row.is_queued_for_deletion():
			continue
		rows.append(allocation_row.get_node("StatPreview"))
		var plus := allocation_row.get_node("PlusButton") as Control
		if plus.get_global_rect().end.x > scroll_rect.end.x + EPSILON:
			return _fail("%s: the + button of %s should stay inside the screen." % [screen_name, allocation_row.name])
	var passed := _check_rows(rows, screen_name)
	main._show_new_game_view()
	return passed

## Exploration HUD and both sides of the fight panel, against a monster with large values.
func _check_exploration_and_fight(phone_size: Vector2i) -> bool:
	_start_stressed_game()
	CombatRules.begin_dungeon_experience(main.player_state)
	main.player_state["dungeon_experience"] = 12345
	main.dungeon = {"number_of_columns": 3, "number_of_rows": 1, "locations": [
		{"column": 1, "row": 1, "type": DungeonGenerator.LOCATION_ENTRANCE, "visible": true, "visited": true, "content": {}},
		{"column": 2, "row": 1, "type": DungeonGenerator.LOCATION_EMPTY, "visible": true, "visited": false, "content": {}},
		{"column": 3, "row": 1, "type": DungeonGenerator.LOCATION_MONSTER, "visible": true, "visited": false,
			"content": {"name": "Golem", "level": 30, "life": 999, "current_life": 3, "max_life": 999, "armor": 999, "speed": 999, "strength": 999, "mana": 999, "experience": 2, "attacks": []}},
	]}
	main.current_location = main.dungeon["locations"][0]
	main.previous_location = {}
	main.active_monster_location = {}
	main._mark_visible_locations()
	main._render_map()
	main._update_direction_buttons()
	main._update_exploration_actions()
	main._apply_player_stats()
	main._show_dungeon_explore_view()
	await _settle_layout()
	if not _check_rows(main.exploration_stats_container.get_children(), "Exploration %s" % phone_size):
		return false
	main._show_monster_encounter(main.dungeon["locations"][2])
	await _settle_layout()
	if not _check_rows(main.monster_stat_bars.get_children(), "Fight panel (monster) %s" % phone_size):
		return false
	return _check_rows(main.encounter_player_stat_bars.get_children(), "Fight panel (player) %s" % phone_size)

## The number is part of the tappable row: a real tap on it opens the help for that stat.
func _check_tap_on_value_opens_help(phone_size: Vector2i) -> bool:
	main.active_monster_location = {}
	main.dungeon = {}
	main._show_new_game_view()
	await _settle_layout()
	var value := main.stats_column.get_node("ArmorStatBar/Value") as Control
	await _tap(value.get_global_rect().get_center())
	if not main.stat_help_popup.is_open() or main.stat_help_popup.shown_stat_key != "armor":
		return _fail("Tapping the armor number on %s should open the armor help." % phone_size)
	await _tap(Vector2(4, 4))
	if main.stat_help_popup.is_open():
		return _fail("A tap anywhere should close the stat help.")
	return true
