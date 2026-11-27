extends SceneTree
## Verifies the stat-help change (DNG-7): tapping any stat bar on the hub, the exploration HUD,
## the Level Up screen and the fight panel opens the shared popup with the stat's name and
## description; a tap anywhere (or back) closes it; the Level Up screen lists what each stat
## does and its gain per point; and every stat text has a Spanish translation.
## Taps are real input events pushed into the viewport, so mouse filters are exercised too.
## Run: godot --headless --path . -s res://tests/verify_stat_help.gd

const SaveGame := preload("res://scripts/save_game.gd")
const SettingsStore := preload("res://scripts/settings_store.gd")
const CombatRules := preload("res://scripts/combat_rules.gd")
const DungeonGenerator := preload("res://scripts/dungeon_generator.gd")
const StatHelp := preload("res://scripts/stat_help.gd")
const TEST_SAVE_PATH := "user://verify_stat_help.json"
const TEST_SETTINGS_PATH := "user://verify_stat_help.cfg"
## Hub and fight panel player stats, in the canonical screen order (DNG-19; the fight panel
## adds dungeon XP). Every list follows StatOrder.CANONICAL, checked in verify_stat_bars.gd.
const PLAYER_STAT_KEYS := ["life", "energy", "mana", "armor", "strength", "speed", "reputation", "experience"]
const EXPLORATION_STAT_KEYS := ["life", "energy", "mana", "experience", "dungeon_experience"]
const MONSTER_STAT_KEYS := ["life", "mana", "armor", "strength", "speed"]
const ALLOCATION_STAT_KEYS := ["life", "energy", "mana", "armor", "strength", "speed"]

var main: Control

func _init() -> void:
	SaveGame.delete_save(TEST_SAVE_PATH)
	SettingsStore.delete_settings(TEST_SETTINGS_PATH)
	SettingsStore.save_locale("en", TEST_SETTINGS_PATH)
	# The first-run tutorial is covered by its own test; mark it seen so it does not cover the bars.
	SettingsStore.save_tutorial_seen(true, TEST_SETTINGS_PATH)
	get_root().size = Vector2i(1080, 2220)
	main = (load("res://scenes/main.tscn") as PackedScene).instantiate() as Control
	main.save_path = TEST_SAVE_PATH
	main.settings_path = TEST_SETTINGS_PATH
	get_root().add_child(main)
	await process_frame

	var checks: Array[Callable] = [
		_check_hub_stats,
		_check_level_up_stats_and_guide,
		_check_exploration_stats,
		_check_fight_panel_stats,
		_check_back_closes_popup,
		_check_texts_and_translations,
	]
	for check: Callable in checks:
		var passed: bool = await check.call()
		if not passed:
			return
	_cleanup()
	quit(0)

# --- helpers ----------------------------------------------------------------------------

func _cleanup() -> void:
	if is_instance_valid(main):
		get_root().remove_child(main)
		main.free()
	SaveGame.delete_save(TEST_SAVE_PATH)
	SettingsStore.delete_settings(TEST_SETTINGS_PATH)

func _fail(message: String) -> bool:
	push_error(message)
	_cleanup()
	quit(1)
	return false

## Lets containers lay out after a screen change so global rects are final.
func _settle_layout() -> void:
	await process_frame
	await process_frame

## Sends a left-button press and release at `position` (viewport coordinates), like a tap.
## Waits first for the screen-change input cooldown (DNG-9) to run out, as a real player's
## deliberate tap would, so the tap is not swallowed.
func _tap(position: Vector2) -> void:
	var main := get_root().get_node_or_null("Main")
	while main != null and main.has_method("is_input_cooldown_active") and main.is_input_cooldown_active():
		await process_frame
	for pressed: bool in [true, false]:
		var event := InputEventMouseButton.new()
		event.button_index = MOUSE_BUTTON_LEFT
		event.pressed = pressed
		event.position = position
		event.global_position = position
		get_root().push_input(event, true)  # position is in viewport (logical) coordinates
	await process_frame

