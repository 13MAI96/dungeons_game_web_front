extends SceneTree
## Verifies the combat-feedback change (DNG-13): floating damage numbers show the real damage,
## every real outcome (hit, critical, dodged, blocked) has its label, the fight log keeps only
## the last FightLog.MAX_ENTRIES attacks with their numbers and resets on a new encounter, the
## texts are translated to Spanish, no "protected" jargon is left, and the log fits above the
## Fight and Flee buttons on both target phone sizes.
##
## Outcomes are forced with the injectable rolls of main.gd (next_attack_roll, next_dodge_roll,
## next_counter_roll, next_player_dodge_roll, next_flee_roll). With the stats used here:
##   player attack vs Rat (armor 4):   roll 15 + dodge 1 = hit, 20 = critical,
##                                      15 + dodge 20 = dodged, 1 = blocked (armor)
##   Rat's Bite vs player (armor 3):   the same rolls give the same outcomes.
## Run: godot --headless --path . -s res://tests/verify_combat_feedback.gd

const SaveGame := preload("res://scripts/save_game.gd")
const SettingsStore := preload("res://scripts/settings_store.gd")
const CombatRules := preload("res://scripts/combat_rules.gd")
const FightLog := preload("res://scripts/fight_log.gd")
const TEST_SAVE_PATH := "user://verify_combat_feedback.json"
const TEST_SETTINGS_PATH := "user://verify_combat_feedback.cfg"
const ENGLISH_PO := "res://localization/menu.en.po"
const SPANISH_PO := "res://localization/menu.es.po"
## Phone screens (physical pixels) the encounter must fit: 1440x3088 and 1080x2220.
const SCREEN_SIZES := [Vector2i(1440, 3088), Vector2i(1080, 2220)]

## Rolls that force each outcome, as [attack roll, defender dodge roll].
const ROLLS_HIT := [15.0, 1.0]
const ROLLS_CRITICAL := [20.0, 1.0]
const ROLLS_DODGED := [15.0, 20.0]
const ROLLS_BLOCKED := [1.0, 1.0]

