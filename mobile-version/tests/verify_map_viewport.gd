extends SceneTree

func _init() -> void:
	var scene := load("res://scenes/main.tscn") as PackedScene
	var root := scene.instantiate()
	get_root().add_child(root)
	await process_frame

	root.dungeon = _create_large_dungeon()
	root.current_location = root.dungeon["locations"][44]
	root.previous_location = {}
	root._mark_visible_locations()
	root._render_map()

	if root.map_grid.columns != 5:
		push_error("Large map should display at most 5 columns.")
		quit(1)
		return

	if root.map_grid.get_child_count() != 35:
		push_error("Large map should display a 5 by 7 viewport.")
		quit(1)
		return

	var centered_window: Dictionary = root._get_map_window()
	if int(centered_window["start_column"]) != 3 or int(centered_window["start_row"]) != 2:
		push_error("Map viewport should center around player when possible.")
		quit(1)
		return

	root.current_location = root.dungeon["locations"][0]
	root._render_map()
	var edge_window: Dictionary = root._get_map_window()
	if int(edge_window["start_column"]) != 1 or int(edge_window["start_row"]) != 1:
		push_error("Map viewport should stay at the top-left edge near map boundary.")
		quit(1)
		return

	quit(0)

func _create_large_dungeon() -> Dictionary:
	var locations: Array[Dictionary] = []
	for row in range(1, 9):
		for column in range(1, 9):
			locations.append({
				"_id": null,
				"column": column,
				"row": row,
				"type": "ENTRANCE" if column == 1 and row == 1 else "QUEST",
				"content": {},
				"visited": column == 1 and row == 1,
				"visible": true,
				"show": true,
				"canVisit": true,
			})
	return {
		"number_of_columns": 8,
		"number_of_rows": 8,
		"q_locations": 64,
		"locations": locations,
	}
