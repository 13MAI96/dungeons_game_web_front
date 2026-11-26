extends SceneTree
## Verifies the rest-rework change (DNG-16): Rest restores fixed, predictable amounts, its
## button shows the mana cost, the result line shows the real numbers and clears on the next
## move, and the button is disabled with a visible reason when Rest cannot be used
## (not enough mana, life and energy already full, or during a monster encounter).
## Run: godot --headless --path . -s res://tests/verify_rest.gd

const SaveGame := preload("res://scripts/save_game.gd")
const SettingsStore := preload("res://scripts/settings_store.gd")
const CombatRules := preload("res://scripts/combat_rules.gd")
const DungeonGenerator := preload("res://scripts/dungeon_generator.gd")
const TEST_SAVE_PATH := "user://verify_rest.json"
const TEST_SETTINGS_PATH := "user://verify_rest.cfg"
## U+2212 MINUS SIGN and U+00B7 MIDDLE DOT, used by the result line and the button label.
const MINUS_SIGN := "−"
const MIDDLE_DOT := "·"

func _init() -> void:
	_reset_files()
	SettingsStore.save_locale("en", TEST_SETTINGS_PATH)
	var checks: Array[Callable] = [
		_check_rules_restore_fixed_amounts,
		_check_rules_cap_at_maximum,
		_check_rules_block_reasons,
		_check_button_shows_cost,
		_check_result_message_numbers,
		_check_message_clears_on_next_move,
		_check_disabled_without_mana,
		_check_disabled_when_full,
		_check_blocked_during_encounter,
		_check_spanish_text,
		_check_font_has_symbols,
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

## Starts a new level-1 game (10 life, 25 energy, 12 mana) inside a 3x1 corridor of empty
## cells with the player on the entrance, hurt to 5 life and 10 energy so Rest is usable.
func _main_in_corridor() -> Control:
	var main := _new_main()
	await process_frame  # let the scene build its UI before using it
	main._start_new_game()
	CombatRules.begin_dungeon_experience(main.player_state)
	var locations: Array = [{"column": 1, "row": 1, "type": DungeonGenerator.LOCATION_ENTRANCE, "visible": true, "visited": true, "content": {}}]
	for column in range(2, 4):
		locations.append({"column": column, "row": 1, "type": DungeonGenerator.LOCATION_EMPTY, "visible": true, "visited": false, "content": {}})
	main.dungeon = {"number_of_columns": 3, "number_of_rows": 1, "locations": locations}
	main.current_location = main.dungeon["locations"][0]
	main.previous_location = {}
	main.active_monster_location = {}
	main.player_state["current_life"] = 5
	main.player_state["current_energy"] = 10
	main._mark_visible_locations()
	main._render_map()
	main._update_direction_buttons()
	main._update_exploration_actions()
	main._show_dungeon_explore_view()
	return main

## Life a level-1 player (10 maximum life) gains from one rest.
func _level_one_life_gain() -> int:
	return roundi(10.0 * CombatRules.REST_LIFE_PERCENT / 100.0)

## Energy a level-1 player (25 maximum energy) gains from one rest.
func _level_one_energy_gain() -> int:
	return roundi(25.0 * CombatRules.REST_ENERGY_PERCENT / 100.0)

# --- rules ------------------------------------------------------------------------------

## Every rest gives exactly the same amounts: no random roll.
func _check_rules_restore_fixed_amounts() -> bool:
	for attempt in 20:
		var player := CombatRules.create_default_player()
		player["current_life"] = 2
		player["current_energy"] = 3
		var result := CombatRules.rest(player)
		if not bool(result["rested"]):
			return _fail("A hurt player with 12 mana should be able to rest.")
		if int(player["current_life"]) != 2 + _level_one_life_gain() or int(player["current_energy"]) != 3 + _level_one_energy_gain():
			return _fail("Rest should always restore %d%% life and %d%% energy (attempt %d)." % [CombatRules.REST_LIFE_PERCENT, CombatRules.REST_ENERGY_PERCENT, attempt])
		if int(player["current_mana"]) != 12 - CombatRules.REST_MANA_COST:
			return _fail("Rest should spend exactly %d mana." % CombatRules.REST_MANA_COST)
	# Larger heroes gain proportionally more: 30 life and 40 energy.
	var veteran := CombatRules.create_default_player()
	veteran["life"] = 30
	veteran["energy"] = 40
	veteran["current_life"] = 1
	veteran["current_energy"] = 1
	var veteran_result := CombatRules.rest(veteran)
	if int(veteran_result["life_restored"]) != roundi(30.0 * CombatRules.REST_LIFE_PERCENT / 100.0) \
		or int(veteran_result["energy_restored"]) != roundi(40.0 * CombatRules.REST_ENERGY_PERCENT / 100.0):
		return _fail("Rest should restore its percentages of the hero's own maximums: %s" % veteran_result)
	return true

## Near the maximum, Rest only reports the points really gained.
func _check_rules_cap_at_maximum() -> bool:
	var player := CombatRules.create_default_player()
	player["current_life"] = 9
	player["current_energy"] = 24
	var result := CombatRules.rest(player)
	if int(player["current_life"]) != 10 or int(player["current_energy"]) != 25:
		return _fail("Rest should not go above maximum life or energy.")
	if int(result["life_restored"]) != 1 or int(result["energy_restored"]) != 1 or int(result["mana_spent"]) != CombatRules.REST_MANA_COST:
		return _fail("Rest should report the capped gains (+1 life, +1 energy): %s" % result)
	return true

## Rest is refused (nothing changes) without mana or with life and energy full.
func _check_rules_block_reasons() -> bool:
	var short := CombatRules.create_default_player()
	short["current_life"] = 3
	short["current_mana"] = CombatRules.REST_MANA_COST - 1
	var short_result := CombatRules.rest(short)
	if bool(short_result["rested"]) or String(short_result["reason"]) != CombatRules.REST_BLOCKED_NO_MANA \
		or int(short["current_life"]) != 3 or int(short["current_mana"]) != CombatRules.REST_MANA_COST - 1:
		return _fail("Rest without enough mana should change nothing and say why: %s" % short_result)
	var rested := CombatRules.create_default_player()
	var full_result := CombatRules.rest(rested)
	if bool(full_result["rested"]) or String(full_result["reason"]) != CombatRules.REST_BLOCKED_FULL or int(rested["current_mana"]) != 12:
		return _fail("Rest at full life and energy should not spend mana: %s" % full_result)
	rested["current_energy"] = 24  # only energy missing: Rest is useful again
	if CombatRules.get_rest_block_reason(rested) != "":
		return _fail("Rest should be allowed when only energy is below maximum.")
	short["current_life"] = 10
	short["current_energy"] = 25
	if CombatRules.get_rest_block_reason(short) != CombatRules.REST_BLOCKED_NO_MANA:
		return _fail("The missing-mana reason should win when life and energy are also full.")
	return true

# --- exploration view -------------------------------------------------------------------

func _check_button_shows_cost() -> bool:
	var main: Control = await _main_in_corridor()
	var label := String(main.rest_button.text)
	_free_main(main)
	if label != "Rest %s %d mana" % [MIDDLE_DOT, CombatRules.REST_MANA_COST]:
		return _fail("The Rest button should show its cost (\"Rest · 5 mana\"), got \"%s\"." % label)
	return true

## The result line shows the points gained and the mana spent, and they match the stats.
func _check_result_message_numbers() -> bool:
	var main: Control = await _main_in_corridor()
	main._rest()
	var feedback := String(main.explore_feedback.text)
	var life := int(main.player_state["current_life"])
	var energy := int(main.player_state["current_energy"])
	var mana := int(main.player_state["current_mana"])
	_free_main(main)
	var expected := "+%d life, +%d energy, %s%d mana" % [_level_one_life_gain(), _level_one_energy_gain(), MINUS_SIGN, CombatRules.REST_MANA_COST]
	if feedback != expected:
		return _fail("After resting the feedback should be \"%s\", got \"%s\"." % [expected, feedback])
	if life != 5 + _level_one_life_gain() or energy != 10 + _level_one_energy_gain() or mana != 12 - CombatRules.REST_MANA_COST:
		return _fail("The rest result should match the stats (life %d, energy %d, mana %d)." % [life, energy, mana])
	return true

## The user test found rest messages lingering after moving: the next move clears them.
func _check_message_clears_on_next_move() -> bool:
	var main: Control = await _main_in_corridor()
	main._rest()
	if String(main.explore_feedback.text) == "":
		_free_main(main)
		return _fail("Resting should show a result message.")
	main.move_player("right")
	var after_move := String(main.explore_feedback.text)
	_free_main(main)
	if after_move != "":
		return _fail("The rest message should disappear on the next move, got \"%s\"." % after_move)
	return true

## Two rests spend 10 of the 12 starting mana: the button is then disabled and says why.
func _check_disabled_without_mana() -> bool:
	var main: Control = await _main_in_corridor()
	main.player_state["current_life"] = 1
	main._rest()
	main._rest()
	var disabled := bool(main.rest_button.disabled)
	var feedback := String(main.explore_feedback.text)
	var mana_before := int(main.player_state["current_mana"])
	var life_before := int(main.player_state["current_life"])
	main._rest()  # a call that bypasses the disabled button still changes nothing
	var unchanged := int(main.player_state["current_mana"]) == mana_before and int(main.player_state["current_life"]) == life_before
	main.move_player("right")
	var feedback_after_move := String(main.explore_feedback.text)
	var disabled_after_move := bool(main.rest_button.disabled)
	_free_main(main)
	var reason := "Rest needs %d mana." % CombatRules.REST_MANA_COST
	if mana_before != 12 - 2 * CombatRules.REST_MANA_COST:
		return _fail("Two rests should spend %d mana." % (2 * CombatRules.REST_MANA_COST))
	if not disabled:
		return _fail("Rest should be disabled when current mana is below its cost.")
	if not feedback.ends_with(reason):
		return _fail("The feedback should say why Rest is disabled (\"%s\"), got \"%s\"." % [reason, feedback])
	if not unchanged:
		return _fail("Rest without enough mana should change nothing.")
	if not disabled_after_move or feedback_after_move != reason:
		return _fail("After moving, only the Rest reason should remain, got \"%s\"." % feedback_after_move)
	return true

## Resting at full life and energy would only waste mana: disabled with a reason.
func _check_disabled_when_full() -> bool:
	var main: Control = await _main_in_corridor()
	main.player_state["current_life"] = int(main.player_state["life"])
	main.player_state["current_energy"] = int(main.player_state["energy"])
	main._update_exploration_actions()
	var disabled := bool(main.rest_button.disabled)
	var feedback := String(main.explore_feedback.text)
	main._rest()
	var mana := int(main.player_state["current_mana"])
	_free_main(main)
	if not disabled or feedback != "Life and energy are full.":
		return _fail("At full life and energy Rest should be disabled with a reason, got \"%s\"." % feedback)
	if mana != 12:
		return _fail("Rest at full life and energy should not spend mana.")
	return true

## Rest lives on the exploration screen: during a fight it is out of reach and does nothing.
func _check_blocked_during_encounter() -> bool:
	var main: Control = await _main_in_corridor()
	var monster := {"name": "Rat", "level": 1, "life": 99, "max_life": 99, "current_life": 99, "armor": 1, "speed": 1, "strength": 1, "experience": 1, "attacks": []}
	var location := {"column": 2, "row": 1, "type": DungeonGenerator.LOCATION_MONSTER, "visible": true, "visited": false, "content": monster}
	main._show_monster_encounter(location)
	var rest_visible := bool(main.rest_button.is_visible_in_tree())
	main._rest()
	var mana := int(main.player_state["current_mana"])
	var life := int(main.player_state["current_life"])
	_free_main(main)
	if rest_visible:
		return _fail("The Rest button should not be reachable during a monster encounter.")
	if mana != 12 or life != 5:
		return _fail("Rest should do nothing during a monster encounter.")
	return true

func _check_spanish_text() -> bool:
	var main: Control = await _main_in_corridor()
	main._select_locale("es")
	main._show_dungeon_explore_view()
	var label := String(main.rest_button.text)
	main._rest()
	var feedback := String(main.explore_feedback.text)
	main.player_state["current_mana"] = 0
	main._update_exploration_actions()
	var reason := String(main.explore_feedback.text)
	main.player_state["current_mana"] = 12
	main.player_state["current_life"] = int(main.player_state["life"])
	main.player_state["current_energy"] = int(main.player_state["energy"])
	main._show_explore_message("")
	main._update_exploration_actions()
	var full_reason := String(main.explore_feedback.text)
	var tutorial_body := TranslationServer.translate("TUTORIAL_REST_BODY")
	main._select_locale("en")
	_free_main(main)
	if label != "Descansar %s %d maná" % [MIDDLE_DOT, CombatRules.REST_MANA_COST]:
		return _fail("The Spanish Rest button should show its cost, got \"%s\"." % label)
	var expected := "+%d de vida, +%d de energía, %s%d de maná" % [_level_one_life_gain(), _level_one_energy_gain(), MINUS_SIGN, CombatRules.REST_MANA_COST]
	if feedback != expected:
		return _fail("The Spanish rest result should be \"%s\", got \"%s\"." % [expected, feedback])
	if not reason.ends_with("Para descansar necesitás %d de maná." % CombatRules.REST_MANA_COST):
		return _fail("The Spanish missing-mana reason (voseo) is wrong: \"%s\"." % reason)
	if full_reason != "Tenés la vida y la energía al máximo.":
		return _fail("The Spanish full-status reason is wrong: \"%s\"." % full_reason)
	if not tutorial_body.contains("vida máxima") or not tutorial_body.contains("energía máxima"):
		return _fail("The Spanish tutorial Rest page should describe the fixed percentages: \"%s\"." % tutorial_body)
	return true

## The theme font must draw the middle dot and the minus sign used by the new texts.
func _check_font_has_symbols() -> bool:
	var main: Control = await _main_in_corridor()
	var font: Font = main.rest_button.get_theme_font("font")
	var feedback_font: Font = main.explore_feedback.get_theme_font("font")
	_free_main(main)
	for symbol: String in [MIDDLE_DOT, MINUS_SIGN]:
		if not font.has_char(symbol.unicode_at(0)) or not feedback_font.has_char(symbol.unicode_at(0)):
			return _fail("The UI font cannot draw \"%s\"." % symbol)
	return true