func _init() -> void:
	_reset_files()
	SettingsStore.save_locale("en", TEST_SETTINGS_PATH)
	var checks: Array[Callable] = [
		_check_damage_numbers_show_real_damage,
		_check_outcome_labels,
		_check_log_keeps_last_entries_and_resets,
		_check_failed_flee_is_logged,
		_check_spanish_text,
		_check_no_jargon_keys,
		_check_layout_fits_phones,
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

func _fail(message: String) -> bool:
	push_error(message)
	TranslationServer.set_locale("en")
	_reset_files()
	quit(1)
	return false

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

## A Rat that cannot die in these tests, with a single 1-damage Bite.
func _create_rat(speed: int = 3) -> Dictionary:
	return {
		"name": "Rat", "level": 1, "image": "Rat", "experience": 1,
		"life": 999, "max_life": 999, "current_life": 999,
		"armor": 4, "current_armor": 4,
		"mana": 0, "max_mana": 0, "current_mana": 0,
		"strength": 1, "current_strength": 1,
		"speed": speed, "current_speed": speed,
		"attacks": [{"name": "Bite", "damage": 1, "critical_threshold": 20, "critical_damage_percent": 100, "mana_cost": 0, "effects": []}],
	}

## Opens a fresh encounter with `monster` (a new encounter each call) inside a small run.
func _start_encounter(main: Control, monster: Dictionary) -> void:
	main.player_state["in_dungeon"] = true
	main.dungeon = {"number_of_columns": 2, "number_of_rows": 1, "q_locations": 2, "locations": []}
	var location := {"column": 2, "row": 1, "type": "MONSTER", "visible": true, "visited": false, "content": monster}
	main.dungeon["locations"] = [{"column": 1, "row": 1, "type": "ENTRANCE", "visible": true, "visited": true, "content": {}}, location]
	main.current_location = location
	main._show_monster_encounter(location)

## One fight round with forced rolls for the player's attack and the Rat's counterattack.
## Closes the damage overlay so the next round starts from a clean screen.
func _fight_round(main: Control, player_rolls: Array, monster_rolls: Array) -> void:
	main.next_attack_roll = player_rolls[0]
	main.next_dodge_roll = player_rolls[1]
	main.next_counter_roll = monster_rolls[0]
	main.next_player_dodge_roll = monster_rolls[1]
	main._fight()
	main._hide_damage_overlay()

func _monster_life(main: Control) -> int:
	return int((main.active_monster_location["content"] as Dictionary)["current_life"])

func _player_life(main: Control) -> int:
	return int(main.player_state["current_life"])

## Outcome tag texts of the fight log rows, oldest first.
func _log_tags(main: Control) -> Array[String]:
	var tags: Array[String] = []
	for row: Node in main.fight_log.get_children():
		tags.append((row.get_node("Outcome") as Label).text)
	return tags

## Damage of the Strike the player starts with, from the ability data.
func _strike_damage(critical: bool) -> int:
	return CombatRules.get_attack_damage(CombatRules.get_player_ability("basic_attack"), critical, 3)

# --- checks -----------------------------------------------------------------------------

## The floating numbers over the monster and the player equal the life each one really lost.
func _check_damage_numbers_show_real_damage() -> bool:
	var main := _new_main()
	await process_frame
	_start_encounter(main, _create_rat())
	await process_frame

	for rolls: Array in [ROLLS_HIT, ROLLS_CRITICAL]:
		main.damage_numbers.clear()
		var monster_before := _monster_life(main)
		var player_before := _player_life(main)
		_fight_round(main, rolls, rolls)
		var monster_lost := monster_before - _monster_life(main)
		var player_lost := player_before - _player_life(main)
		var critical := rolls == ROLLS_CRITICAL
		if monster_lost != _strike_damage(critical) or player_lost <= 0:
			_free_main(main)
			return _fail("Forced rolls %s should hurt both fighters (monster lost %d, player lost %d)." % [rolls, monster_lost, player_lost])
		var prefix := "Critical! " if critical else ""
		var expected: Array[String] = ["%s-%d" % [prefix, monster_lost], "%s-%d" % [prefix, player_lost]]
		var shown: Array[String] = main.damage_numbers.get_active_texts()
		if shown != expected:
			_free_main(main)
			return _fail("Damage numbers should be %s (real life lost), got %s." % [expected, shown])

	# Numbers float over the portraits, rise and fade out within the animation time.
	var label := main.damage_numbers.get_child(0) as Label
	var portrait_rect: Rect2 = main.monster_image_asset.get_global_rect()
	if absf(label.get_global_rect().get_center().x - portrait_rect.get_center().x) > 1.0:
		_free_main(main)
		return _fail("The monster's damage number should be centred over the monster portrait.")
	var start_y := label.position.y
	await create_timer(0.3).timeout
	if not is_instance_valid(label) or label.position.y >= start_y or label.modulate.a >= 1.0:
		_free_main(main)
		return _fail("A damage number should rise and fade while it is shown.")
	await create_timer(0.7).timeout
	if not main.damage_numbers.get_active_texts().is_empty():
		_free_main(main)
		return _fail("Damage numbers should disappear after about 0.8 s.")
	_free_main(main)
	return true

## Each real outcome gets its tag in the log and its float: Hit, Critical!, Dodged, Blocked.
## An attack that does no damage floats its outcome word and leaves life unchanged.
func _check_outcome_labels() -> bool:
	var main := _new_main()
	await process_frame
	var cases := [
		{"rolls": ROLLS_HIT, "tag": "Hit", "word": ""},
		{"rolls": ROLLS_CRITICAL, "tag": "Critical!", "word": ""},
		{"rolls": ROLLS_DODGED, "tag": "Dodged", "word": "Dodged"},
		{"rolls": ROLLS_BLOCKED, "tag": "Blocked", "word": "Blocked"},
	]
	for case: Dictionary in cases:
		_start_encounter(main, _create_rat())
		var monster_before := _monster_life(main)
		var player_before := _player_life(main)
		_fight_round(main, case["rolls"], case["rolls"])
		var tags := _log_tags(main)
		if tags != [case["tag"], case["tag"]]:
			_free_main(main)
			return _fail("Rolls %s should tag both attacks %s, got %s." % [case["rolls"], case["tag"], tags])
		if String(case["word"]) != "":
			var floats: Array[String] = main.damage_numbers.get_active_texts()
			if floats != [case["word"], case["word"]]:
				_free_main(main)
				return _fail("A %s attack should float \"%s\" over the target, got %s." % [case["tag"], case["word"], floats])
			if _monster_life(main) != monster_before or _player_life(main) != player_before:
				_free_main(main)
				return _fail("A %s attack should not change life." % case["tag"])
	_start_encounter(main, _create_rat())
	_fight_round(main, ROLLS_DODGED, ROLLS_BLOCKED)
	var texts: Array[String] = main.fight_log.get_entry_texts()
	if texts != ["Rat dodged your Strike", "Your armor stopped Rat's Bite"]:
		_free_main(main)
		return _fail("Dodge and block log lines should explain what happened in plain words, got %s." % [texts])
	_free_main(main)
	return true

## The log keeps the last MAX_ENTRIES attacks (oldest first, newest last) with their numbers,
## and a new encounter starts with an empty log and no floating numbers.
func _check_log_keeps_last_entries_and_resets() -> bool:
	var main := _new_main()
	await process_frame
	_start_encounter(main, _create_rat())
	var expected: Array[String] = []
	# Three rounds: hit/hit, critical/critical, hit/blocked -> 6 entries, the first 2 dropped.
	for round: Array in [[ROLLS_HIT, ROLLS_HIT], [ROLLS_CRITICAL, ROLLS_CRITICAL], [ROLLS_HIT, ROLLS_BLOCKED]]:
		var monster_before := _monster_life(main)
		var player_before := _player_life(main)
		_fight_round(main, round[0], round[1])
		var dealt := monster_before - _monster_life(main)
		var taken := player_before - _player_life(main)
		if round[0] == ROLLS_CRITICAL:
			expected.append("Critical hit on Rat for %d" % dealt)
			expected.append("Rat landed a critical Bite for %d" % taken)
		else:
			expected.append("You hit Rat for %d" % dealt)
			expected.append("Rat hit you with Bite for %d" % taken if round[1] == ROLLS_HIT else "Your armor stopped Rat's Bite")
	expected = expected.slice(expected.size() - FightLog.MAX_ENTRIES)
	var texts: Array[String] = main.fight_log.get_entry_texts()
	if texts != expected:
		_free_main(main)
		return _fail("The fight log should keep the last %d entries %s, got %s." % [FightLog.MAX_ENTRIES, expected, texts])
	if main.fight_log.get_child_count() != FightLog.MAX_ENTRIES:
		_free_main(main)
		return _fail("The fight log should show %d rows." % FightLog.MAX_ENTRIES)
	var newest := main.fight_log.get_child(FightLog.MAX_ENTRIES - 1) as Control
	var oldest := main.fight_log.get_child(0) as Control
	if newest.modulate.a <= oldest.modulate.a:
		_free_main(main)
		return _fail("The newest log entry (last row) should stand out over older ones.")

	_start_encounter(main, _create_rat())
	if not main.fight_log.get_entry_texts().is_empty() or main.fight_log.get_child_count() != 0:
		_free_main(main)
		return _fail("A new encounter should start with an empty fight log.")
	if not main.damage_numbers.get_active_texts().is_empty():
		_free_main(main)
		return _fail("A new encounter should not show numbers from the previous one.")
	_free_main(main)
	return true

## A failed flee is logged with the monster's attack; a successful one closes the encounter
## and clears the floating numbers.
func _check_failed_flee_is_logged() -> bool:
	var main := _new_main()
	await process_frame
	_start_encounter(main, _create_rat(10))  # Speed 10: a flee roll of 1 always fails.
	var player_before := _player_life(main)
	main.next_flee_roll = 1.0
	main.next_counter_roll = ROLLS_HIT[0]
	main.next_player_dodge_roll = ROLLS_HIT[1]
	main._flee_encounter()
	main._hide_damage_overlay()
	var taken := player_before - _player_life(main)
	var expected: Array[String] = ["You tried to flee, but Rat blocked your way", "Rat hit you with Bite for %d" % taken]
	if main.fight_log.get_entry_texts() != expected or _log_tags(main) != ["No escape", "Hit"]:
		_free_main(main)
		return _fail("A failed flee should log %s, got %s." % [expected, main.fight_log.get_entry_texts()])
	if main.damage_numbers.get_active_texts() != ["-%d" % taken]:
		_free_main(main)
		return _fail("A failed flee should float the counterattack damage over the player.")
	if main.damage_overlay_text.text != expected[1]:
		_free_main(main)
		return _fail("The damage overlay should say who hurt the player and how much: %s" % main.damage_overlay_text.text)
	main.next_flee_roll = 20.0
	main._flee_encounter()
	if main.monster_encounter_view.visible or not main.damage_numbers.get_active_texts().is_empty():
		_free_main(main)
		return _fail("Escaping should close the encounter and clear its floating numbers.")
	_free_main(main)
	return true

## The log tags, sentences and floating words are Spanish when Spanish is selected.
func _check_spanish_text() -> bool:
	SettingsStore.save_locale("es", TEST_SETTINGS_PATH)
	var main := _new_main()
	await process_frame
	_start_encounter(main, _create_rat())
	var monster_before := _monster_life(main)
	var player_before := _player_life(main)
	_fight_round(main, ROLLS_HIT, ROLLS_HIT)
	var dealt := monster_before - _monster_life(main)
	var taken := player_before - _player_life(main)
	var texts: Array[String] = main.fight_log.get_entry_texts()
	var tags := _log_tags(main)
	var expected: Array[String] = ["Golpeaste a Rata: %d de daño" % dealt, "Rata te golpeó con Mordida: %d de daño" % taken]
	_fight_round(main, ROLLS_DODGED, ROLLS_BLOCKED)
	var floats: Array[String] = main.damage_numbers.get_active_texts()
	var no_damage_texts: Array[String] = main.fight_log.get_entry_texts().slice(2)
	_fight_round(main, ROLLS_CRITICAL, ROLLS_CRITICAL)
	var critical_float: String = main.damage_numbers.get_active_texts()[-1]
	_free_main(main)
	SettingsStore.save_locale("en", TEST_SETTINGS_PATH)
	TranslationServer.set_locale("en")
	if texts != expected or tags != ["Golpe", "Golpe"]:
		return _fail("Spanish fight log should be %s tagged Golpe, got %s %s." % [expected, texts, tags])
	if no_damage_texts != ["Rata esquivó tu Golpe", "Tu armadura frenó el ataque de Rata (Mordida)"]:
		return _fail("Spanish dodge/block lines are wrong: %s" % [no_damage_texts])
	if not floats.has("Esquivado") or not floats.has("Bloqueado"):
		return _fail("Spanish floating words should be Esquivado and Bloqueado, got %s." % [floats])
	if not critical_float.begins_with("¡Crítico! -"):
		return _fail("Spanish critical float should start with ¡Crítico!, got %s." % critical_float)
	return true

## The old "... was protected" keys are gone and no combat text uses that jargon any more.
func _check_no_jargon_keys() -> bool:
	for path: String in [ENGLISH_PO, SPANISH_PO]:
		var content := FileAccess.get_file_as_string(path)
		for pattern: String in ["COMBAT_FEEDBACK_", "_PROTECTED\""]:
			if content.contains(pattern):
				return _fail("%s should no longer define %s keys." % [path, pattern])
		for line: String in content.split("\n"):
			var lower := line.to_lower()
			if line.begins_with("msgstr") and (lower.contains("protected") or lower.contains("protegid")):
				return _fail("%s still uses the protected jargon: %s" % [path, line])
	for script_path: String in ["res://scripts/main.gd", "res://scripts/combat_feedback.gd"]:
		if FileAccess.get_file_as_string(script_path).contains("PROTECTED"):
			return _fail("%s should not reference *_PROTECTED keys." % script_path)
	return true

## With a full log of the longest (Spanish) lines, on both target phones the log sits between
## the fighters and the buttons without overlapping either, and the buttons stay on screen.
func _check_layout_fits_phones() -> bool:
	SettingsStore.save_locale("es", TEST_SETTINGS_PATH)
	var main := _new_main()
	await process_frame
	_start_encounter(main, _create_rat())
	for i in 2:
		_fight_round(main, ROLLS_CRITICAL, ROLLS_CRITICAL)  # The longest Spanish lines.
	var original_size := get_root().size
	var failure := ""
	for screen_size: Vector2i in SCREEN_SIZES:
		get_root().size = screen_size
		await process_frame
		await process_frame
		var viewport_height: float = main.get_viewport_rect().size.y
		var log_rect: Rect2 = main.fight_log.get_global_rect()
		var fight_rect: Rect2 = main.fight_button.get_global_rect()
		var flee_rect: Rect2 = main.flee_button.get_global_rect()
		var player_stats_rect: Rect2 = main.encounter_player_stat_bars.get_global_rect()
		var player_portrait_rect: Rect2 = main.encounter_player_asset.get_global_rect()
		if log_rect.end.y > fight_rect.position.y:
			failure = "On %s the fight log should end above the Fight button." % screen_size
		elif flee_rect.end.y > viewport_height:
			failure = "On %s the Flee button should stay on screen." % screen_size
		elif player_stats_rect.end.y > log_rect.position.y or player_portrait_rect.end.y > log_rect.position.y:
			failure = "On %s the fight log should not overlap the player panel." % screen_size
		elif main.fight_log.get_child_count() != FightLog.MAX_ENTRIES:
			failure = "On %s the full log should be shown." % screen_size
		if failure != "":
			break
	get_root().size = original_size
	_free_main(main)
	SettingsStore.save_locale("en", TEST_SETTINGS_PATH)
	TranslationServer.set_locale("en")
	if failure != "":
		return _fail(failure)
	return true
