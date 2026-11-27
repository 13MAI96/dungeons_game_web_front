extends SceneTree
## Verifies the retreat-feedback change (DNG-17): away from the entrance the disabled Retreat
## button has a caption saying how to retreat, the entrance cell has a light-green highlight,
## an arrow at the map edge points to an entrance outside the visible window, and the retreat
## result says how much dungeon experience was kept and how far the next level is.
## Run: godot --headless --path . -s res://tests/verify_retreat_feedback.gd

const SaveGame := preload("res://scripts/save_game.gd")
const SettingsStore := preload("res://scripts/settings_store.gd")
const CombatRules := preload("res://scripts/combat_rules.gd")
const DungeonGenerator := preload("res://scripts/dungeon_generator.gd")
const TEST_SAVE_PATH := "user://verify_retreat_feedback.json"
const TEST_SETTINGS_PATH := "user://verify_retreat_feedback.cfg"
## English and Spanish caption of the disabled Retreat button.
const ENGLISH_HINT := "Return to the green entrance to retreat"
const SPANISH_HINT := "Volvé a la entrada verde para retirarte"

func _init() -> void:
	_reset_files()
	SettingsStore.save_locale("en", TEST_SETTINGS_PATH)
	SettingsStore.save_tutorial_seen(true, TEST_SETTINGS_PATH)
	var checks: Array[Callable] = [
		_check_hint_away_from_entrance,
		_check_hint_keeps_map_size,
		_check_hint_does_not_mix_with_rest_feedback,
		_check_disabled_retreat_tap_changes_nothing,
		_check_entrance_is_highlighted,
		_check_arrow_to_entrance_off_window,
		_check_summary_with_progress,
		_check_summary_without_experience,
		_check_summary_with_level_ready,
		_check_retreat_tap_shows_summary,
		_check_spanish_text,
	]
	for check: Callable in checks:
		var passed: bool = await check.call()
		if not passed:
			return
	_reset_files()
	quit(0)

# --- helpers ----------------------------------------------------------------------------

func _reset_files() -> void:
	SaveGame.delete_save(TEST_SAVE_PATH)
	SettingsStore.delete_settings(TEST_SETTINGS_PATH)

## Instantiates the real main scene with test-only save and settings paths.
func _new_main() -> Control:
	var main := (load("res://scenes/main.tscn") as PackedScene).instantiate() as Control
	main.save_path = TEST_SAVE_PATH
	main.settings_path = TEST_SETTINGS_PATH
	get_root().add_child(main)
	return main

func _free_main(main: Control) -> void:
	get_root().remove_child(main)
	main.free()

func _fail(message: String) -> bool:
	push_error(message)
	TranslationServer.set_locale("en")
	_reset_files()
	quit(1)
	return false

## Starts a new level-1 game inside an open grid of empty cells (`columns` x `rows`), with the
## entrance at column 1, row 1 and the player standing on `start` ([column, row]).
## Every cell is visible so the map shows the whole window.
func _main_in_dungeon(columns: int, rows: int, start: Array = [1, 1]) -> Control:
	var main := _new_main()
	await process_frame  # let the scene build its UI before using it
	main._start_new_game()
	CombatRules.begin_dungeon_experience(main.player_state)
	var locations: Array = []
	for row in range(1, rows + 1):
		for column in range(1, columns + 1):
			var type := DungeonGenerator.LOCATION_ENTRANCE if column == 1 and row == 1 else DungeonGenerator.LOCATION_EMPTY
			locations.append({"column": column, "row": row, "type": type, "visible": true, "visited": false, "content": {}})
	main.dungeon = {"number_of_columns": columns, "number_of_rows": rows, "locations": locations}
	main.current_location = DungeonGenerator.get_location(main.dungeon, int(start[0]), int(start[1]))
	main.previous_location = {}
	main.active_monster_location = {}
	main._mark_visible_locations()
	main._render_map()
	main._update_direction_buttons()
	main._update_exploration_actions()
	main._show_dungeon_explore_view()
	return main

