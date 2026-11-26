extends SceneTree
## Verifies the input-cooldown-after-screen-change change (DNG-9): real taps that arrive within
## SCREEN_CHANGE_INPUT_COOLDOWN_MSEC of a screen, modal or overlay change are ignored, and taps
## after the cooldown work. Taps are real InputEventMouseButton events pushed into the viewport.
## Run: godot --headless --path . -s res://tests/verify_input_cooldown.gd

const SettingsStore := preload("res://scripts/settings_store.gd")
const SaveGame := preload("res://scripts/save_game.gd")
const CombatRules := preload("res://scripts/combat_rules.gd")
const DungeonGenerator := preload("res://scripts/dungeon_generator.gd")
const TEST_SAVE_PATH := "user://verify_input_cooldown.json"
const TEST_SETTINGS_PATH := "user://verify_input_cooldown.cfg"

func _init() -> void:
	_reset_files()
	SettingsStore.save_locale("en", TEST_SETTINGS_PATH)
	var checks: Array[Callable] = [
		_check_tap_events_are_gated,
		_check_tap_after_won_fight_does_not_move,
		_check_double_tap_on_level_up_confirm_does_not_exit,
		_check_direct_calls_ignore_cooldown,
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
	_reset_files()
	quit(1)
	return false

## A real tap (left button press + release) at the centre of `control`, pushed into the root
## viewport in its own coordinates, so it goes through _input and the GUI like a player's tap.
func _tap(control: Control) -> void:
	var position := control.get_global_rect().get_center()
	for pressed: bool in [true, false]:
		var event := InputEventMouseButton.new()
		event.button_index = MOUSE_BUTTON_LEFT
		event.pressed = pressed
		event.position = position
		event.global_position = position
		get_root().push_input(event, true)

## Waits until the cooldown started by the last screen change has run out.
func _wait_for_cooldown(main: Control) -> void:
	await create_timer(main.SCREEN_CHANGE_INPUT_COOLDOWN_MSEC / 1000.0 + 0.1).timeout

## Starts a new game in a corridor: entrance, empty cell (player), a 1-life monster, a second
## monster (so the first kill does not complete the dungeon) and an empty cell.
func _main_before_monster() -> Control:
	var main := _new_main()
	await process_frame  # let the scene build its UI before using it
	main._start_new_game()
	CombatRules.begin_dungeon_experience(main.player_state)
	var weak_rat := {"name": "Rat", "level": 1, "life": 1, "current_life": 1, "max_life": 1, "armor": 0, "speed": 1, "strength": 1, "mana": 0, "experience": 2, "attacks": []}
	var other_rat := weak_rat.duplicate(true)
	main.dungeon = {"number_of_columns": 5, "number_of_rows": 1, "locations": [
		{"column": 1, "row": 1, "type": DungeonGenerator.LOCATION_ENTRANCE, "visible": true, "visited": true, "content": {}},
		{"column": 2, "row": 1, "type": DungeonGenerator.LOCATION_EMPTY, "visible": true, "visited": true, "content": {}},
		{"column": 3, "row": 1, "type": DungeonGenerator.LOCATION_MONSTER, "visible": true, "visited": false, "content": weak_rat},
		{"column": 4, "row": 1, "type": DungeonGenerator.LOCATION_MONSTER, "visible": false, "visited": false, "content": other_rat},
		{"column": 5, "row": 1, "type": DungeonGenerator.LOCATION_EMPTY, "visible": false, "visited": false, "content": {}},
	]}
	main.current_location = main.dungeon["locations"][1]
	main.previous_location = {}
	main.active_monster_location = {}
	main._mark_visible_locations()
	main._render_map()
	main._update_direction_buttons()
	main._update_exploration_actions()
	main._show_dungeon_explore_view()
	return main

# --- checks -----------------------------------------------------------------------------

## Both kinds of tap events (touch and the mouse events touch is emulated as) are gated.
func _check_tap_events_are_gated() -> bool:
	var main := _new_main()
	await process_frame
	var gates_touch: bool = main._is_tap_event(InputEventScreenTouch.new())
	var gates_mouse: bool = main._is_tap_event(InputEventMouseButton.new())
	var ignores_keys: bool = not main._is_tap_event(InputEventKey.new())
	var cooldown_ms: int = main.SCREEN_CHANGE_INPUT_COOLDOWN_MSEC
	_free_main(main)
	if not gates_touch or not gates_mouse or not ignores_keys:
		return _fail("The cooldown should gate screen touches and mouse buttons only.")
	if cooldown_ms < 200 or cooldown_ms > 500:
		return _fail("The input cooldown should be short (about 300 ms), got %d ms." % cooldown_ms)
	return true

## Reproduction 1: after a won fight, the next fast tap must not reach the next screen.
func _check_tap_after_won_fight_does_not_move() -> bool:
	var main: Control = await _main_before_monster()
	main.move_player("right")  # enters the encounter
	await process_frame
	await _wait_for_cooldown(main)
	main.next_attack_roll = 20.0
	main.next_dodge_roll = 1.0
	_tap(main.fight_button)  # wins the fight: the victory screen opens
	await process_frame
	var victory_shown: bool = main.fight_victory_modal.visible
	var cooling_after_victory: bool = main.is_input_cooldown_active()
	_tap(main.fight_victory_continue_button)  # fast second tap: must be swallowed
	var victory_kept: bool = main.fight_victory_modal.visible
	await _wait_for_cooldown(main)
	_tap(main.fight_victory_continue_button)  # deliberate tap: closes the victory screen
	await process_frame
	var back_on_map: bool = not main.fight_victory_modal.visible and main.dungeon_explore_view.visible
	var cooling_after_continue: bool = main.is_input_cooldown_active()
	var column_before := int(main.current_location["column"])
	_tap(main.move_left_button)  # fast tap on a move arrow: must not move the hero
	var column_after_fast_tap := int(main.current_location["column"])
	await _wait_for_cooldown(main)
	_tap(main.move_left_button)  # deliberate tap: moves
	var column_after_tap := int(main.current_location["column"])
	_free_main(main)
	if not victory_shown:
		return _fail("A real tap on Fight that defeats the monster should open the victory screen.")
	if not cooling_after_victory:
		return _fail("The test tapped too late: the cooldown had already expired.")
	if not victory_kept:
		return _fail("A tap during the cooldown must not press Continue on the victory screen.")
	if not back_on_map:
		return _fail("A tap after the cooldown should press Continue and return to the map.")
	if not cooling_after_continue:
		return _fail("The test tapped too late: the cooldown had already expired.")
	if column_after_fast_tap != column_before:
		return _fail("A fast tap right after the victory screen closed must not move the hero.")
	if column_after_tap != column_before - 1:
		return _fail("A tap after the cooldown should move the hero.")
	return true

## Reproduction 2: a double tap on Confirm in Level Up must not press Exit on the next screen.
func _check_double_tap_on_level_up_confirm_does_not_exit() -> bool:
	var main := _new_main()
	await process_frame
	main._start_new_game()
	main.player_state["reserved_progression_points"] = 1
	main._show_level_allocation_view()
	main._stage_level_point("strength")
	await process_frame
	await _wait_for_cooldown(main)
	_tap(main.allocation_confirm_button)  # confirms and returns to the hub
	await process_frame
	var on_hub: bool = main.new_game_view.visible
	var cooling: bool = main.is_input_cooldown_active()
	_tap(main.exit_button)  # second tap of the double tap lands on Exit
	var exit_ignored: bool = not main.action_confirmation.visible and main.new_game_view.visible
	await _wait_for_cooldown(main)
	_tap(main.exit_button)  # deliberate tap: asks to confirm leaving
	var exit_works: bool = main.action_confirmation.visible
	_free_main(main)
	if not on_hub:
		return _fail("A real tap on Confirm should apply the points and return to the hub.")
	if not cooling:
		return _fail("The test tapped too late: the cooldown had already expired.")
	if not exit_ignored:
		return _fail("The second tap of a double tap on Confirm must not press Exit on the hub.")
	if not exit_works:
		return _fail("A tap on Exit after the cooldown should ask for confirmation.")
	return true

## The cooldown gates real input only: direct method calls (tests, playtest bot) still act.
func _check_direct_calls_ignore_cooldown() -> bool:
	var main: Control = await _main_before_monster()
	main.move_player("left")  # just after a screen change, during the cooldown
	var moved := int(main.current_location["column"]) == 1
	var cooling: bool = main.is_input_cooldown_active()
	_free_main(main)
	if not cooling:
		return _fail("The direct-call check should run while the cooldown is active.")
	if not moved:
		return _fail("Direct method calls must not be blocked by the input cooldown.")
	return true
