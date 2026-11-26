extends SceneTree
## Verifies the progression-hints change (DNG-15):
## - Level Up explains the starting points at level 1 and the points per level afterwards, and
##   tells when the class choice unlocks, until the class level.
## - The hub caption under the level points to Progression for the starting points, then shows
##   the class unlock level, then "choose your class" at the class level.
## - Every hint is hidden once a class is chosen, and the numbers come from CombatRules.
## - The hints are shown in Spanish, also after switching the language in a running game.
## Run: godot --headless --path . -s res://tests/verify_progression_hints.gd

const SaveGame := preload("res://scripts/save_game.gd")
const SettingsStore := preload("res://scripts/settings_store.gd")
const TEST_SAVE_PATH := "user://verify_progression_hints.json"
const TEST_SETTINGS_PATH := "user://verify_progression_hints.cfg"

## Hint templates copied from the .po files, filled with the real rule constants, so a wrong key,
## a missing translation or a hard-coded number fails loudly.
const EN_TEMPLATES := {
	"level_start": "You start with %s points to spend. Each new level gives %s more.",
	"level_points": "Each new level gives %s points to spend.",
	"class_unlock": "At level %s you choose a class.",
	"hub_start": "You start with %s points to spend in Progression.",
	"hub_class_ready": "Choose your class in Progression.",
}
const ES_TEMPLATES := {
	"level_start": "Empezás con %s puntos para repartir. Cada nivel nuevo te da %s más.",
	"level_points": "Cada nivel nuevo te da %s puntos para repartir.",
	"class_unlock": "En el nivel %s elegís una clase.",
	"hub_start": "Empezás con %s puntos para repartir en Progresión.",
	"hub_class_ready": "Elegí tu clase en Progresión.",
}

func _init() -> void:
	var checks: Array[Callable] = [
		_check_rule_constants,
		_check_new_player_hints,
		_check_hub_after_spending_start_points,
		_check_mid_level_hints,
		_check_class_level_hints,
		_check_hints_hidden_after_class_choice,
		_check_spanish_hints,
		_check_language_switch_retranslates_hints,
	]
	for check: Callable in checks:
		var passed: bool = await check.call()
		if not passed:
			return
	_reset_files()
	quit(0)

# --- expected texts ---------------------------------------------------------------------

## The expected hint texts for a language, filled with the CombatRules constants.
func _expected(templates: Dictionary) -> Dictionary:
	var start_points := str(CombatRules.INITIAL_PROGRESSION_POINTS)
	var level_points := str(CombatRules.LEVEL_UP_POINTS)
	var class_level := str(CombatRules.CLASS_CHOICE_LEVEL)
	return {
		"level_start": String(templates["level_start"]) % [start_points, level_points],
		"level_points": String(templates["level_points"]) % level_points,
		"class_unlock": String(templates["class_unlock"]) % class_level,
		"hub_start": String(templates["hub_start"]) % start_points,
		"hub_class_ready": String(templates["hub_class_ready"]),
	}

# --- helpers ----------------------------------------------------------------------------

func _reset_files() -> void:
	SaveGame.delete_save(TEST_SAVE_PATH)
	SettingsStore.delete_settings(TEST_SETTINGS_PATH)

## Instantiates the real main scene in `locale` with test-only save and settings paths, starts
## a new game on the hub and waits one frame so the UI is built.
func _new_game(locale: String = "en") -> Control:
	_reset_files()
	SettingsStore.save_locale(locale, TEST_SETTINGS_PATH)
	var main := (load("res://scenes/main.tscn") as PackedScene).instantiate() as Control
	main.save_path = TEST_SAVE_PATH
	main.settings_path = TEST_SETTINGS_PATH
	get_root().add_child(main)
	await process_frame
	main._start_new_game()
	return main

func _free_main(main: Control) -> void:
	get_root().remove_child(main)
	main.free()