## A real tap (press + release) at the centre of `control`, through the viewport and the GUI.
func _tap(control: Control) -> void:
	var position := control.get_global_rect().get_center()
	for pressed: bool in [true, false]:
		var event := InputEventMouseButton.new()
		event.button_index = MOUSE_BUTTON_LEFT
		event.pressed = pressed
		event.position = position
		event.global_position = position
		get_root().push_input(event, true)

## Waits until the input cooldown started by the last screen or modal change has run out, so a
## real tap is not swallowed.
func _wait_for_cooldown(main: Control) -> void:
	while main.is_input_cooldown_active():
		await create_timer(0.05).timeout

## Every node named `node_name` under `node`.
func _find_named(node: Node, node_name: String) -> Array[Node]:
	var found: Array[Node] = []
	for child: Node in node.get_children():
		if child.name == node_name:
			found.append(child)
		found.append_array(_find_named(child, node_name))
	return found

## Map cell index of [column, row] in the rendered window (cells are added row by row).
func _cell_index(main: Control, column: int, row: int) -> int:
	var window: Dictionary = main._get_map_window()
	return (row - int(window["start_row"])) * int(window["columns"]) + (column - int(window["start_column"]))

## Gives the player `dungeon_experience` in this run and `total` permanent experience, then
## retreats from the entrance. Returns the result message.
func _retreat_with(main: Control, dungeon_experience: int, total: int) -> String:
	main.player_state["dungeon_experience"] = dungeon_experience
	main.player_state["current_experience"] = total
	main._retreat()
	return String(main.game_result_message.text)

# --- Retreat reason ---------------------------------------------------------------------

## On the entrance the caption is empty and Retreat works; one step away Retreat is disabled
## and the caption says how to retreat.
func _check_hint_away_from_entrance() -> bool:
	var main: Control = await _main_in_dungeon(3, 1)
	var on_entrance := String(main.retreat_hint_label.text)
	var enabled_on_entrance := not bool(main.retreat_button.disabled)
	main.move_player("right")
	var away := String(main.retreat_hint_label.text)
	var disabled_away := bool(main.retreat_button.disabled)
	var visible_away := bool(main.retreat_hint_label.is_visible_in_tree())
	main.move_player("left")
	var back := String(main.retreat_hint_label.text)
	_free_main(main)
	if on_entrance != "" or not enabled_on_entrance:
		return _fail("On the entrance Retreat should be enabled with no reason, got \"%s\"." % on_entrance)
	if not disabled_away or away != ENGLISH_HINT or not visible_away:
		return _fail("Away from the entrance Retreat should be disabled with \"%s\", got \"%s\"." % [ENGLISH_HINT, away])
	if back != "":
		return _fail("Back on the entrance the Retreat reason should disappear, got \"%s\"." % back)
	return true

## The caption keeps its height when empty, so showing the reason does not resize the map.
func _check_hint_keeps_map_size() -> bool:
	var main: Control = await _main_in_dungeon(3, 1)
	await process_frame
	var size_on_entrance: int = main._get_map_cell_size()
	main.move_player("right")
	await process_frame
	var size_away: int = main._get_map_cell_size()
	_free_main(main)
	if size_on_entrance != size_away:
		return _fail("The Retreat reason should not change the map cell size (%d -> %d)." % [size_on_entrance, size_away])
	return true

## The Retreat reason has its own caption: the feedback line keeps only action messages and
## the Rest reason (DNG-16), so both reasons can be read at once.
func _check_hint_does_not_mix_with_rest_feedback() -> bool:
	var main: Control = await _main_in_dungeon(3, 1)
	main.move_player("right")
	main.player_state["current_mana"] = 0
	main._update_exploration_actions()
	var feedback := String(main.explore_feedback.text)
	var hint := String(main.retreat_hint_label.text)
	_free_main(main)
	if feedback.contains(ENGLISH_HINT):
		return _fail("The Retreat reason should not be written in the feedback line: \"%s\"." % feedback)
	if feedback != "Rest needs %d mana." % CombatRules.REST_MANA_COST or hint != ENGLISH_HINT:
		return _fail("Both reasons should be visible (feedback \"%s\", retreat \"%s\")." % [feedback, hint])
	return true

