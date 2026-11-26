extends SceneTree
## Verifies the complete-spanish-localization change (DNG-8): no visible UI text bypasses the
## translation files.
##
## 1. Both .po files define the same keys, with no empty translation.
## 2. Every data-driven name (monsters, attacks, abilities, classes, effects in data/*.json, plus
##    the fallback names defined in code) has an English and a Spanish translation.
## 3. The real main scene is driven through every view and modal in English, in Spanish, and
##    in English switched to Spanish from Settings, collecting the text of every visible Label
##    and Button (and tooltips).
##    A word that appears in the same node in both languages and is not part of the Spanish
##    translations is English text that skipped tr(): the test fails and lists it. Raw
##    translation keys (e.g. "MENU_START_GAME") on screen also fail.
## Run: godot --headless --path . -s res://tests/verify_localization.gd

const SaveGame := preload("res://scripts/save_game.gd")
const SettingsStore := preload("res://scripts/settings_store.gd")
const CombatRules := preload("res://scripts/combat_rules.gd")
const DungeonGenerator := preload("res://scripts/dungeon_generator.gd")
const LocalizedNames := preload("res://scripts/localized_names.gd")
const CombatFeedback := preload("res://scripts/combat_feedback.gd")
const TEST_SAVE_PATH := "user://verify_localization.json"
const TEST_SETTINGS_PATH := "user://verify_localization.cfg"
const ENGLISH_PO := "res://localization/menu.en.po"
const SPANISH_PO := "res://localization/menu.es.po"
const MONSTERS_JSON := "res://data/monsters.json"
const ABILITIES_JSON := "res://data/player_abilities.json"
const CLASSES_JSON := "res://data/player_classes.json"
const EFFECTS_JSON := "res://data/effects.json"
## Attack names that only exist in code, as fallbacks (combat_rules.gd, dungeon_generator.gd).
const CODE_ABILITY_NAMES := ["Attack", "Claw"]
## Sanity floor: the walk must really reach the views (it collects ~1300 texts today).
const MIN_CAPTURED_TEXTS := 1000

var english_po: Dictionary = {}
var spanish_po: Dictionary = {}

func _init() -> void:
	english_po = _read_po(ENGLISH_PO)
	spanish_po = _read_po(SPANISH_PO)
	var checks: Array[Callable] = [
		_check_po_files_match,
		_check_data_names_translated,
		_check_ui_text_is_translated,
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
	_reset_files()
	TranslationServer.set_locale("en")
	quit(1)
	return false

## Minimal gettext reader for this project's files: one-line `msgid` / `msgstr` pairs.
## Returns {msgid: msgstr}, without the empty header entry.
func _read_po(path: String) -> Dictionary:
	var entries := {}
	var current_id := ""
	for raw_line: String in FileAccess.get_file_as_string(path).split("\n"):
		var line := raw_line.strip_edges()
		if line.begins_with("msgid "):
			current_id = _po_string(line.trim_prefix("msgid "))
		elif line.begins_with("msgstr ") and current_id != "":
			entries[current_id] = _po_string(line.trim_prefix("msgstr "))
			current_id = ""
	return entries

## Unquotes a .po string literal ("..." with \" and \n escapes).
func _po_string(literal: String) -> String:
	return literal.strip_edges().trim_prefix("\"").trim_suffix("\"").c_unescape()

func _read_json_array(path: String) -> Array:
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(path))
	return parsed if parsed is Array else []

## Lower-case words (runs of letters, accents included) of a text; numbers and symbols are ignored.
func _words(text: String) -> PackedStringArray:
	var words := PackedStringArray()
	for found: RegExMatch in RegEx.create_from_string("\\p{L}+").search_all(text):
		words.append(found.get_string().to_lower())
	return words

# --- checks -----------------------------------------------------------------------------

func _check_po_files_match() -> bool:
	for key: String in english_po:
		if not spanish_po.has(key):
			return _fail("Key %s is in menu.en.po but missing from menu.es.po." % key)
	for key: String in spanish_po:
		if not english_po.has(key):
			return _fail("Key %s is in menu.es.po but missing from menu.en.po." % key)
		if String(spanish_po[key]).strip_edges() == "" or String(english_po[key]).strip_edges() == "":
			return _fail("Key %s has an empty translation." % key)
	return true

