extends SceneTree
## Verifies the confirmation-dialog-fixes change:
## - DNG-11: Back on Level Up (on-screen button and system back) asks "Discard changes?" only when
##   points are staged; confirming discards them and returns to the hub, cancelling keeps them.
## - DNG-12: the hub Exit asks "Exit game?" with its own message and button, also right after a
##   Level Up discard dialog (the user-test repro), and no confirmation text leaks into another.
## - Both dialogs in Spanish, including re-translating an open dialog after a language change.
## Run: godot --headless --path . -s res://tests/verify_dialog_fixes.gd

const SaveGame := preload("res://scripts/save_game.gd")
const SettingsStore := preload("res://scripts/settings_store.gd")
const TEST_SAVE_PATH := "user://verify_dialog_fixes.json"
const TEST_SETTINGS_PATH := "user://verify_dialog_fixes.cfg"
## Reserved points given to the player, and how many of them each check stages.
const RESERVED_POINTS := 3
const STAGED_POINTS := 2

## Expected texts, copied from the .po files so a wrong key or a leaked text fails loudly.
const EN_EXIT := {"title": "Exit game?", "message": "Your progress is saved. You can continue later with Load Game.", "accept": "Exit"}
const EN_DISCARD := {"title": "Discard changes?", "message": "The points you assigned are not confirmed yet. If you leave, they go back to your reserve.", "accept": "Discard"}
const EN_QUIT := {"title": "Quit the game?", "message": "Your progress is saved.", "accept": "Confirm"}
const ES_EXIT := {"title": "¿Salir de la partida?", "message": "Tu progreso está guardado. Podés seguir más tarde con Cargar Partida.", "accept": "Salir"}
const ES_DISCARD := {"title": "¿Descartar los cambios?", "message": "Los puntos que asignaste todavía no están confirmados. Si salís, vuelven a tu reserva.", "accept": "Descartar"}