## A real tap on the disabled Retreat button does nothing: the run goes on.
func _check_disabled_retreat_tap_changes_nothing() -> bool:
	var main: Control = await _main_in_dungeon(3, 1)
	main.move_player("right")
	var energy := int(main.player_state["current_energy"])
	await process_frame
	await _wait_for_cooldown(main)
	_tap(main.retreat_button)
	await process_frame
	main._retreat()  # a call that bypasses the disabled button changes nothing either
	var still_exploring: bool = bool(main.dungeon_explore_view.visible) and not main.dungeon.is_empty()
	var result_shown := bool(main.game_result_modal.visible)
	var energy_after := int(main.player_state["current_energy"])
	var hint := String(main.retreat_hint_label.text)
	_free_main(main)
	if not still_exploring or result_shown or energy_after != energy:
		return _fail("Retreat away from the entrance should change nothing.")
	if hint != ENGLISH_HINT:
		return _fail("After a refused retreat the reason should stay visible, got \"%s\"." % hint)
	return true

# --- Entrance on the map ----------------------------------------------------------------

## The entrance cell, and only that cell, has the light-green ring; on the entrance the gold
## player marker is drawn above it.
func _check_entrance_is_highlighted() -> bool:
	var main: Control = await _main_in_dungeon(3, 1)
	var markers := _find_named(main.map_grid, "EntranceMarker")
	var entrance_cell: Control = main.map_cells[_cell_index(main, 1, 1)]
	# Read now: moving re-renders the map and frees these nodes.
	var child_names: Array[String] = []
	for child: Node in entrance_cell.get_children():
		child_names.append(String(child.name))
	var ring: StyleBoxFlat = null
	if markers.size() == 1:
		ring = (markers[0] as Panel).get_theme_stylebox("panel") as StyleBoxFlat
	var ring_is_light_green := ring != null and ring.border_color.is_equal_approx(main.ENTRANCE_HIGHLIGHT_COLOR)
	main.move_player("right")
	var markers_away := _find_named(main.map_grid, "EntranceMarker")
	var entrance_cell_away: Control = main.map_cells[_cell_index(main, 1, 1)]
	var marker_on_entrance_away := _find_named(entrance_cell_away, "EntranceMarker").size() == 1
	_free_main(main)
	if markers.size() != 1 or markers_away.size() != 1 or not marker_on_entrance_away:
		return _fail("Exactly one entrance cell should be highlighted (found %d, then %d)." % [markers.size(), markers_away.size()])
	var marker_index := child_names.find("EntranceMarker")
	var player_index := child_names.find("PlayerMarker")
	if marker_index < 0 or player_index < marker_index:
		return _fail("On the entrance the player marker should be drawn above the entrance highlight: %s" % [child_names])
	if not ring_is_light_green:
		return _fail("The entrance highlight should be a light-green ring.")
	return true

## When the entrance is outside the 5x7 window, an arrow on the nearest edge cell points to it;
## when the entrance is in the window, no arrow is drawn.
func _check_arrow_to_entrance_off_window() -> bool:
	# Long corridor: entrance at column 1, player at column 10, window columns 6..10.
	var main: Control = await _main_in_dungeon(10, 1, [10, 1])
	var arrows := _find_named(main.map_grid, "EntranceArrow")
	var arrow_cell_ok: bool = arrows.size() == 1 and arrows[0].get_parent() == main.map_cells[_cell_index(main, 6, 1)]
	var left_angle := (arrows[0] as Control).rotation if arrows.size() == 1 else 0.0
	_free_main(main)
	if not arrow_cell_ok:
		return _fail("An entrance to the left of the window should get one arrow on the left edge cell (found %d)." % arrows.size())
	if not is_equal_approx(absf(left_angle), PI):
		return _fail("The arrow should point left toward the entrance, rotation %f." % left_angle)

	# Large room: entrance at the top-left corner, player at (10, 12), window (6..10, 6..12).
	main = await _main_in_dungeon(10, 12, [10, 12])
	arrows = _find_named(main.map_grid, "EntranceArrow")
	var corner_ok: bool = arrows.size() == 1 and arrows[0].get_parent() == main.map_cells[_cell_index(main, 6, 6)]
	var diagonal_angle := (arrows[0] as Control).rotation if arrows.size() == 1 else 0.0
	_free_main(main)
	if not corner_ok:
		return _fail("An entrance up and to the left should get one arrow on the top-left window cell.")
	if diagonal_angle >= -PI / 2.0 or diagonal_angle <= -PI:
		return _fail("The arrow should point up and to the left, rotation %f." % diagonal_angle)

	# Entrance inside the window: no arrow.
	main = await _main_in_dungeon(10, 1, [3, 1])
	arrows = _find_named(main.map_grid, "EntranceArrow")
	_free_main(main)
	if not arrows.is_empty():
		return _fail("No arrow should be drawn while the entrance is inside the visible window.")
	return true