## Frees main (if given), reports the failure and ends the run with exit code 1.
func _fail(message: String, main: Control = null) -> bool:
	if main != null:
		_free_main(main)
	push_error(message)
	_reset_files()
	quit(1)
	return false

## Puts the player at `level` with `reserved` points and no class, without any experience.
func _set_progress(main: Control, level: int, reserved: int) -> void:
	main.player_state["level"] = level
	main.player_state["current_experience"] = CombatRules.get_experience_threshold(level - 1) if level > 1 else 0
	main.player_state["experience_next_level"] = CombatRules.get_experience_threshold(level)
	main.player_state["reserved_progression_points"] = reserved
	main.player_state["pending_level_points"] = reserved
	main.player_state["selected_class"] = ""

## Shown text of a hint label, or "" when the label (or its screen) is hidden.
func _shown(label: Label) -> String:
	return label.text if label.is_visible_in_tree() else ""

## Fails unless the hub hint, the Level Up points hint and the class hint show the given texts
## ("" means hidden). Opens Level Up and returns to the hub to read both screens.
func _expect_hints(main: Control, hub: String, points: String, class_hint: String, context: String) -> bool:
	main._show_new_game_view()
	if _shown(main.hub_progression_hint_label) != hub:
		return _fail("%s: hub hint should be \"%s\", got \"%s\"." % [context, hub, _shown(main.hub_progression_hint_label)], main)
	main._show_level_allocation_view()
	if _shown(main.allocation_points_hint_label) != points:
		return _fail("%s: Level Up points hint should be \"%s\", got \"%s\"." % [context, points, _shown(main.allocation_points_hint_label)], main)
	if _shown(main.allocation_class_hint_label) != class_hint:
		return _fail("%s: Level Up class hint should be \"%s\", got \"%s\"." % [context, class_hint, _shown(main.allocation_class_hint_label)], main)
	main._show_new_game_view()
	return true

# --- checks -----------------------------------------------------------------------------

## The hints describe the current rules; this pins the numbers the user test asked about.
func _check_rule_constants() -> bool:
	if CombatRules.INITIAL_PROGRESSION_POINTS != 5 or CombatRules.LEVEL_UP_POINTS != 3 or CombatRules.CLASS_CHOICE_LEVEL != 10:
		return _fail("Expected 5 starting points, 3 points per level and the class choice at level 10.")
	var player := CombatRules.create_default_player()
	if int(player["reserved_progression_points"]) != CombatRules.INITIAL_PROGRESSION_POINTS:
		return _fail("A new player should hold INITIAL_PROGRESSION_POINTS reserved points.")
	player["level"] = CombatRules.CLASS_CHOICE_LEVEL - 1
	if bool(CombatRules.select_player_class(player, "knight").get("selected", false)):
		return _fail("The class choice should stay locked below CLASS_CHOICE_LEVEL.")
	player["level"] = CombatRules.CLASS_CHOICE_LEVEL
	if not bool(CombatRules.select_player_class(player, "knight").get("selected", false)):
		return _fail("The class choice should unlock at CLASS_CHOICE_LEVEL.")
	return true

## A brand-new game: the hub points to Progression and Level Up explains where the points come
## from and when the class unlocks.
func _check_new_player_hints() -> bool:
	var main: Control = await _new_game()
	var en := _expected(EN_TEMPLATES)
	if not _expect_hints(main, en["hub_start"], en["level_start"], en["class_unlock"], "New player"):
		return false
	_free_main(main)
	return true

## Once the starting points are confirmed, the hub hint moves on to the class unlock level.
func _check_hub_after_spending_start_points() -> bool:
	var main: Control = await _new_game()
	main._show_level_allocation_view()
	for i in CombatRules.INITIAL_PROGRESSION_POINTS:
		main._stage_level_point("life")
	main._confirm_level_allocation()
	var en := _expected(EN_TEMPLATES)
	if not _expect_hints(main, en["class_unlock"], en["level_start"], en["class_unlock"], "Level 1 after spending"):
		return false
	_free_main(main)
	return true