func _init() -> void:
	_reset_files()
	var checks: Array[Callable] = [
		_check_back_without_staged_points_leaves_at_once,
		_check_back_button_with_staged_points,
		_check_system_back_with_staged_points,
		_check_real_tap_on_back_asks_first,
		_check_exit_dialog_after_level_up_repro,
		_check_no_text_leaks_between_confirmations,
		_check_spanish_dialogs,
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

## Instantiates the real main scene in `locale` with test-only save and settings paths, and
## waits one frame so it builds its UI.
func _new_main(locale: String = "en") -> Control:
	_reset_files()
	SettingsStore.save_locale(locale, TEST_SETTINGS_PATH)
	var main := (load("res://scenes/main.tscn") as PackedScene).instantiate() as Control
	main.save_path = TEST_SAVE_PATH
	main.settings_path = TEST_SETTINGS_PATH
	get_root().add_child(main)
	await process_frame
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

## Starts a new game with reserved points and opens Level Up with `staged` points on life.
func _open_level_up(main: Control, staged: int) -> void:
	main._start_new_game()
	main.player_state["reserved_progression_points"] = RESERVED_POINTS
	main._show_level_allocation_view()
	for i in staged:
		main._stage_level_point("life")

## Visible texts of the shared confirmation dialog, or {} when it is closed.
func _dialog_texts(main: Control) -> Dictionary:
	if not main.action_confirmation.visible:
		return {}
	return {
		"title": main.confirmation_title.text,
		"message": main.confirmation_message.text,
		"accept": main.confirmation_accept_button.text,
	}

## Describes a mismatch between the open dialog and the expected texts ("" when they match).
func _dialog_mismatch(main: Control, expected: Dictionary) -> String:
	var shown := _dialog_texts(main)
	return "" if shown == expected else "expected %s, shown %s" % [expected, shown]

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

# --- checks -------------------------------------------------------------------------------

## Both Back paths leave Level Up immediately when nothing is staged.
func _check_back_without_staged_points_leaves_at_once() -> bool:
	var main: Control = await _new_main()
	_open_level_up(main, 0)
	main.allocation_back_button.pressed.emit()
	if not main.new_game_view.visible or main.action_confirmation.visible:
		return _fail("Back button on Level Up without staged points should return to the hub with no dialog.", main)
	main._show_level_allocation_view()
	main.handle_back()
	if not main.new_game_view.visible or main.action_confirmation.visible:
		return _fail("System back on Level Up without staged points should return to the hub with no dialog.", main)
	_free_main(main)
	return true

## On-screen Back with staged points: asks first; cancel keeps the points, confirm discards them.
func _check_back_button_with_staged_points() -> bool:
	var main: Control = await _new_main()
	_open_level_up(main, STAGED_POINTS)
	main.allocation_back_button.pressed.emit()
	var mismatch := _dialog_mismatch(main, EN_DISCARD)
	if mismatch != "" or not main.level_allocation_view.visible:
		return _fail("Back button with staged points should ask to discard and stay on Level Up: %s" % mismatch, main)
	main.confirmation_cancel_button.pressed.emit()
	if main.action_confirmation.visible or not main.level_allocation_view.visible or main._get_staged_points() != STAGED_POINTS:
		return _fail("Cancelling the discard should stay on Level Up with the staged points intact.", main)
	var max_life_before := int(main.player_state["life"])
	main.allocation_back_button.pressed.emit()
	main.confirmation_accept_button.pressed.emit()
	if not main.new_game_view.visible or main.action_confirmation.visible:
		return _fail("Confirming the discard should return to the hub.", main)
	if int(main.player_state["reserved_progression_points"]) != RESERVED_POINTS or int(main.player_state["life"]) != max_life_before:
		return _fail("Discarded points should go back to the reserve without changing any statistic.", main)
	main._show_level_allocation_view()
	if main._get_staged_points() != 0:
		return _fail("Level Up should open without staged points after a discard.", main)
	_free_main(main)
	return true

## System back with staged points: asks first; back again cancels; accepting discards.
func _check_system_back_with_staged_points() -> bool:
	var main: Control = await _new_main()
	_open_level_up(main, STAGED_POINTS)
	main.handle_back()
	var mismatch := _dialog_mismatch(main, EN_DISCARD)
	if mismatch != "" or not main.level_allocation_view.visible:
		return _fail("System back with staged points should ask to discard and stay on Level Up: %s" % mismatch, main)
	main.handle_back()  # back on an open dialog cancels it
	if main.action_confirmation.visible or not main.level_allocation_view.visible or main._get_staged_points() != STAGED_POINTS:
		return _fail("Back on the discard dialog should cancel it and keep the staged points.", main)
	main.handle_back()
	main._confirm_pending_action()
	if not main.new_game_view.visible or int(main.player_state["reserved_progression_points"]) != RESERVED_POINTS:
		return _fail("Confirming the discard after system back should return to the hub with the reserve intact.", main)
	_free_main(main)
	return true

## A real player tap on Back (after the input cooldown) goes through the same confirmation.
func _check_real_tap_on_back_asks_first() -> bool:
	var main: Control = await _new_main()
	_open_level_up(main, 1)
	await process_frame  # lay out the Level Up screen so the button has a real rect
	await _wait_for_cooldown(main)
	_tap(main.allocation_back_button)
	await process_frame
	var mismatch := _dialog_mismatch(main, EN_DISCARD)
	if mismatch != "" or not main.level_allocation_view.visible:
		return _fail("A real tap on Back with staged points should ask to discard: %s" % mismatch, main)
	_free_main(main)
	return true

## The user-test repro: stage points, open (and leave) the discard dialog, go to the hub and
## press Exit. The dialog must be the Exit one, with no allocation wording.
func _check_exit_dialog_after_level_up_repro() -> bool:
	var main: Control = await _new_main()
	_open_level_up(main, STAGED_POINTS)
	main.allocation_back_button.pressed.emit()
	main._confirm_pending_action()  # discard and return to the hub
	main.exit_button.pressed.emit()
	var mismatch := _dialog_mismatch(main, EN_EXIT)
	if mismatch != "":
		return _fail("Hub Exit after a Level Up discard should show the Exit dialog: %s" % mismatch, main)
	if main.confirmation_message.text.to_lower().contains("allocation"):
		return _fail("The Exit dialog must not mention allocation changes.", main)
	main.handle_back()  # system back on the hub uses the same Exit dialog
	main.handle_back()
	mismatch = _dialog_mismatch(main, EN_EXIT)
	if mismatch != "":
		return _fail("System back on the hub should show the Exit dialog: %s" % mismatch, main)
	main._confirm_pending_action()
	if not main.main_menu_view.visible:
		return _fail("Confirming Exit should return to the main menu.", main)
	_free_main(main)
	return true

## Each confirmation shows its own title, message and buttons, whatever was open before, and a
## dialog hidden by a screen change can no longer be accepted.
func _check_no_text_leaks_between_confirmations() -> bool:
	var main: Control = await _new_main()
	_open_level_up(main, STAGED_POINTS)
	main.handle_back()  # discard dialog ("Discard" button)
	main._show_new_game_view()  # a screen change closes it without a choice
	if main.action_confirmation.visible or main.pending_confirmation_action.is_valid():
		return _fail("A screen change should close the confirmation and drop its action.", main)
	main._request_exit_to_menu()
	var mismatch := _dialog_mismatch(main, EN_EXIT)
	if mismatch != "":
		return _fail("Exit after a dialog closed by a screen change should show its own texts: %s" % mismatch, main)
	main._confirm_pending_action()  # to the main menu
	main.handle_back()  # quit dialog: must use the default "Confirm", not "Exit"
	mismatch = _dialog_mismatch(main, EN_QUIT)
	if mismatch != "":
		return _fail("System back on the main menu should show the quit dialog: %s" % mismatch, main)
	main.handle_back()
	if main.action_confirmation.visible or main.confirmation_title.text != "" or main.confirmation_accept_button.text != EN_QUIT["accept"]:
		return _fail("A closed confirmation should keep no title and reset the accept label.", main)
	if main.confirmation_cancel_button.text != main.tr("CONFIRM_CANCEL"):
		return _fail("Every confirmation should show the Cancel label.", main)
	_free_main(main)
	return true

## Spanish texts of both dialogs, plus re-translation of an open dialog on a language change.
func _check_spanish_dialogs() -> bool:
	var main: Control = await _new_main("es")
	_open_level_up(main, STAGED_POINTS)
	main.allocation_back_button.pressed.emit()
	var mismatch := _dialog_mismatch(main, ES_DISCARD)
	if mismatch != "":
		return _fail("The discard dialog should be in Spanish: %s" % mismatch, main)
	main._confirm_pending_action()
	main.exit_button.pressed.emit()
	mismatch = _dialog_mismatch(main, ES_EXIT)
	if mismatch != "":
		return _fail("The Exit dialog should be in Spanish: %s" % mismatch, main)
	# A language change re-translates the dialog that is open instead of resetting its texts.
	TranslationServer.set_locale("en")
	main._apply_menu_text()
	mismatch = _dialog_mismatch(main, EN_EXIT)
	TranslationServer.set_locale("es")
	if mismatch != "":
		return _fail("A language change should re-translate the open dialog: %s" % mismatch, main)
	_free_main(main)
	return true
