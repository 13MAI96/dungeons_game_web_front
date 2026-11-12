extends SceneTree

func _init() -> void:
	var scene := load("res://scenes/main.tscn") as PackedScene
	var root := scene.instantiate()
	get_root().add_child(root)
	await process_frame

	root.dungeon = _create_linear_dungeon()
	root.current_location = root.dungeon["locations"][0]
	root.previous_location = {}
	root._mark_visible_locations()
	root._render_map()

	var initial_directions: Dictionary = root.get_valid_directions()
	if not initial_directions.has("right"):
		push_error("Right should be available from the entrance.")
		quit(1)
		return

	root.move_player("right")
	await process_frame

	if int(root.current_location["column"]) != 2:
		push_error("Player did not move right to column 2.")
		quit(1)
		return

	if root.map_grid.get_child_count() < 2 or root.map_grid.get_child(1).get_node_or_null("LocationIcon") == null:
		push_error("Visible quest location should render a map icon.")
		quit(1)
		return

	var next_directions: Dictionary = root.get_valid_directions()
	if not next_directions.has("left"):
		push_error("Backtracking to the previous location should be available.")
		quit(1)
		return

	if next_directions.has("right"):
		push_error("Movement into a block location should be unavailable.")
		quit(1)
		return

	root._update_direction_buttons()
	if root.move_right_button.visible != true or root.move_right_button.disabled != true:
		push_error("Blocked direction button should remain visible and disabled.")
		quit(1)
		return

	quit(0)

func _create_linear_dungeon() -> Dictionary:
	return {
		"number_of_columns": 3,
		"number_of_rows": 1,
		"q_locations": 3,
		"locations": [
			_create_location(1, 1, "ENTRANCE"),
			_create_location(2, 1, "QUEST"),
			_create_location(3, 1, "BLOCK"),
		],
	}

func _create_location(column: int, row: int, location_type: String) -> Dictionary:
	return {
		"_id": null,
		"column": column,
		"row": row,
		"type": location_type,
		"content": {},
		"visited": location_type == "ENTRANCE",
		"visible": location_type == "ENTRANCE",
		"show": false,
		"canVisit": false,
	}
