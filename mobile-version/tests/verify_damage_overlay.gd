extends SceneTree

func _init() -> void:
	var scene := load("res://scenes/main.tscn") as PackedScene
	var root := scene.instantiate()
	get_root().add_child(root)
	await process_frame

	root.dungeon = _create_encounter_dungeon()
	root.current_location = root.dungeon["locations"][0]
	root.previous_location = {}
	root._mark_visible_locations()
	root._render_map()
	root._show_dungeon_explore_view()

	root.move_player("right")
	await process_frame

	root.next_attack_roll = 5.0
	root.next_counter_roll = 20.0
	root._fight()
	await process_frame

	if not root.damage_overlay.visible:
		push_error("Damage overlay should be visible after player receives damage.")
		quit(1)
		return

	if root.damage_overlay_icon.texture == null:
		push_error("Damage overlay should show explosion asset.")
		quit(1)
		return

	if root.damage_overlay_text.text == "":
		push_error("Damage overlay should show feedback text.")
		quit(1)
		return

	quit(0)

func _create_encounter_dungeon() -> Dictionary:
	return {
		"number_of_columns": 2,
		"number_of_rows": 1,
		"q_locations": 2,
		"locations": [
			_create_location(1, 1, "ENTRANCE", {}),
			_create_location(2, 1, "MONSTER", {
				"name": "Rat",
				"life": 6,
				"armor": 4,
				"mana": 10,
				"damage": 1,
				"experience": 1,
				"image": "Rat",
			}),
		],
	}

func _create_location(column: int, row: int, location_type: String, content: Dictionary) -> Dictionary:
	return {
		"_id": null,
		"column": column,
		"row": row,
		"type": location_type,
		"content": content,
		"visited": location_type == "ENTRANCE",
		"visible": location_type == "ENTRANCE",
		"show": false,
		"canVisit": false,
	}
