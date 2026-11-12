extends SceneTree
## Verifies the app shell from the mobile-ui-refresh change: reserved ad slot, single active
## view, confirmation modal fitting the screen, player marker, stable map sizing, touch sizes,
## input-blocking overlay and localized combat feedback.

const SaveGame := preload("res://scripts/save_game.gd")
const SettingsStore := preload("res://scripts/settings_store.gd")
const AdSlotConfig := preload("res://scripts/ad_slot_config.gd")
const UiTheme := preload("res://scripts/ui_theme.gd")
const DungeonGenerator := preload("res://scripts/dungeon_generator.gd")
const TEST_SAVE_PATH := "user://verify_ui_shell.json"
const TEST_SETTINGS_PATH := "user://verify_ui_shell.cfg"

var main: Control

func _init() -> void:
	SaveGame.delete_save(TEST_SAVE_PATH)
	SettingsStore.delete_settings(TEST_SETTINGS_PATH)
	SettingsStore.save_locale("en", TEST_SETTINGS_PATH)
	main = (load("res://scenes/main.tscn") as PackedScene).instantiate() as Control
	main.save_path = TEST_SAVE_PATH
	main.settings_path = TEST_SETTINGS_PATH
	get_root().add_child(main)
	await process_frame

	if not _check_ad_slot():
		return
	if not _check_single_active_view():
		return
	if not await _check_confirmation_fits():
		return
	if not await _check_map_marker_and_sizing():
		return
	if not _check_touch_sizes():
		return
	if not _check_overlay_and_localization():
		return
	SaveGame.delete_save(TEST_SAVE_PATH)
	SettingsStore.delete_settings(TEST_SETTINGS_PATH)
	quit(0)

func _check_ad_slot() -> bool:
	var reserved := float(AdSlotConfig.reserved_height())
	for screen: Array in [[main.main_menu_view, "_show_main_menu_view"], [main.new_game_view, "_show_new_game_view"], [main.settings_view, "_show_settings_view"]]:
		main.call(screen[1])
		if not main.is_ad_slot_visible():
			return _fail("Ad slot should be visible on %s." % screen[1])
		if AdSlotConfig.height < 50:
			return _fail("Ad slot should reserve at least 50 logical pixels.")
		var view := screen[0] as Control
		if -view.offset_bottom < reserved:
			return _fail("%s content should stop above the ad slot and its separation gap." % view.name)
	main.start_dungeon_exploration()
	if main.is_ad_slot_visible() or main.dungeon_explore_view.offset_bottom != -float(main.safe_insets["bottom"]):
		return _fail("Exploration should hide the ad slot and use the full safe area.")
	AdSlotConfig.enabled = false
	main._show_new_game_view()
	var collapsed: bool = not main.is_ad_slot_visible() and main.new_game_view.offset_bottom == -float(main.safe_insets["bottom"])
	AdSlotConfig.enabled = true
	if not collapsed:
		return _fail("Disabling ads should collapse the slot to zero space.")
	return true

func _check_single_active_view() -> bool:
	main._show_settings_view()
	main.start_dungeon_exploration()
	var visible_views := 0
	for view: Control in [main.main_menu_view, main.new_game_view, main.dungeon_explore_view, main.monster_encounter_view, main.settings_view, main.level_allocation_view, main.monster_info_modal]:
		if view.visible:
			visible_views += 1
	if visible_views != 1 or not main.dungeon_explore_view.visible:
		return _fail("Showing a screen should hide every other screen (settings stayed visible).")
	return true

func _check_confirmation_fits() -> bool:
	main._show_new_game_view()
	main._request_exit_to_menu()
	await process_frame
	await process_frame
	if not main.action_confirmation.visible:
		return _fail("Leaving the hub should show the in-game confirmation modal.")
	var viewport_rect := Rect2(Vector2.ZERO, main.get_viewport_rect().size)
	for button: Button in [main.confirmation_accept_button, main.confirmation_cancel_button]:
		if not viewport_rect.encloses(button.get_global_rect()):
			return _fail("Confirmation actions should be fully on screen.")
	if main.confirmation_message.autowrap_mode == TextServer.AUTOWRAP_OFF:
		return _fail("Confirmation message should wrap.")
	main.confirmation_cancel_button.pressed.emit()
	if main.action_confirmation.visible or not main.new_game_view.visible:
		return _fail("Cancel should close the modal without leaving the hub.")
	return true

