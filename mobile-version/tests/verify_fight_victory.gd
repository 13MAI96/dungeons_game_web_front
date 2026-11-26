extends SceneTree
## Verifies the fight-victory-result change (DNG-10): a won fight shows a victory result with the
## translated monster name and the experience gained, Continue returns to the map, the last kill
## shows only the dungeon completion result, and a low-energy warning waits for Continue.
## Run: godot --headless --path . -s res://tests/verify_fight_victory.gd

const SaveGame := preload("res://scripts/save_game.gd")
const SettingsStore := preload("res://scripts/settings_store.gd")
const CombatRules := preload("res://scripts/combat_rules.gd")
const DungeonGenerator := preload("res://scripts/dungeon_generator.gd")
const TEST_SAVE_PATH := "user://verify_fight_victory.json"
const TEST_SETTINGS_PATH := "user://verify_fight_victory.cfg"
const RAT_EXPERIENCE := 3

func _init() -> void:
	_reset_files()
	SettingsStore.save_locale("en", TEST_SETTINGS_PATH)
	var checks: Array[Callable] = [
		_check_victory_shows_monster_and_experience,
		_check_continue_returns_to_map,
		_check_back_dismisses_victory,
		_check_spanish_victory_text,
		_check_last_monster_shows_single_completion_result,
		_check_low_energy_warning_waits_for_victory,
		_check_last_energy_kill_shows_depletion_only,
		_check_delayed_warning_waits_for_victory,
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
	TranslationServer.set_locale("en")
	_reset_files()
	quit(1)
	return false

func _rat() -> Dictionary:
	return {"name": "Rat", "level": 1, "life": 1, "current_life": 1, "max_life": 1, "armor": 0, "speed": 1, "strength": 1, "mana": 0, "experience": RAT_EXPERIENCE, "attacks": []}

## New game inside a corridor with `monster_count` one-life rats after the entrance, in an
## encounter with the first rat. The next _fight() with the forced rolls defeats it.
func _main_in_encounter(monster_count: int) -> Control:
	var main := _new_main()
	await process_frame  # let the scene build its UI before using it
	main._start_new_game()
	CombatRules.begin_dungeon_experience(main.player_state)
	var locations: Array = [{"column": 1, "row": 1, "type": DungeonGenerator.LOCATION_ENTRANCE, "visible": true, "visited": true, "content": {}}]
	for index in monster_count:
		locations.append({"column": index + 2, "row": 1, "type": DungeonGenerator.LOCATION_MONSTER, "visible": true, "visited": false, "content": _rat()})
	main.dungeon = {"number_of_columns": monster_count + 1, "number_of_rows": 1, "locations": locations}
	main.current_location = main.dungeon["locations"][0]
	main.previous_location = {}
	main.active_monster_location = {}
	main._mark_visible_locations()
	main._render_map()
	main._update_direction_buttons()
	main._update_exploration_actions()
	main._show_dungeon_explore_view()
	main.move_player("right")
	main.next_attack_roll = 20.0
	main.next_dodge_roll = 1.0
	return main

## Energy value at which the low-energy warning fires for the current maximum energy.
func _low_energy_threshold(main: Control) -> int:
	return maxi(1, ceili(int(main.player_state["energy"]) * main.LOW_ENERGY_WARNING_PERCENT / 100.0))

# --- checks -----------------------------------------------------------------------------

func _check_victory_shows_monster_and_experience() -> bool:
	var main: Control = await _main_in_encounter(2)
	main._fight()
	var shown: bool = main.fight_victory_modal.visible
	var title: String = main.fight_victory_title.text
	var message: String = main.fight_victory_message.text
	var expected_title: String = main.tr("FIGHT_VICTORY_TITLE")
	var expected_name: String = main.tr("FIGHT_VICTORY_DEFEATED") % "Rat"
	var expected_xp: String = main.tr("FIGHT_VICTORY_EXPERIENCE") % str(RAT_EXPERIENCE)
	var expected_total: String = main.tr("FIGHT_VICTORY_RUN_TOTAL") % str(RAT_EXPERIENCE)
	var no_xp_overlay: bool = not main.damage_overlay.visible
	_free_main(main)
	if not shown or title != expected_title:
		return _fail("Winning a fight should show the victory result.")
	if not message.contains(expected_name) or not message.contains(expected_xp) or not message.contains(expected_total):
		return _fail("The victory result should name the monster, the experience gained and the run total, got: %s" % message)
	if not no_xp_overlay:
		return _fail("The victory result replaces the short experience overlay; both must not show.")
	return true

func _check_continue_returns_to_map() -> bool:
	var main: Control = await _main_in_encounter(2)
	main._fight()
	main.fight_victory_continue_button.pressed.emit()
	var ok: bool = not main.fight_victory_modal.visible and main.dungeon_explore_view.visible and not main.monster_encounter_view.visible
	_free_main(main)
	if not ok:
		return _fail("Continue on the victory result should return to the dungeon map.")
	return true

func _check_back_dismisses_victory() -> bool:
	var main: Control = await _main_in_encounter(2)
	main._fight()
	main.handle_back()
	var ok: bool = not main.fight_victory_modal.visible and main.dungeon_explore_view.visible and not main.action_confirmation.visible
	_free_main(main)
	if not ok:
		return _fail("System back on the victory result should act like Continue.")
	return true

func _check_spanish_victory_text() -> bool:
	SettingsStore.save_locale("es", TEST_SETTINGS_PATH)
	var main: Control = await _main_in_encounter(2)
	main._fight()
	var title: String = main.fight_victory_title.text
	var message: String = main.fight_victory_message.text
	var button: String = main.fight_victory_continue_button.text
	_free_main(main)
	SettingsStore.save_locale("en", TEST_SETTINGS_PATH)
	TranslationServer.set_locale("en")
	if title != "¡Victoria!" or not message.contains("Rata") or button != "Continuar":
		return _fail("The victory result should be in Spanish with the translated monster name, got: %s / %s" % [title, message])
	return true

func _check_last_monster_shows_single_completion_result() -> bool:
	var main: Control = await _main_in_encounter(1)
	main._fight()
	var completion_shown: bool = main.game_result_modal.visible and main.game_result_title.text == main.tr("RESULT_COMPLETED_TITLE")
	var victory_hidden: bool = not main.fight_victory_modal.visible
	var message: String = main.game_result_message.text
	var expected_name: String = main.tr("FIGHT_VICTORY_DEFEATED") % "Rat"
	_free_main(main)
	if not completion_shown or not victory_hidden:
		return _fail("The last kill should show only the dungeon completion result, not a stacked victory result.")
	if not message.contains(expected_name) or not message.contains("reputation"):
		return _fail("The completion result should name the last monster defeated and the rewards, got: %s" % message)
	return true

func _check_low_energy_warning_waits_for_victory() -> bool:
	var main: Control = await _main_in_encounter(2)
	var attack_cost := int(CombatRules.get_player_ability("basic_attack")["energy_cost"])
	main.player_state["current_energy"] = _low_energy_threshold(main) + attack_cost  # the kill lands on the threshold
	main._fight()
	var victory_first: bool = main.fight_victory_modal.visible and not main.game_result_modal.visible
	main._hide_fight_victory()
	var warning_after: bool = main.game_result_modal.visible and main.game_result_title.text == main.tr("LOW_ENERGY_TITLE")
	_free_main(main)
	if not victory_first:
		return _fail("The victory result should show first, without the low-energy warning on top.")
	if not warning_after:
		return _fail("The low-energy warning should follow once the victory result is dismissed.")
	return true

func _check_last_energy_kill_shows_depletion_only() -> bool:
	var main: Control = await _main_in_encounter(2)
	main.player_state["current_energy"] = int(CombatRules.get_player_ability("basic_attack")["energy_cost"])
	main._fight()
	var depleting: bool = main.dungeon_exit_pending
	var victory_hidden: bool = not main.fight_victory_modal.visible
	_free_main(main)
	if not depleting or not victory_hidden:
		return _fail("A kill that spends the last energy should end the run without a victory result.")
	return true

## A warning delayed by a damage overlay that comes due while the victory result is open.
func _check_delayed_warning_waits_for_victory() -> bool:
	var main: Control = await _main_in_encounter(2)
	main._fight()
	main._show_low_energy_warning("late warning")
	var victory_kept: bool = main.fight_victory_modal.visible and not main.game_result_modal.visible
	main._hide_fight_victory()
	var warning_after: bool = main.game_result_modal.visible and main.game_result_message.text == "late warning"
	_free_main(main)
	if not victory_kept or not warning_after:
		return _fail("A delayed low-energy warning should wait for the victory result's Continue.")
	return true

func _check_spanish_strings_exist() -> bool:
	TranslationServer.set_locale("es")
	var keys := ["FIGHT_VICTORY_TITLE", "FIGHT_VICTORY_DEFEATED", "FIGHT_VICTORY_EXPERIENCE", "FIGHT_VICTORY_RUN_TOTAL"]
	for monster: Dictionary in DungeonGenerator.get_monster_templates():
		keys.append("MONSTER_NAME_" + String(monster["name"]).to_upper().replace(" ", "_"))
	var missing: Array[String] = []
	for key: String in keys:
		if TranslationServer.translate(key) == key:
			missing.append(key)
	TranslationServer.set_locale("en")
	if not missing.is_empty():
		return _fail("Missing Spanish translations: %s" % ", ".join(missing))
	return true