## Every name shown from data/*.json resolves to a Spanish translation through LocalizedNames.
func _check_data_names_translated() -> bool:
	# [prefix, data name or id] pairs, gathered from the data files themselves.
	var names: Array = []
	for monster: Dictionary in _read_json_array(MONSTERS_JSON):
		names.append([LocalizedNames.MONSTER_PREFIX, String(monster.get("name", ""))])
		for attack: Dictionary in monster.get("attacks", []):
			names.append([LocalizedNames.ABILITY_PREFIX, String(attack.get("name", ""))])
			for effect_id: Variant in attack.get("effects", []):
				names.append([LocalizedNames.EFFECT_PREFIX, String(effect_id)])
	for ability: Dictionary in _read_json_array(ABILITIES_JSON):
		names.append([LocalizedNames.ABILITY_PREFIX, String(ability.get("name", ""))])
	for player_class: Dictionary in _read_json_array(CLASSES_JSON):
		names.append([LocalizedNames.CLASS_PREFIX, String(player_class.get("id", ""))])
	for effect: Dictionary in _read_json_array(EFFECTS_JSON):
		names.append([LocalizedNames.EFFECT_PREFIX, String(effect.get("id", ""))])
	for ability_name: String in CODE_ABILITY_NAMES:
		names.append([LocalizedNames.ABILITY_PREFIX, ability_name])
	if names.size() < 30:
		return _fail("Only %d data names were found; the data files were not read." % names.size())

	TranslationServer.set_locale("es")
	for entry: Array in names:
		var key := LocalizedNames.key_for(String(entry[0]), String(entry[1]))
		if not english_po.has(key) or not spanish_po.has(key):
			return _fail("Data name \"%s\" has no translation key %s in both .po files." % [entry[1], key])
		var shown := LocalizedNames.translate(String(entry[0]), String(entry[1]))
		if shown != String(spanish_po[key]):
			return _fail("Data name \"%s\" should display as \"%s\" in Spanish, got \"%s\"." % [entry[1], spanish_po[key], shown])
	TranslationServer.set_locale("en")
	return true

## Compares the English walk with two Spanish walks: launched in Spanish, and launched in
## English then switched to Spanish in Settings (texts set once at start-up must follow).
func _check_ui_text_is_translated() -> bool:
	var english: Dictionary = await _capture_ui_texts("en")
	var launched_spanish: Dictionary = await _capture_ui_texts("es")
	var switched_spanish: Dictionary = await _capture_ui_texts("en", "es")
	for spanish: Dictionary in [launched_spanish, switched_spanish]:
		if not _spanish_walk_is_translated(english, spanish):
			return false
	return true

## Fails (and returns false) when a text of the Spanish walk is English or a raw key.
func _spanish_walk_is_translated(english: Dictionary, spanish: Dictionary) -> bool:
	if spanish.size() < MIN_CAPTURED_TEXTS:
		return _fail("The UI walk captured only %d texts; it no longer reaches every view." % spanish.size())
	for required: String in ["level_up|LevelAllocationView/Margin/Layout/Title", "encounter_Rat_info|MonsterInfoModal/Margin/Card/Panel/CloseButton", "menu|MainMenuView/Branding/BrandingStack/GameTitle"]:
		if not spanish.has(required):
			return _fail("The UI walk should capture %s." % required)

	# Words a Spanish text may legitimately share with English ("XP", "i"): those in menu.es.po.
	var spanish_vocabulary := {}
	for translation: String in spanish_po.values():
		for word: String in _words(translation):
			spanish_vocabulary[word] = true
	var raw_key := RegEx.create_from_string("\\b[A-Z][A-Z0-9]*(_[A-Z0-9]+)+\\b")
	var problems: Array[String] = []
	for text_id: String in spanish:
		var spanish_text := String(spanish[text_id])
		if raw_key.search(spanish_text) != null:
			problems.append("%s shows a raw translation key: \"%s\"" % [text_id, spanish_text])
			continue
		if not english.has(text_id):
			continue
		var english_words := _words(String(english[text_id]))
		for word: String in _words(spanish_text):
			if english_words.has(word) and not spanish_vocabulary.has(word):
				problems.append("%s is not translated: \"%s\" (English: \"%s\")" % [text_id, spanish_text, english[text_id]])
				break
	if not problems.is_empty():
		return _fail("Untranslated UI text in Spanish:\n  " + "\n  ".join(problems))
	return true

# --- UI walk ----------------------------------------------------------------------------

## Instantiates the real main scene in `locale` and walks it through every view and modal,
## always with the same data and rolls, so both languages produce the same set of nodes.
## With `switch_to`, the language is changed through Settings right after start-up.
## Returns {"<step>|<node path>": displayed text}.
func _capture_ui_texts(locale: String, switch_to: String = "") -> Dictionary:
	_reset_files()
	SettingsStore.save_locale(locale, TEST_SETTINGS_PATH)
	var main := (load("res://scenes/main.tscn") as PackedScene).instantiate() as Control
	main.save_path = TEST_SAVE_PATH
	main.settings_path = TEST_SETTINGS_PATH
	get_root().add_child(main)
	await process_frame  # let the scene build its UI before using it
	if switch_to != "":
		main._show_settings_view()
		main._select_locale(switch_to)
		main._show_main_menu_view()
	var texts := {}

	_collect(main, main, "menu", texts)
	main._show_settings_view()
	_collect(main, main, "settings", texts)

	main._start_new_game()
	_collect(main, main, "hub", texts)
	main._request_exit_to_menu()
	_collect(main, main, "confirm_exit", texts)
	main._cancel_pending_action()

	# Level 10 without a class: the level-up screen also lists the class choices.
	main.player_state["level"] = 10
	main.player_state["selected_class"] = ""
	main.player_state["reserved_progression_points"] = 3
	main._show_level_allocation_view()
	main._stage_level_point("life")
	_collect(main, main, "level_up", texts)
	main._request_leave_level_allocation()  # staged point: the discard confirmation opens
	_collect(main, main, "confirm_discard", texts)
	main._cancel_pending_action()
	main._show_new_game_view()

	_enter_test_dungeon(main)
	_collect(main, main, "explore", texts)
	main.next_quest_roll = 1.0  # trap: shows the feedback text and the damage overlay
	main.move_player("right")
	_collect(main, main, "quest_cell", texts)
	main._collect_treasure()
	_collect(main, main, "quest_trap", texts)
	main._hide_damage_overlay()

	_capture_encounters(main, texts)

	main._show_dungeon_explore_view()
	main._request_abandon_expedition()
	_collect(main, main, "confirm_abandon", texts)
	main._cancel_pending_action()
	main.move_player("left")
	main._retreat()
	_collect(main, main, "retreat_result", texts)

	get_root().remove_child(main)
	main.free()
	return texts

