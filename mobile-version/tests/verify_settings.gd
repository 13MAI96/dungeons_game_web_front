extends SceneTree

const SettingsStore := preload("res://scripts/settings_store.gd")
const TEST_SETTINGS_PATH := "user://verify_settings.cfg"

func _init() -> void:
	SettingsStore.delete_settings(TEST_SETTINGS_PATH)
	var scene := load("res://scenes/main.tscn") as PackedScene
	var root := scene.instantiate() as Control
	root.settings_path = TEST_SETTINGS_PATH
	get_root().add_child(root)
	await process_frame

	var settings_button := root.get_node("MainMenuView/MenuArea/MenuButtons/SettingsButton") as Button
	var challenge_button := root.get_node("NewGameView/ActionArea/ActionButtons/ChallengeDungeonButton") as Button
	var shop_button := root.get_node("NewGameView/ActionArea/ActionButtons/ShopButton") as Button
	if not challenge_button.disabled or not shop_button.disabled:
		_fail("Unavailable game actions should be disabled.")
		return
	if not challenge_button.text.contains(tr("COMING_SOON")) or not shop_button.text.contains(tr("COMING_SOON")):
		_fail("Unavailable game actions should be marked as coming soon.")
		return

	settings_button.pressed.emit()
	await process_frame
	if not root.settings_view.visible or root.main_menu_view.visible:
		_fail("Settings should open from the main menu.")
		return
	root._select_locale("es")
	if TranslationServer.get_locale() != "es" or SettingsStore.load_locale("en", TEST_SETTINGS_PATH) != "es":
		_fail("Spanish selection should apply immediately and persist.")
		return
	if root.settings_title.text != "Ajustes" or not root.settings_spanish_button.disabled:
		_fail("Settings controls should refresh in the selected language.")
		return
	root._select_locale("en")
	if TranslationServer.get_locale() != "en" or SettingsStore.load_locale("es", TEST_SETTINGS_PATH) != "en":
		_fail("English selection should apply immediately and persist.")
		return
	SettingsStore.delete_settings(TEST_SETTINGS_PATH)
	quit(0)

func _fail(message: String) -> void:
	SettingsStore.delete_settings(TEST_SETTINGS_PATH)
	push_error(message)
	quit(1)
