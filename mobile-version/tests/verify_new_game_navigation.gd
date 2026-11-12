extends SceneTree

const CombatRules := preload("res://scripts/combat_rules.gd")
const SaveGame := preload("res://scripts/save_game.gd")
const TEST_SAVE_PATH := "user://verify_new_game_navigation.json"

func _init() -> void:
	SaveGame.delete_save(TEST_SAVE_PATH)
	var scene := load("res://scenes/main.tscn") as PackedScene
	var root := scene.instantiate() as Control
	root.save_path = TEST_SAVE_PATH
	get_root().add_child(root)
	await process_frame

	var main_menu_view := root.get_node("MainMenuView") as Control
	var new_game_view := root.get_node("NewGameView") as Control
	var start_game_button := root.get_node("MainMenuView/MenuArea/MenuButtons/StartGameButton") as Button

	if not main_menu_view.visible:
		push_error("Main menu should be visible before pressing Start Game.")
		quit(1)
		return

	if new_game_view.visible:
		push_error("New game view should be hidden before pressing Start Game.")
		quit(1)
		return

	start_game_button.pressed.emit()
	await process_frame

	if main_menu_view.visible:
		push_error("Main menu should be hidden after pressing Start Game.")
		quit(1)
		return

	if not new_game_view.visible:
		push_error("New game view should be visible after pressing Start Game.")
		quit(1)
		return

	if not root.character_portrait is TextureRect or root.character_portrait.texture == null:
		push_error("New game view should have a character portrait texture.")
		quit(1)
		return

	if root.stats_column.get_node_or_null("LifeStatBar") == null:
		push_error("New game stats should render icon stat bars.")
		quit(1)
		return

	if not root.progression_indicator.visible:
		push_error("New game progression action should show a pending indicator when points are reserved.")
		quit(1)
		return
	var indicator_style := root.progression_indicator.get_theme_stylebox("panel") as StyleBoxFlat
	if indicator_style == null or indicator_style.corner_radius_top_left < 6 or root.progression_indicator.offset_right != -2 or root.progression_indicator.offset_top != 2:
		push_error("Progression pending indicator should be a circular badge in the button corner.")
		quit(1)
		return

	root._show_level_allocation_view()
	await process_frame
	if not root.level_allocation_view.visible or int(root.player_state["reserved_progression_points"]) != 5:
		push_error("New players should be able to allocate 5 initial progression points.")
		quit(1)
		return
	root._show_new_game_view()
	await process_frame

	root.player_state["reserved_progression_points"] = 0
	root.player_state["pending_level_points"] = 0
	root.player_state["level_up_available"] = false
	root.player_state["current_experience"] = int(root.player_state["experience_next_level"])
	CombatRules.refresh_level_up_state(root.player_state)
	root._show_level_allocation_view()
	await process_frame
	if not root.level_allocation_view.visible or int(root.player_state["reserved_progression_points"]) != 3:
		push_error("Progression action should convert available levels and open allocation view.")
		quit(1)
		return
	var life_plus_button := _find_visible_allocation_button(root, "LifeAllocationRow", "PlusButton")
	if life_plus_button == null:
		push_error("Life allocation plus button should be present.")
		quit(1)
		return
	life_plus_button.pressed.emit()
	await process_frame
	if root.allocation_confirm_button.disabled:
		push_error("Allocation confirm should enable after at least one reserved point is staged.")
		quit(1)
		return
	root._stage_level_point_delta("life", -1)
	if not root.allocation_confirm_button.disabled:
		push_error("Allocation confirm should be disabled when no points are staged.")
		quit(1)
		return
	root._stage_level_point("life")
	root._stage_level_point("energy")
	root._stage_level_point("strength")
	root._confirm_level_allocation()
	await process_frame
	if int(root.player_state["level"]) != 2 or int(root.player_state["life"]) != 15 or int(root.player_state["energy"]) != 30 or int(root.player_state["strength"]) != 4:
		push_error("Confirmed allocation should permanently increase selected stats.")
		quit(1)
		return
	if int(root.player_state["reserved_progression_points"]) != 0:
		push_error("Spent reserved points should be removed from reserve.")
		quit(1)
		return

	if root.progression_indicator.visible:
		push_error("Progression pending indicator should hide when all reserved points are spent.")
		quit(1)
		return

	SaveGame.delete_save(TEST_SAVE_PATH)
	quit(0)

func _find_visible_allocation_button(root: Control, row_name: String, button_name: String) -> Button:
	for child: Node in root.allocation_buttons_container.get_children():
		if not child is CanvasItem or not (child as CanvasItem).visible:
			continue
		for button_candidate: Node in child.get_children():
			if String(button_candidate.name).contains(button_name) and button_candidate is Button:
				return button_candidate as Button
	return null