# --- Retreat result ---------------------------------------------------------------------

## The result says how much experience was kept and how far the next level is, and the total
## includes the banked experience.
func _check_summary_with_progress() -> bool:
	var main: Control = await _main_in_dungeon(3, 1)
	var message := _retreat_with(main, 47, 20)
	var title := String(main.game_result_title.text)
	var total := int(main.player_state["current_experience"])
	var dungeon_experience := int(main.player_state["dungeon_experience"])
	_free_main(main)
	var expected := "You returned safely from the dungeon.\nYou kept +47 experience from this run.\nTotal experience: 67 / 100 (33 more for level 2)."
	if title != "Expedition ended" or message != expected:
		return _fail("The retreat result should be \"%s\", got \"%s\" / \"%s\"." % [expected, title, message])
	if total != 67 or dungeon_experience != 0:
		return _fail("Retreating should bank the dungeon experience (total %d, dungeon %d)." % [total, dungeon_experience])
	return true

## A run that earned nothing says so instead of "+0".
func _check_summary_without_experience() -> bool:
	var main: Control = await _main_in_dungeon(3, 1)
	var message := _retreat_with(main, 0, 0)
	_free_main(main)
	var expected := "You returned safely from the dungeon.\nYou earned no experience in this run.\nTotal experience: 0 / 100 (100 more for level 2)."
	if message != expected:
		return _fail("An empty run should say no experience was earned: \"%s\"." % message)
	return true

## When the total reaches the next level the result points to Progression instead.
func _check_summary_with_level_ready() -> bool:
	var main: Control = await _main_in_dungeon(3, 1)
	var message := _retreat_with(main, 47, 90)
	_free_main(main)
	if not message.ends_with("Total experience: 137. You can level up in Progression."):
		return _fail("A total above the threshold should say a level up is ready: \"%s\"." % message)
	return true

## A real tap on Retreat at the entrance ends the run and shows the summary.
func _check_retreat_tap_shows_summary() -> bool:
	var main: Control = await _main_in_dungeon(3, 1)
	main.player_state["dungeon_experience"] = 12
	await process_frame
	await _wait_for_cooldown(main)
	_tap(main.retreat_button)
	await process_frame
	var shown := bool(main.game_result_modal.visible)
	var message := String(main.game_result_message.text)
	_free_main(main)
	if not shown or not message.contains("You kept +12 experience from this run."):
		return _fail("Tapping Retreat on the entrance should show the kept experience, got \"%s\"." % message)
	return true

func _check_spanish_text() -> bool:
	var main: Control = await _main_in_dungeon(3, 1)
	main._select_locale("es")
	main.move_player("right")
	var hint := String(main.retreat_hint_label.text)
	main.move_player("left")
	var message := _retreat_with(main, 47, 20)
	main._select_locale("en")
	_free_main(main)
	if hint != SPANISH_HINT:
		return _fail("The Spanish Retreat reason should be \"%s\", got \"%s\"." % [SPANISH_HINT, hint])
	var expected := "Regresaste a salvo de la mazmorra.\nTe llevás +47 de experiencia de esta expedición.\nExperiencia total: 67 / 100 (faltan 33 para el nivel 2)."
	if message != expected:
		return _fail("The Spanish retreat result should be \"%s\", got \"%s\"." % [expected, message])
	return true
