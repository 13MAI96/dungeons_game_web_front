extends SceneTree
## Verifies the first-run-tutorial change (DNG-6): the "how to play" tutorial opens on the first
## dungeon entry only, Skip and Done close it and mark it seen in the settings file, it reopens
## from Settings, it fits the 1440x3088 and 1080x2220 portrait screens, the rule numbers come
## from CombatRules, and every tutorial key has an English and a Spanish translation.
## Run: godot --headless --path . -s res://tests/verify_first_run_tutorial.gd

const SaveGame := preload("res://scripts/save_game.gd")
const SettingsStore := preload("res://scripts/settings_store.gd")
const CombatRules := preload("res://scripts/combat_rules.gd")
const Tutorial := preload("res://scripts/tutorial.gd")
const TEST_SAVE_PATH := "user://verify_first_run_tutorial.json"
const TEST_SETTINGS_PATH := "user://verify_first_run_tutorial.cfg"
## Physical portrait resolutions the tutorial card must fit (the window is resized to each).
const SCREEN_SIZES := [Vector2i(1440, 3088), Vector2i(1080, 2220)]
## Keys that are not tied to a tutorial page but belong to this change.
const EXTRA_KEYS := ["TUTORIAL_TITLE", "TUTORIAL_PAGE_COUNTER", "TUTORIAL_NEXT", "TUTORIAL_SKIP",
	"TUTORIAL_DONE", "SETTINGS_HOW_TO_PLAY"]