func _count_markers() -> int:
	var count := 0
	for cell: Node in main.map_grid.get_children():
		if cell.get_node_or_null("PlayerMarker") != null:
			count += 1
	return count

func _check_map_marker_and_sizing() -> bool:
	main.start_dungeon_exploration()
	await process_frame
	if main.current_location.get("type") != DungeonGenerator.LOCATION_ENTRANCE:
		return _fail("Exploration should start on the entrance.")
	if _count_markers() != 1:
		return _fail("The entrance cell should show exactly one player marker.")
	if not main._get_location_color(main.current_location).is_equal_approx(Color(0.2, 0.7, 0.38, 1.0)):
		return _fail("The entrance should stay green under the player marker.")
	var size_before: int = main._get_map_cell_size()
	main.explore_feedback.text = "A long feedback message that needs two lines to be displayed on a narrow phone screen."
	main.collect_treasure_button.visible = true
	await process_frame
	if main._get_map_cell_size() != size_before:
		return _fail("Feedback text or Collect Treasure should not change the map cell size.")
	await process_frame
	var map_frame := main.map_grid.get_parent() as Control
	var map_area := map_frame.get_parent() as Control
	if map_frame.get_global_rect().position.y < map_area.get_global_rect().position.y - 0.5:
		return _fail("The map should not be clipped above its area.")
	return true

func _check_touch_sizes() -> bool:
	var buttons: Array = [main.start_game_button, main.load_game_button, main.settings_button,
		main.explore_dungeon_button, main.manage_equipment_button, main.exit_button,
		main.rest_button, main.retreat_button, main.collect_treasure_button,
		main.fight_button, main.flee_button, main.monster_info_button,
		main.confirmation_accept_button, main.confirmation_cancel_button,
		main.game_result_continue_button, main.allocation_confirm_button,
		main.settings_english_button, main.settings_spanish_button, main.settings_back_button]
	for button: Button in buttons:
		if button.get_combined_minimum_size().y < UiTheme.TOUCH_MIN:
			return _fail("%s should be at least %d px tall." % [button.name, UiTheme.TOUCH_MIN])
	for button: Button in [main.start_game_button, main.explore_dungeon_button, main.fight_button]:
		if button.get_combined_minimum_size().y < UiTheme.PRIMARY_HEIGHT:
			return _fail("%s is a primary action and should be at least %d px tall." % [button.name, UiTheme.PRIMARY_HEIGHT])
	for button: Button in [main.move_left_button, main.move_right_button, main.move_up_button, main.move_down_button]:
		var size := button.get_combined_minimum_size()
		if minf(size.x, size.y) < UiTheme.DPAD_SIZE or button.icon == null or button.text != "":
			return _fail("%s should be an arrow icon button of at least %d px." % [button.name, UiTheme.DPAD_SIZE])
	return true

func _check_overlay_and_localization() -> bool:
	if main.damage_overlay.mouse_filter != Control.MOUSE_FILTER_STOP:
		return _fail("The feedback overlay should block taps on the actions underneath.")
	TranslationServer.set_locale("es")
	var feedback: String = main._format_combat_feedback({"hit": true, "monster_attack_name": "Mordisco", "counterattack_hit": true})
	TranslationServer.set_locale("en")
	if feedback.contains("Your attack") or not feedback.contains("Mordisco"):
		return _fail("Combat feedback should be localized to Spanish: %s" % feedback)
	return true

func _fail(message: String) -> bool:
	push_error(message)
	SaveGame.delete_save(TEST_SAVE_PATH)
	SettingsStore.delete_settings(TEST_SETTINGS_PATH)
	quit(1)
	return false