## Taps the centre of every row of `container` and expects the popup to explain `keys[i]`,
## then taps a screen corner and expects the popup to close. `screen_name` is for messages.
func _check_rows(rows: Array, keys: Array, screen_name: String) -> bool:
	if rows.size() != keys.size():
		return _fail("%s should have %d stat bars (got %d)." % [screen_name, keys.size(), rows.size()])
	var popup: StatHelp = main.stat_help_popup
	for index in rows.size():
		var row := rows[index] as Control
		var stat_key := String(keys[index])
		var screen := Rect2(Vector2.ZERO, main.get_viewport_rect().size)
		var centre := row.get_global_rect().get_center()
		if not screen.has_point(centre):
			return _fail("%s stat bar %s should be on screen to be tapped." % [screen_name, row.name])
		await _tap(centre)
		if not popup.is_open() or popup.shown_stat_key != stat_key:
			return _fail("Tapping %s %s should open the help for '%s' (open=%s, shown='%s')." % [screen_name, row.name, stat_key, popup.is_open(), popup.shown_stat_key])
		if popup.name_label.text != StatHelp.get_stat_name(stat_key) or popup.name_label.text == "" or popup.name_label.text.begins_with("STAT_"):
			return _fail("The %s help should show the stat name (got '%s')." % [stat_key, popup.name_label.text])
		var description: String = popup.description_label.text
		if description == "" or description.begins_with("STAT_") or description.contains("%s"):
			return _fail("The %s help should show a filled-in description (got '%s')." % [stat_key, description])
		await _tap(Vector2(4, 4))
		if popup.is_open():
			return _fail("A tap anywhere should close the %s help on %s." % [stat_key, screen_name])
	return true

## Allocation rows hold the stat bar under the name StatPreview, next to the +/- buttons.
func _allocation_stat_bars() -> Array:
	var bars: Array = []
	for row: Node in main.allocation_buttons_container.get_children():
		if not row.is_queued_for_deletion() and row.get_node_or_null("StatPreview") != null:
			bars.append(row.get_node("StatPreview"))
	return bars

## Starts a corridor run: entrance, empty cell, then a living Rat (for the fight panel).
func _start_corridor_run() -> void:
	CombatRules.begin_dungeon_experience(main.player_state)
	main.dungeon = {"number_of_columns": 3, "number_of_rows": 1, "locations": [
		{"column": 1, "row": 1, "type": DungeonGenerator.LOCATION_ENTRANCE, "visible": true, "visited": true, "content": {}},
		{"column": 2, "row": 1, "type": DungeonGenerator.LOCATION_EMPTY, "visible": true, "visited": false, "content": {}},
		{"column": 3, "row": 1, "type": DungeonGenerator.LOCATION_MONSTER, "visible": true, "visited": false,
			"content": {"name": "Rat", "level": 1, "life": 5, "current_life": 5, "max_life": 5, "armor": 1, "speed": 1, "strength": 1, "mana": 2, "experience": 2, "attacks": []}},
	]}
	main.current_location = main.dungeon["locations"][0]
	main.previous_location = {}
	main.active_monster_location = {}
	main._mark_visible_locations()
	main._render_map()
	main._update_direction_buttons()
	main._update_exploration_actions()
	main._show_dungeon_explore_view()

# --- checks -----------------------------------------------------------------------------

func _check_hub_stats() -> bool:
	main._start_new_game()
	await _settle_layout()
	return await _check_rows(main.stats_column.get_children(), PLAYER_STAT_KEYS, "Hub")

