extends SceneTree
## Verifies the energy-loss-feedback change: a one-time low-energy warning per run, the warning
## flag surviving in the saved run, and depletion results stating the dungeon experience lost.
## Run: godot --headless --path . -s res://tests/verify_energy_warning.gd

const SaveGame := preload("res://scripts/save_game.gd")
const SettingsStore := preload("res://scripts/settings_store.gd")
const CombatRules := preload("res://scripts/combat_rules.gd")
const DungeonGenerator := preload("res://scripts/dungeon_generator.gd")
const TEST_SAVE_PATH := "user://verify_energy_warning.json"
const TEST_SETTINGS_PATH := "user://verify_energy_warning.cfg"

func _init() -> void:
	_reset_files()
	SettingsStore.save_locale("en", TEST_SETTINGS_PATH)
	var checks: Array[Callable] = [
		_check_no_warning_above_threshold,
		_check_warning_once_per_run,
		_check_warning_flag_saved_with_run,
		_check_warning_without_experience,
		_check_warning_waits_for_feedback_overlay,
		_check_energy_depletion_states_experience_lost,
		_check_life_depletion_states_experience_lost,
		_check_spanish_strings_exist,
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

## Starts a new game inside a 5x1 corridor of empty cells (entrance at column 1), so every move
## right costs exactly the movement energy and nothing else happens.
func _main_in_corridor() -> Control:
	var main := _new_main()
	await process_frame  # let the scene build its UI before using it
	main._start_new_game()
	CombatRules.begin_dungeon_experience(main.player_state)
	var locations: Array = [{"column": 1, "row": 1, "type": DungeonGenerator.LOCATION_ENTRANCE, "visible": true, "visited": true, "content": {}}]
	for column in range(2, 6):
		locations.append({"column": column, "row": 1, "type": DungeonGenerator.LOCATION_EMPTY, "visible": true, "visited": false, "content": {}})
	main.dungeon = {"number_of_columns": 5, "number_of_rows": 1, "locations": locations}
	main.current_location = main.dungeon["locations"][0]
	main.previous_location = {}
	main.active_monster_location = {}
	main._mark_visible_locations()
	main._render_map()
	main._update_direction_buttons()
	main._update_exploration_actions()
	main._show_dungeon_explore_view()
	return main

## Energy value at which the warning must fire for the current maximum energy.
func _threshold(main: Control) -> int:
	var maximum := int(main.player_state["energy"])
	return maxi(1, ceili(maximum * main.LOW_ENERGY_WARNING_PERCENT / 100.0))

func _warning_visible(main: Control) -> bool:
	return main.game_result_modal.visible and main.game_result_title.text == main.tr("LOW_ENERGY_TITLE")

# --- checks -----------------------------------------------------------------------------

func _check_no_warning_above_threshold() -> bool:
	var main: Control = await _main_in_corridor()
	main.player_state["current_energy"] = _threshold(main) + 2  # still above after one step
	main.move_player("right")
	var shown := _warning_visible(main)
	_free_main(main)
	if shown:
		return _fail("The low-energy warning must not appear while energy stays above the threshold.")
	return true

func _check_warning_once_per_run() -> bool:
	var main: Control = await _main_in_corridor()
	main.player_state["dungeon_experience"] = 12
	main.player_state["current_energy"] = _threshold(main) + 1  # one step lands on the threshold
	main.move_player("right")
	var first_shown := _warning_visible(main)
	var message_ok: bool = main.game_result_message.text.contains(str(_threshold(main))) and main.game_result_message.text.contains("12")
	main._hide_game_result()
	main.move_player("right")
	var shown_again := _warning_visible(main)
	_free_main(main)
	if not first_shown:
		return _fail("Dropping to the low-energy threshold should show the low-energy warning.")
	if not message_ok:
		return _fail("The warning should state the remaining energy and the dungeon experience at risk.")
	if shown_again:
		return _fail("The low-energy warning should appear only once per run.")
	return true

func _check_warning_flag_saved_with_run() -> bool:
	var main: Control = await _main_in_corridor()
	main.player_state["current_energy"] = _threshold(main) + 1
	main.move_player("right")
	var snapshot: Dictionary = main._build_run_snapshot()
	_free_main(main)
	var dungeon: Dictionary = snapshot.get("dungeon", {})
	if not bool(dungeon.get("low_energy_warned", false)):
		return _fail("The warning flag must be stored in the saved run so a resumed run does not warn again.")
	return true

func _check_warning_without_experience() -> bool:
	var main: Control = await _main_in_corridor()
	main.player_state["dungeon_experience"] = 0
	main.player_state["current_energy"] = _threshold(main) + 1
	main.move_player("right")
	var expected: String = main.tr("LOW_ENERGY_MESSAGE_NO_EXPERIENCE") % str(_threshold(main))
	var ok: bool = _warning_visible(main) and main.game_result_message.text == expected
	_free_main(main)
	if not ok:
		return _fail("With no dungeon experience yet, the warning should use the variant without an XP amount.")
	return true

func _check_warning_waits_for_feedback_overlay() -> bool:
	var main: Control = await _main_in_corridor()
	main.player_state["current_energy"] = _threshold(main) + 1
	main._show_experience_overlay(3)  # e.g. the XP popup of a kill on this same action
	main.player_state["current_energy"] = _threshold(main)
	main._warn_if_energy_low()
	var hidden_during_overlay: bool = not _warning_visible(main)
	await create_timer(main.LOW_ENERGY_WARNING_DELAY_SECONDS + 0.2).timeout
	var shown_after: bool = _warning_visible(main)
	_free_main(main)
	if not hidden_during_overlay:
		return _fail("The warning must not cover a feedback overlay that is still visible.")
	if not shown_after:
		return _fail("The warning should appear once the feedback overlay has closed.")
	return true

func _check_energy_depletion_states_experience_lost() -> bool:
	var main: Control = await _main_in_corridor()
	main.player_state["dungeon_experience"] = 21
	main.player_state["current_energy"] = CombatRules.ENERGY_MOVE_COST  # the next step empties it
	main.move_player("right")
	var message: String = main.pending_game_result_message
	var expected: String = main.tr("DUNGEON_EXPERIENCE_LOST") % "21"
	var experience_after := int(main.player_state.get("dungeon_experience", -1))
	var depleted_text: String = main.tr("DUNGEON_ENERGY_DEPLETED")
	_free_main(main)
	if not message.contains(depleted_text) or not message.contains(expected):
		return _fail("Running out of energy should say how much dungeon experience was lost, got: %s" % message)
	if experience_after != 0:
		return _fail("Running out of energy must still reset the provisional dungeon experience.")
	return true

func _check_life_depletion_states_experience_lost() -> bool:
	var main: Control = await _main_in_corridor()
	main.player_state["dungeon_experience"] = 9
	main.player_state["current_life"] = 0
	main._exit_dungeon_if_player_depleted()
	var message: String = main.pending_game_result_message
	var expected: String = main.tr("DUNGEON_EXPERIENCE_LOST") % "9"
	var depleted_text: String = main.tr("DUNGEON_LIFE_DEPLETED")
	_free_main(main)
	if not message.contains(depleted_text) or not message.contains(expected):
		return _fail("Losing all life should also say how much dungeon experience was lost, got: %s" % message)
	return true

func _check_spanish_strings_exist() -> bool:
	TranslationServer.set_locale("es")
	var keys := ["LOW_ENERGY_TITLE", "LOW_ENERGY_MESSAGE", "LOW_ENERGY_MESSAGE_NO_EXPERIENCE", "DUNGEON_EXPERIENCE_LOST"]
	var missing: Array[String] = []
	for key: String in keys:
		if TranslationServer.translate(key) == key:
			missing.append(key)
	TranslationServer.set_locale("en")
	if not missing.is_empty():
		return _fail("Missing Spanish translations: %s" % ", ".join(missing))
	return true