## Puts the player at the entrance of a 3x1 corridor: entrance, treasure (quest), floor.
func _enter_test_dungeon(main: Control) -> void:
	CombatRules.begin_dungeon_experience(main.player_state)
	main.player_state["life"] = 999
	main.player_state["current_life"] = 999
	main.dungeon = {"number_of_columns": 3, "number_of_rows": 1, "locations": [
		{"column": 1, "row": 1, "type": DungeonGenerator.LOCATION_ENTRANCE, "visible": true, "visited": true, "content": {}},
		{"column": 2, "row": 1, "type": DungeonGenerator.LOCATION_QUEST, "visible": true, "visited": false, "content": {}},
		{"column": 3, "row": 1, "type": DungeonGenerator.LOCATION_EMPTY, "visible": true, "visited": false, "content": {}},
	]}
	main.current_location = main.dungeon["locations"][0]
	main.previous_location = {}
	main.active_monster_location = {}
	main._mark_visible_locations()
	main._render_map()
	main._update_direction_buttons()
	main._update_exploration_actions()
	main._show_dungeon_explore_view()

## Shows an encounter with every monster in data/monsters.json (all attacks unlocked), writes
## a fight-log line for each of its attacks, fights one real round and opens the attack list.
func _capture_encounters(main: Control, texts: Dictionary) -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 1
	for template: Dictionary in _read_json_array(MONSTERS_JSON):
		var monster: Dictionary = DungeonGenerator.create_monster_from_template_for_level(template, rng, 20)
		# Unkillable monster, so a fight round never ends the encounter.
		monster["life"] = 999
		monster["max_life"] = 999
		monster["current_life"] = 999
		var location := {"column": 3, "row": 1, "type": DungeonGenerator.LOCATION_MONSTER, "visible": true, "visited": false, "content": monster}
		main._show_monster_encounter(location)
		var step := "encounter_%s" % String(template.get("name", ""))
		_collect(main, main, step, texts)
		# Fight log lines and floating numbers for every attack, through the same path _fight()
		# uses (DNG-13). Each attack is shown with every outcome: hit, critical, dodged, blocked.
		for attack: Dictionary in monster.get("attacks", []):
			for flags: Dictionary in [
				{"hit": true, "counterattack_hit": true},
				{"critical": true, "hit": true, "counterattack_critical": true, "counterattack_hit": true},
				{"dodged": true, "counterattack_dodged": true},
				{"miss": true, "counterattack_miss": true},
			]:
				var result := flags.duplicate()
				result["monster_attack_name"] = attack["name"]
				main._show_combat_entries(CombatFeedback.entries_for_attack(result, String(monster.get("name", "")), "Strike"))
				_collect(main, main, "%s_%s_%s" % [step, String(attack["name"]), str(flags.keys())], texts)
		seed(7)  # same random attack choice in both languages
		main._fight()
		_collect(main, main, "%s_fight" % step, texts)
		main._hide_damage_overlay()
		main._show_monster_info()
		_collect(main, main, "%s_info" % step, texts)
		main._hide_monster_info()
	main.active_monster_location = {}

## Records the displayed text of every visible Label and Button under `node`, and the tooltip
## of every visible Control. atr() gives the text as drawn (auto-translation applied).
func _collect(main: Control, node: Node, step: String, texts: Dictionary) -> void:
	if node is CanvasItem and not (node as CanvasItem).is_visible_in_tree():
		return
	var path := String(main.get_path_to(node))
	if node is Label or node is Button:
		var control := node as Control
		var shown := control.atr(String(control.get("text")))
		if shown.strip_edges() != "":
			texts["%s|%s" % [step, path]] = shown
	if node is Control and (node as Control).tooltip_text != "":
		var control := node as Control
		texts["%s|%s#tooltip" % [step, path]] = control.atr(control.tooltip_text)
	for child: Node in node.get_children():
		_collect(main, child, step, texts)