func _init() -> void:
	_reset_files()
	SettingsStore.save_locale("en", TEST_SETTINGS_PATH)
	var checks: Array[Callable] = [
		_check_not_shown_before_first_dungeon,
		_check_first_dungeon_shows_tutorial_and_skip_marks_seen,
		_check_not_shown_again_after_seen,
		_check_pages_and_done,
		_check_reopens_from_settings,
		_check_back_closes_tutorial,
		_check_fits_portrait_screens,
		_check_rule_numbers_in_text,
		_check_settings_keep_each_other,
		_check_translations,
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

## Settings file with the language only: the tutorial has not been seen yet.
func _fresh_settings() -> void:
	SettingsStore.delete_settings(TEST_SETTINGS_PATH)
	SettingsStore.save_locale("en", TEST_SETTINGS_PATH)

# --- checks -----------------------------------------------------------------------------

func _check_not_shown_before_first_dungeon() -> bool:
	_fresh_settings()
	var main := _new_main()
	await process_frame
	var on_menu: bool = main.tutorial_overlay.is_open()
	main._start_new_game()
	var on_hub: bool = main.tutorial_overlay.is_open()
	_free_main(main)
	if on_menu or on_hub:
		return _fail("The tutorial should not open on the main menu or the hub, only on the first dungeon entry.")
	return true

func _check_first_dungeon_shows_tutorial_and_skip_marks_seen() -> bool:
	_fresh_settings()
	var main := _new_main()
	await process_frame
	main._start_new_game()
	main.start_dungeon_exploration()
	var tutorial: Tutorial = main.tutorial_overlay
	if not tutorial.is_open() or tutorial.page_index != 0 or not main.dungeon_explore_view.visible:
		_free_main(main)
		return _fail("The first dungeon entry should open the tutorial on page 1 over the exploration view.")
	if not tutorial.skip_button.visible or not tutorial.next_button.visible or tutorial.done_button.visible:
		_free_main(main)
		return _fail("The first page should offer Skip and Next, not Done.")
	if SettingsStore.load_tutorial_seen(TEST_SETTINGS_PATH):
		_free_main(main)
		return _fail("The tutorial should only be marked seen once it is closed.")
	tutorial.skip_button.pressed.emit()
	var closed := not tutorial.is_open()
	var still_exploring: bool = main.dungeon_explore_view.visible and not main.dungeon.is_empty()
	_free_main(main)
	if not closed or not still_exploring:
		return _fail("Skip should close the tutorial and leave the player in the dungeon.")
	if not SettingsStore.load_tutorial_seen(TEST_SETTINGS_PATH):
		return _fail("Skip should store the tutorial-seen flag in the settings file.")
	return true

func _check_not_shown_again_after_seen() -> bool:
	# Settings from the previous check: the tutorial was skipped (seen).
	var main := _new_main()
	await process_frame
	main._start_new_game()
	main.start_dungeon_exploration()
	var shown: bool = main.tutorial_overlay.is_open()
	_free_main(main)
	if shown:
		return _fail("The tutorial should show on first run only, not after it was seen.")
	return true

func _check_pages_and_done() -> bool:
	_fresh_settings()
	var main := _new_main()
	await process_frame
	main._start_new_game()
	main.start_dungeon_exploration()
	var tutorial: Tutorial = main.tutorial_overlay
	for page in tutorial.page_count() - 1:
		if tutorial.done_button.visible:
			_free_main(main)
			return _fail("Done should only appear on the last page (shown on page %d)." % (page + 1))
		tutorial.next_button.pressed.emit()
	var counter: String = tutorial.counter_label.text
	var last_page_ok: bool = tutorial.page_index == tutorial.page_count() - 1 and tutorial.done_button.visible \
		and not tutorial.next_button.visible and not tutorial.skip_button.visible
	tutorial.done_button.pressed.emit()
	var closed := not tutorial.is_open()
	var pages := tutorial.page_count()
	_free_main(main)  # `tutorial` is freed with main: only captured values are used below
	if pages < 4:
		return _fail("The tutorial should have a few pages (got %d)." % pages)
	if not last_page_ok or counter != "%d / %d" % [pages, pages]:
		return _fail("The last page should show only Done and the counter %d / %d (got '%s')." % [pages, pages, counter])
	if not closed or not SettingsStore.load_tutorial_seen(TEST_SETTINGS_PATH):
		return _fail("Done should close the tutorial and mark it seen.")
	return true

func _check_reopens_from_settings() -> bool:
	# The tutorial is already seen here; Settings must still open it on demand.
	var main := _new_main()
	await process_frame
	main._show_settings_view()
	var button: Button = main.settings_tutorial_button
	if button == null or not button.visible or button.text != main.tr("SETTINGS_HOW_TO_PLAY"):
		_free_main(main)
		return _fail("Settings should have a visible 'How to play' button.")
	button.pressed.emit()
	var opened: bool = main.tutorial_overlay.is_open() and main.tutorial_overlay.page_index == 0
	main.tutorial_overlay.skip()
	var back_on_settings: bool = main.settings_view.visible and not main.tutorial_overlay.is_open()
	_free_main(main)
	if not opened:
		return _fail("The Settings 'How to play' button should open the tutorial on page 1.")
	if not back_on_settings:
		return _fail("Closing the reopened tutorial should return to Settings.")
	return true

func _check_back_closes_tutorial() -> bool:
	var main := _new_main()
	await process_frame
	main._show_settings_view()
	main._open_tutorial()
	main.handle_back()
	var ok: bool = not main.tutorial_overlay.is_open() and main.settings_view.visible
	_free_main(main)
	if not ok:
		return _fail("Android back should close the tutorial and keep the current screen.")
	return true

func _check_fits_portrait_screens() -> bool:
	var main := _new_main()
	await process_frame
	var original_size := get_root().size
	for language: String in ["en", "es"]:
		TranslationServer.set_locale(language)
		for screen_size: Vector2i in SCREEN_SIZES:
			get_root().size = screen_size
			main._show_settings_view()
			main._open_tutorial()
			var tutorial: Tutorial = main.tutorial_overlay
			for page in tutorial.page_count():
				await process_frame
				await process_frame
				var screen := Rect2(Vector2.ZERO, main.get_viewport_rect().size)
				var buttons: Array[Button] = [tutorial.skip_button, tutorial.next_button, tutorial.done_button]
				for button: Button in buttons:
					if button.visible and (not screen.encloses(button.get_global_rect()) or button.size.y < 48):
						get_root().size = original_size
						_free_main(main)
						return _fail("%s should be fully on screen and touch-sized on page %d at %s (%s)." % [button.name, page + 1, screen_size, language])
				if not screen.encloses(tutorial.card.get_global_rect()):
					get_root().size = original_size
					_free_main(main)
					return _fail("The tutorial card should fit the screen on page %d at %s (%s)." % [page + 1, screen_size, language])
				tutorial.next_page()
	TranslationServer.set_locale("en")
	get_root().size = original_size
	_free_main(main)
	return true

func _check_rule_numbers_in_text() -> bool:
	var main := _new_main()
	await process_frame
	main._open_tutorial()
	var tutorial: Tutorial = main.tutorial_overlay
	var bodies: Dictionary = {}
	for index in tutorial.page_count():
		var body := tutorial.get_page_body(index)
		if body.contains("%s") or body.contains("%%") or body == "":
			_free_main(main)
			return _fail("Tutorial page %d should have its numbers filled in: %s" % [index + 1, body])
		bodies[String(Tutorial.PAGES[index]["id"])] = body
	_free_main(main)
	var energy := String(bodies["energy"])
	var expected_energy := tr("TUTORIAL_ENERGY_BODY") % [str(CombatRules.ENERGY_MOVE_COST), str(CombatRules.ENERGY_ATTACK_COST), str(CombatRules.ENERGY_MOVE_COST), str(CombatRules.ENERGY_QUEST_COST)]
	if energy != expected_energy:
		return _fail("The energy page should show the step and fight-round costs from CombatRules.")
	if not String(bodies["rest"]).contains("%d mana" % CombatRules.REST_MANA_COST) \
		or not String(bodies["rest"]).contains("%d%% of your maximum life" % CombatRules.REST_LIFE_PERCENT) \
		or not String(bodies["rest"]).contains("%d%% of your maximum energy" % CombatRules.REST_ENERGY_PERCENT):
		return _fail("The rest page should show the real mana cost and fixed restore percentages: %s" % bodies["rest"])
	if not String(bodies["retreat"]).contains("green entrance"):
		return _fail("The retreat page should say Retreat only works at the green entrance.")
	var experience := String(bodies["experience"])
	if not experience.contains("Retreat") or not experience.contains("lose"):
		return _fail("The dungeon XP page should explain when run XP is kept and lost.")
	return true

func _check_settings_keep_each_other() -> bool:
	_reset_files()
	SettingsStore.save_tutorial_seen(true, TEST_SETTINGS_PATH)
	SettingsStore.save_locale("es", TEST_SETTINGS_PATH)
	var seen_kept := SettingsStore.load_tutorial_seen(TEST_SETTINGS_PATH)
	SettingsStore.save_tutorial_seen(true, TEST_SETTINGS_PATH)
	var locale_kept := SettingsStore.load_locale("en", TEST_SETTINGS_PATH) == "es"
	SettingsStore.save_locale("en", TEST_SETTINGS_PATH)
	if not seen_kept or not locale_kept:
		return _fail("Saving the language and the tutorial flag should not erase each other.")
	return true

## Every tutorial key is present in both .po files, and the Spanish text differs from the key
## (and from English, except for the language-neutral page counter).
func _check_translations() -> bool:
	var keys: Array = EXTRA_KEYS.duplicate()
	for page: Dictionary in Tutorial.PAGES:
		keys.append(page["title"])
		keys.append(page["body"])
	var english := _read_po("res://localization/menu.en.po")
	var spanish := _read_po("res://localization/menu.es.po")
	for key: String in keys:
		if not english.has(key) or String(english[key]) == "":
			return _fail("%s is missing from menu.en.po." % key)
		if not spanish.has(key) or String(spanish[key]) == "":
			return _fail("%s is missing from menu.es.po." % key)
		if key != "TUTORIAL_PAGE_COUNTER" and spanish[key] == english[key]:
			return _fail("%s is not translated to Spanish." % key)
		if String(english[key]).count("%s") != String(spanish[key]).count("%s"):
			return _fail("%s has a different number of placeholders in EN and ES." % key)
	TranslationServer.set_locale("es")
	var title := tr("TUTORIAL_TITLE")
	TranslationServer.set_locale("en")
	if title != "Cómo jugar":
		return _fail("The tutorial title should be translated at runtime (got '%s')." % title)
	return true

## msgid -> msgstr of a gettext file (single-line entries, as used by this project).
func _read_po(path: String) -> Dictionary:
	var entries: Dictionary = {}
	var current_id := ""
	for line: String in FileAccess.get_file_as_string(path).split("\n"):
		if line.begins_with("msgid "):
			current_id = line.substr(6).trim_prefix("\"").trim_suffix("\"")
		elif line.begins_with("msgstr ") and current_id != "":
			entries[current_id] = line.substr(7).trim_prefix("\"").trim_suffix("\"")
	return entries