func _check_level_up_stats_and_guide() -> bool:
	main._show_level_allocation_view()
	await _settle_layout()
	if not await _check_rows(_allocation_stat_bars(), ALLOCATION_STAT_KEYS, "Level Up"):
		return false
	# Plus buttons still work: the bar wiring must not swallow taps on the row's buttons.
	var life_row := main.allocation_buttons_container.get_node("LifeAllocationRow") as Control
	var plus := life_row.get_node("PlusButton") as Button
	await _tap(plus.get_global_rect().get_center())
	await _settle_layout()
	if int(main.staged_allocation.get("life", 0)) != 1 or main.stat_help_popup.is_open():
		return _fail("Tapping + on Level Up should stage a point, not open the stat help.")
	var guide: VBoxContainer = main.allocation_stat_guide
	for stat_key: String in ALLOCATION_STAT_KEYS:
		var entry := guide.get_node_or_null("%sGuide" % stat_key.capitalize())
		if entry == null:
			return _fail("The Level Up stat guide should have an entry for %s." % stat_key)
		var heading := (entry.get_node("Heading/Name") as Label).text
		var growth := CombatRules.get_stat_growth_for_player(main.player_state, stat_key)
		if not heading.begins_with(StatHelp.get_stat_name(stat_key)) or not heading.contains("+%d" % growth):
			return _fail("The %s guide heading should name the stat and its +%d per point (got '%s')." % [stat_key, growth, heading])
		if (entry.get_node("Description") as Label).text != StatHelp.get_stat_description(stat_key):
			return _fail("The %s guide should show the shared stat description." % stat_key)
	main._show_new_game_view()
	return true

func _check_exploration_stats() -> bool:
	_start_corridor_run()
	await _settle_layout()
	return await _check_rows(main.exploration_stats_container.get_children(), EXPLORATION_STAT_KEYS, "Exploration")

func _check_fight_panel_stats() -> bool:
	main._show_monster_encounter(main.dungeon["locations"][2])
	await _settle_layout()
	if not await _check_rows(main.monster_stat_bars.get_children(), MONSTER_STAT_KEYS, "Fight panel (monster)"):
		return false
	var player_keys: Array = PLAYER_STAT_KEYS.duplicate()
	player_keys.append("dungeon_experience")
	return await _check_rows(main.encounter_player_stat_bars.get_children(), player_keys, "Fight panel (player)")

func _check_back_closes_popup() -> bool:
	main.stat_help_popup.show_stat("armor")
	main.handle_back()
	if main.stat_help_popup.is_open() or not main.monster_encounter_view.visible:
		return _fail("Back should close the stat help and keep the fight on screen.")
	return true

func _check_texts_and_translations() -> bool:
	var english: Dictionary = {}
	for stat_key: String in StatHelp.STAT_TEXT_KEYS:
		english[stat_key] = [StatHelp.get_stat_name(stat_key), StatHelp.get_stat_description(stat_key)]
	if not String(english["energy"][1]).contains("%d per step" % CombatRules.ENERGY_MOVE_COST):
		return _fail("The energy help should state the real step cost: %s" % english["energy"][1])
	if not String(english["speed"][1]).to_lower().contains("dodge"):
		return _fail("The speed help should explain dodging.")
	if not String(english["dungeon_experience"][1]).contains("Retreat"):
		return _fail("The dungeon XP help should explain it is kept on Retreat.")
	TranslationServer.set_locale("es")
	for stat_key: String in StatHelp.STAT_TEXT_KEYS:
		var spanish_name := StatHelp.get_stat_name(stat_key)
		var spanish_description := StatHelp.get_stat_description(stat_key)
		if spanish_description == english[stat_key][1] or spanish_description.begins_with("STAT_"):
			TranslationServer.set_locale("en")
			return _fail("The %s description should be translated to Spanish." % stat_key)
		if spanish_name.begins_with("STAT_"):
			TranslationServer.set_locale("en")
			return _fail("The %s name should be translated to Spanish." % stat_key)
	var hint := tr(StatHelp.CLOSE_HINT_KEY)
	var guide_title := tr("LEVEL_ALLOCATION_GUIDE_TITLE")
	TranslationServer.set_locale("en")
	if hint == tr(StatHelp.CLOSE_HINT_KEY) or guide_title == tr("LEVEL_ALLOCATION_GUIDE_TITLE"):
		return _fail("The close hint and the Level Up guide title should be translated to Spanish.")
	return true