## Between level 2 and the class level, Level Up shows the points per level and the unlock level.
func _check_mid_level_hints() -> bool:
	var main: Control = await _new_game()
	var en := _expected(EN_TEMPLATES)
	for level: int in [2, CombatRules.CLASS_CHOICE_LEVEL - 1]:
		_set_progress(main, level, CombatRules.LEVEL_UP_POINTS)
		if not _expect_hints(main, en["class_unlock"], en["level_points"], en["class_unlock"], "Level %d" % level):
			return false
	_free_main(main)
	return true

## At the class level without a class: no unlock hint (the class choice itself is shown) and the
## hub says the choice is waiting in Progression.
func _check_class_level_hints() -> bool:
	var main: Control = await _new_game()
	_set_progress(main, CombatRules.CLASS_CHOICE_LEVEL, CombatRules.LEVEL_UP_POINTS)
	var en := _expected(EN_TEMPLATES)
	if not _expect_hints(main, en["hub_class_ready"], en["level_points"], "", "Class level"):
		return false
	main._show_level_allocation_view()
	if not main.class_choice_container.visible:
		return _fail("The class choice should be shown at the class level.", main)
	_free_main(main)
	return true

## After choosing a class every progression hint is hidden, on Level Up and on the hub.
func _check_hints_hidden_after_class_choice() -> bool:
	var main: Control = await _new_game()
	_set_progress(main, CombatRules.CLASS_CHOICE_LEVEL, CombatRules.LEVEL_UP_POINTS)
	main._show_level_allocation_view()
	main._select_player_class("knight")
	if String(main.player_state.get("selected_class", "")) != "knight":
		return _fail("Selecting a class at the class level should store it.", main)
	if main.allocation_points_hint_label.visible or main.allocation_class_hint_label.visible:
		return _fail("Level Up hints should hide right after the class is chosen.", main)
	if not _expect_hints(main, "", "", "", "Class chosen"):
		return false
	_set_progress(main, CombatRules.CLASS_CHOICE_LEVEL + 5, 0)
	main.player_state["selected_class"] = "mage"
	if not _expect_hints(main, "", "", "", "Later level with a class"):
		return false
	_free_main(main)
	return true

## The same hints in Spanish (Rioplatense voseo).
func _check_spanish_hints() -> bool:
	var main: Control = await _new_game("es")
	var es := _expected(ES_TEMPLATES)
	if not _expect_hints(main, es["hub_start"], es["level_start"], es["class_unlock"], "Spanish new player"):
		return false
	_set_progress(main, 4, CombatRules.LEVEL_UP_POINTS)
	if not _expect_hints(main, es["class_unlock"], es["level_points"], es["class_unlock"], "Spanish level 4"):
		return false
	_set_progress(main, CombatRules.CLASS_CHOICE_LEVEL, CombatRules.LEVEL_UP_POINTS)
	if not _expect_hints(main, es["hub_class_ready"], es["level_points"], "", "Spanish class level"):
		return false
	_free_main(main)
	return true

## Switching the language in a running game re-translates the hints already on screen.
func _check_language_switch_retranslates_hints() -> bool:
	var main: Control = await _new_game("en")
	main._show_level_allocation_view()
	main._select_locale("es")
	var es := _expected(ES_TEMPLATES)
	if main.allocation_points_hint_label.text != es["level_start"] or main.allocation_class_hint_label.text != es["class_unlock"]:
		return _fail("Level Up hints should follow a language change: \"%s\" / \"%s\"." % [main.allocation_points_hint_label.text, main.allocation_class_hint_label.text], main)
	if main.hub_progression_hint_label.text != es["hub_start"]:
		return _fail("The hub hint should follow a language change: \"%s\"." % main.hub_progression_hint_label.text, main)
	TranslationServer.set_locale("en")
	_free_main(main)
	return true
