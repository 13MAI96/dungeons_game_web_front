extends SceneTree

func _init() -> void:
	await _verify_energy_depletion_exits_dungeon()
	await _verify_life_depletion_exits_dungeon()
	quit(0)

func _verify_energy_depletion_exits_dungeon() -> void:
	var root := await _create_root()
	root.dungeon = _create_monster_dungeon()
	root.current_location = root.dungeon["locations"][0]
	root.player_state["current_energy"] = 3
	root.player_state["current_experience"] = 7
	root.player_state["dungeon_experience"] = 5
	root.player_state["in_dungeon"] = true
	root._mark_visible_locations()
	root._render_map()
	root._show_dungeon_explore_view()

	root.move_player("right")
	await process_frame

	root.next_attack_roll = 5.0
	root.next_counter_roll = 0.0
	root._fight()
	await process_frame

	if not root.damage_overlay.visible or not root.damage_overlay_text.text.contains("energy"):
		push_error("Energy depletion should show a notification before returning to the new game view.")
		quit(1)
		return

	if not root.dungeon_exit_pending or not root.fight_button.disabled:
		push_error("Energy depletion should block dungeon actions while exit notification is pending.")
		quit(1)
		return

	await create_timer(1.0).timeout

	if not root.new_game_view.visible:
		push_error("Energy depletion should exit to the new game view after the notification.")
		quit(1)
		return

	if root.monster_encounter_view.visible or root.dungeon_explore_view.visible:
		push_error("Energy depletion should close dungeon and encounter views.")
		quit(1)
		return

	if int(root.player_state["current_experience"]) != 7 or int(root.player_state["dungeon_experience"]) != 0:
		push_error("Energy depletion should preserve accumulated experience and clear only dungeon-run experience.")
		quit(1)
		return

	if int(root.player_state["current_energy"]) != int(root.player_state["energy"]) or int(root.player_state["current_life"]) != int(root.player_state["life"]) or int(root.player_state["current_mana"]) != int(root.player_state["mana"]):
		push_error("Energy depletion should exit the dungeon and restore life, energy, and mana.")
		quit(1)
		return

	root.queue_free()

func _verify_life_depletion_exits_dungeon() -> void:
	var root := await _create_root()
	root.dungeon = _create_quest_dungeon()
	root.current_location = root.dungeon["locations"][0]
	root.player_state["current_life"] = 2
	root.player_state["current_experience"] = 7
	root.player_state["dungeon_experience"] = 5
	root.player_state["in_dungeon"] = true
	root._mark_visible_locations()
	root._render_map()
	root._show_dungeon_explore_view()

	root.next_quest_roll = 0.0
	root.move_player("right")
	await process_frame
	root._collect_treasure()
	await process_frame

	if not root.damage_overlay.visible or not root.damage_overlay_text.text.contains("life"):
		push_error("Life depletion should show a notification before returning to the new game view.")
		quit(1)
		return

	await create_timer(1.0).timeout

	if not root.new_game_view.visible:
		push_error("Life depletion should exit to the new game view after the notification.")
		quit(1)
		return

	if root.monster_encounter_view.visible or root.dungeon_explore_view.visible:
		push_error("Life depletion should close dungeon views.")
		quit(1)
		return

	if int(root.player_state["current_experience"]) != 7 or int(root.player_state["dungeon_experience"]) != 0:
		push_error("Life depletion should preserve accumulated experience and clear only dungeon-run experience.")
		quit(1)
		return

	if int(root.player_state["life"]) != 10 or int(root.player_state["life_sequel_penalty"]) != 1 or int(root.player_state["current_life"]) != 9 or int(root.player_state["current_energy"]) != int(root.player_state["energy"]) or int(root.player_state["current_mana"]) != int(root.player_state["mana"]):
		push_error("Life depletion should apply temporary 10 percent death sequel and restore energy and mana.")
		quit(1)
		return

	root.queue_free()

func _create_root() -> Control:
	var scene := load("res://scenes/main.tscn") as PackedScene
	var root := scene.instantiate()
	get_root().add_child(root)
	await process_frame
	return root

func _create_monster_dungeon() -> Dictionary:
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

func _create_quest_dungeon() -> Dictionary:
	return {
		"number_of_columns": 2,
		"number_of_rows": 1,
		"q_locations": 2,
		"locations": [
			_create_location(1, 1, "ENTRANCE", {}),
			_create_location(2, 1, "QUEST", {}),
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
