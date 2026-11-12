extends SceneTree

const SaveGame := preload("res://scripts/save_game.gd")
const SettingsStore := preload("res://scripts/settings_store.gd")
const TEST_SAVE_PATH := "user://verify_confirmations.json"
const TEST_SETTINGS_PATH := "user://verify_confirmations.cfg"

func _init() -> void:
	SaveGame.delete_save(TEST_SAVE_PATH)
	SettingsStore.delete_settings(TEST_SETTINGS_PATH)
	SettingsStore.save_locale("en", TEST_SETTINGS_PATH)
	var scene := load("res://scenes/main.tscn") as PackedScene
	var root := scene.instantiate() as Control
	root.save_path = TEST_SAVE_PATH
	root.settings_path = TEST_SETTINGS_PATH
	get_root().add_child(root)
	await process_frame

	root._request_new_game()
	if not root.new_game_view.visible or not SaveGame.has_save(TEST_SAVE_PATH):
		_fail("Starting without an existing save should immediately create a new game.")
		return
	root.player_state["level"] = 6
	root._persist_player_state()
	root._show_main_menu_view()
	root._request_new_game()
	if not root.action_confirmation.visible or int(root.player_state["level"]) != 6:
		_fail("Replacing an existing save should require confirmation before changing player state.")
		return
	root._cancel_pending_action()
	root.action_confirmation.hide()
	if int(root.player_state["level"]) != 6:
		_fail("Canceling new game confirmation should preserve the current player.")
		return
	root._request_new_game()
	root._confirm_pending_action()
	if int(root.player_state["level"]) != 1:
		_fail("Confirming a new game should replace the previous player.")
		return

	root._request_exit_to_menu()
	if not root.action_confirmation.visible or not root.new_game_view.visible:
		_fail("Returning to the main menu should require confirmation.")
		return
	root._confirm_pending_action()
	if not root.main_menu_view.visible:
		_fail("Confirming exit should return to the main menu.")
		return

	root._show_game_result("Dungeon completed", "Rewards granted")
	if not root.game_result_modal.visible or root.game_result_title.text != "Dungeon completed" or root.game_result_message.text != "Rewards granted":
		_fail("A completed expedition should display a clear final result.")
		return
	root.game_result_continue_button.pressed.emit()
	if root.game_result_modal.visible:
		_fail("The final result should remain visible until the player dismisses it.")
		return
	SaveGame.delete_save(TEST_SAVE_PATH)
	SettingsStore.delete_settings(TEST_SETTINGS_PATH)
	quit(0)

func _fail(message: String) -> void:
	SaveGame.delete_save(TEST_SAVE_PATH)
	SettingsStore.delete_settings(TEST_SETTINGS_PATH)
	push_error(message)
	quit(1)
