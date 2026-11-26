extends SceneTree
## Verifies the release-gameplay-fixes change: single-use sanctuary, victory before depletion,
## unaffordable Fight, integer class growth, crash-safe saves, run resume, back navigation,
## abandon, unreadable-save protection and the convertible level-up indicator.

const SaveGame := preload("res://scripts/save_game.gd")
const SettingsStore := preload("res://scripts/settings_store.gd")
const CombatRules := preload("res://scripts/combat_rules.gd")
const DungeonGenerator := preload("res://scripts/dungeon_generator.gd")
const AdSlotConfig := preload("res://scripts/ad_slot_config.gd")
const TEST_SAVE_PATH := "user://verify_release_fixes.json"
const TEST_SETTINGS_PATH := "user://verify_release_fixes.cfg"

func _init() -> void:
	_reset_files()
	SettingsStore.save_locale("en", TEST_SETTINGS_PATH)
	var checks: Array[Callable] = [
		_check_class_growth_integers,
		_check_sanctuary_single_use,
		_check_victory_before_depletion,
		_check_unaffordable_fight,
		_check_save_recovery,
		_check_run_resume,
		_check_back_navigation,
		_check_abandon_expedition,
		_check_unreadable_save_protected,
		_check_convertible_level_indicator,
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

## A 3x1 corridor: entrance, sanctuary, monster.
func _corridor_dungeon(main: Control) -> void:
	main.dungeon = {"number_of_columns": 3, "number_of_rows": 1, "locations": [
		{"column": 1, "row": 1, "type": DungeonGenerator.LOCATION_ENTRANCE, "visible": true, "visited": true, "content": {}},
		{"column": 2, "row": 1, "type": DungeonGenerator.LOCATION_SANCTUARY, "visible": true, "visited": false, "content": {}},
		{"column": 3, "row": 1, "type": DungeonGenerator.LOCATION_MONSTER, "visible": true, "visited": false,
			"content": {"name": "Rat", "level": 1, "life": 1, "current_life": 1, "max_life": 1, "armor": 0, "speed": 1, "strength": 1, "mana": 0, "experience": 2, "attacks": []}},
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

func _check_class_growth_integers() -> bool:
	for player_class: Dictionary in CombatRules.load_player_classes():
		var growth: Dictionary = player_class["progression"]["stat_growth"]
		for stat: String in growth:
			var value: float = float(growth[stat])
			if value < 1.0 or not is_equal_approx(value, roundf(value)):
				return _fail("Class %s growth for %s should be a whole number >= 1 (got %s)." % [player_class["id"], stat, growth[stat]])
	return true

func _check_sanctuary_single_use() -> bool:
	var main := _new_main()
	await process_frame
	main._start_new_game()
	CombatRules.begin_dungeon_experience(main.player_state)
	_corridor_dungeon(main)
	main.player_state["current_life"] = 2
	main.move_player("right")
	var healed := int(main.player_state["current_life"])
	if healed <= 2:
		_free_main(main)
		return _fail("Entering an unused sanctuary should heal.")
	main.move_player("left")
	main.player_state["current_life"] = 2
	main.move_player("right")
	var reused := int(main.player_state["current_life"])
	_free_main(main)
	if reused != 2:
		return _fail("Re-entering a used sanctuary should not heal again.")
	return true

func _check_victory_before_depletion() -> bool:
	var main := _new_main()
	await process_frame
	main._start_new_game()
	CombatRules.begin_dungeon_experience(main.player_state)
	_corridor_dungeon(main)
	main.dungeon["locations"][1]["visited"] = true
	main.current_location = main.dungeon["locations"][1]
	main._show_monster_encounter(main.dungeon["locations"][2])
	main.player_state["current_energy"] = int(CombatRules.get_player_ability("basic_attack")["energy_cost"])  # exactly one attack
	main.next_attack_roll = 20.0
	main.next_dodge_roll = 1.0
	main._fight()
	var completed: bool = main.game_result_modal.visible and main.game_result_title.text == main.tr("RESULT_COMPLETED_TITLE")
	var reputation := int(main.player_state.get("current_reputation", 0))
	_free_main(main)
	if not completed or reputation < 1:
		return _fail("Defeating the last monster with the last energy should complete the dungeon, not end it as depleted.")
	return true

func _check_unaffordable_fight() -> bool:
	var main := _new_main()
	await process_frame
	main._start_new_game()
	CombatRules.begin_dungeon_experience(main.player_state)
	_corridor_dungeon(main)
	main.player_state["current_energy"] = int(CombatRules.get_player_ability("basic_attack")["energy_cost"]) - 1
	main._show_monster_encounter(main.dungeon["locations"][2])
	var ok: bool = main.fight_button.disabled and not main.flee_button.disabled \
		and main.encounter_feedback.text.contains(main.tr("ENCOUNTER_CANNOT_AFFORD_ATTACK"))
	_free_main(main)
	if not ok:
		return _fail("Fight should be disabled with an explanation when the attack cannot be paid; Flee stays enabled.")
	return true

func _check_save_recovery() -> bool:
	_reset_files()
	var player := CombatRules.create_default_player()
	player["level"] = 7
	if not SaveGame.save_player(player, TEST_SAVE_PATH):
		return _fail("Save should be written.")
	if FileAccess.file_exists(TEST_SAVE_PATH + ".tmp"):
		return _fail("A completed save should not leave a temporary file behind.")
	# Simulate a crash after the temp file was written but before it replaced the main file.
	var temp := FileAccess.open(TEST_SAVE_PATH + ".tmp", FileAccess.WRITE)
	player["level"] = 8
	temp.store_string(JSON.stringify({"version": SaveGame.SAVE_VERSION, "player": player}))
	temp.close()
	DirAccess.remove_absolute(ProjectSettings.globalize_path(TEST_SAVE_PATH))
	var loaded := SaveGame.load_player(CombatRules.create_default_player(), TEST_SAVE_PATH)
	if not bool(loaded.get("success", false)) or int(loaded["player"]["level"]) != 8:
		return _fail("A complete temporary save should be recovered when the main file is missing.")
	# Version 1 saves remain loadable.
	var v1 := FileAccess.open(TEST_SAVE_PATH, FileAccess.WRITE)
	v1.store_string(JSON.stringify({"version": 1, "player": CombatRules.create_default_player()}))
	v1.close()
	DirAccess.remove_absolute(ProjectSettings.globalize_path(TEST_SAVE_PATH + ".tmp"))
	if not bool(SaveGame.load_player(CombatRules.create_default_player(), TEST_SAVE_PATH).get("success", false)):
		return _fail("Version 1 saves should still load.")
	_reset_files()
	return true

func _check_run_resume() -> bool:
	_reset_files()
	SettingsStore.save_locale("en", TEST_SETTINGS_PATH)
	var main := _new_main()
	await process_frame
	main._start_new_game()
	CombatRules.begin_dungeon_experience(main.player_state)
	_corridor_dungeon(main)
	main.move_player("right")  # sanctuary, then checkpoint
	main.player_state["dungeon_experience"] = 4
	main.move_player("right")  # monster: encounter starts, checkpoint
	var energy := int(main.player_state["current_energy"])
	_free_main(main)

	var resumed := _new_main()
	await process_frame
	resumed._load_game()
	var ok: bool = resumed.monster_encounter_view.visible \
		and int(resumed.current_location["column"]) == 3 \
		and not resumed.active_monster_location.is_empty() \
		and int(resumed.player_state["dungeon_experience"]) == 4 \
		and int(resumed.player_state["current_energy"]) == energy \
		and bool(resumed.player_state["in_dungeon"]) \
		and typeof(resumed.dungeon["locations"][0]["column"]) == TYPE_INT
	var sanctuary_used := bool(resumed.dungeon["locations"][1]["visited"])
	_free_main(resumed)
	if not ok:
		return _fail("Loading a save with an active run should resume the same dungeon, position, encounter and provisional experience.")
	if not sanctuary_used:
		return _fail("The resumed run should remember the used sanctuary.")
	_reset_files()
	return true

func _check_back_navigation() -> bool:
	var main := _new_main()
	await process_frame
	main._show_settings_view()
	main.handle_back()
	if not main.main_menu_view.visible:
		_free_main(main)
		return _fail("Back from settings should return to the main menu.")
	main.handle_back()
	if not main.action_confirmation.visible or main.confirmation_title.text != main.tr("CONFIRM_QUIT_TITLE"):
		_free_main(main)
		return _fail("Back on the main menu should ask before quitting.")
	main.handle_back()
	if main.action_confirmation.visible:
		_free_main(main)
		return _fail("Back should cancel an open confirmation.")
	main._start_new_game()
	main._show_level_allocation_view()
	main.handle_back()
	if not main.new_game_view.visible:
		_free_main(main)
		return _fail("Back from level-up should return to the hub.")
	main.handle_back()
	if not main.action_confirmation.visible or main.confirmation_title.text != main.tr("CONFIRM_EXIT_TITLE"):
		_free_main(main)
		return _fail("Back on the hub should show the leave-to-menu confirmation.")
	main._cancel_pending_action()
	CombatRules.begin_dungeon_experience(main.player_state)
	_corridor_dungeon(main)
	main._show_monster_encounter(main.dungeon["locations"][2])
	main.handle_back()
	var encounter_kept: bool = main.monster_encounter_view.visible and not main.action_confirmation.visible
	_free_main(main)
	if not encounter_kept:
		return _fail("Back during an encounter should do nothing.")
	if ProjectSettings.get_setting("application/config/quit_on_go_back", true):
		return _fail("quit_on_go_back should be disabled so back is handled in-game.")
	return true

func _check_abandon_expedition() -> bool:
	var main := _new_main()
	await process_frame
	main._start_new_game()
	main.player_state["current_experience"] = 10
	CombatRules.begin_dungeon_experience(main.player_state)
	_corridor_dungeon(main)
	main.player_state["dungeon_experience"] = 6
	main.player_state["current_life"] = 3
	main.handle_back()
	if not main.action_confirmation.visible or main.confirmation_title.text != main.tr("CONFIRM_ABANDON_TITLE"):
		_free_main(main)
		return _fail("Back during exploration should offer to abandon the expedition.")
	main._confirm_pending_action()
	var ok: bool = main.new_game_view.visible and main.game_result_modal.visible \
		and int(main.player_state["current_experience"]) == 10 \
		and int(main.player_state["dungeon_experience"]) == 0 \
		and not bool(main.player_state["in_dungeon"]) \
		and int(main.player_state["current_life"]) == int(main.player_state["life"])
	_free_main(main)
	var saved := SaveGame.load_player(CombatRules.create_default_player(), TEST_SAVE_PATH)
	if not ok or not (saved.get("run", {}) as Dictionary).is_empty():
		return _fail("Abandoning should discard run experience, restore status, show the result and leave no active run saved.")
	return true

func _check_unreadable_save_protected() -> bool:
	var file := FileAccess.open(TEST_SAVE_PATH, FileAccess.WRITE)
	file.store_string("{ this is not json")
	file.close()
	var main := _new_main()
	await process_frame
	main._request_new_game()
	var asked: bool = main.action_confirmation.visible
	var untouched := FileAccess.get_file_as_string(TEST_SAVE_PATH) == "{ this is not json"
	_free_main(main)
	if not asked or not untouched:
		return _fail("Start Game should confirm before replacing an unreadable save.")
	_reset_files()
	return true

func _check_convertible_level_indicator() -> bool:
	SettingsStore.save_locale("en", TEST_SETTINGS_PATH)
	var main := _new_main()
	await process_frame
	main._start_new_game()
	main.player_state["reserved_progression_points"] = 0
	main.player_state["pending_level_points"] = 0
	main.player_state["current_experience"] = CombatRules.get_experience_threshold(1)
	main._apply_player_stats()
	main._show_new_game_view()
	var shown: bool = main.progression_indicator.visible
	_free_main(main)
	if not shown:
		return _fail("The progression indicator should show when experience allows a level-up.")
	return true
