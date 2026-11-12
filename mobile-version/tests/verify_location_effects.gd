extends SceneTree

func _init() -> void:
	var scene := load("res://scenes/main.tscn") as PackedScene
	var root := scene.instantiate()
	get_root().add_child(root)
	await process_frame

	root.dungeon = _create_effect_dungeon()
	root.current_location = root.dungeon["locations"][0]
	root.previous_location = {}
	root.player_state["current_life"] = 5
	root.player_state["current_energy"] = 5
	root.player_state["current_mana"] = 2
	root._mark_visible_locations()
	root._render_map()

	root.move_player("right")
	await process_frame

	if int(root.player_state["current_life"]) < 10 or int(root.player_state["current_energy"]) < 16 or int(root.player_state["current_mana"]) < 8:
		push_error("Moving should cost energy and sanctuary should restore 50-100 percent life, energy, and mana.")
		quit(1)
		return

	if bool(root.dungeon["locations"][1]["visited"]):
		push_error("Sanctuary should remain unvisited so it can trigger again.")
		quit(1)
		return

	var energy_before_quest_move := int(root.player_state["current_energy"])
	root.next_quest_roll = 20.0
	root.move_player("right")
	await process_frame

	if not root.collect_treasure_button.visible:
		push_error("Quest location should show collect treasure action before resolution.")
		quit(1)
		return

	if int(root.player_state["current_energy"]) != energy_before_quest_move - 1:
		push_error("Moving to quest should consume movement energy before treasure resolution.")
		quit(1)
		return

	root._collect_treasure()
	await process_frame

	if int(root.player_state["current_energy"]) != energy_before_quest_move - 2:
		push_error("Quest should consume 1 energy.")
		quit(1)
		return

	if int(root.player_state["current_experience"]) != 5:
		push_error("Quest success should grant 5 experience.")
		quit(1)
		return

	if root.collect_treasure_button.visible:
		push_error("Resolved quest should hide collect treasure action.")
		quit(1)
		return

	root.current_location = root.dungeon["locations"][2]
	root.current_location["type"] = "EMPTY"
	root.rest_button.disabled = true
	root.dungeon_exit_pending = false
	root._update_exploration_actions()
	if root.rest_button.disabled:
		push_error("Rest should be re-enabled on an empty tile when a new active dungeon is not exiting.")
		quit(1)
		return
	root.player_state["current_mana"] = int(root.player_state["mana"])
	var full_mana_before_rest := int(root.player_state["current_mana"])
	root._rest()
	if int(root.player_state["current_mana"]) != full_mana_before_rest - 5:
		push_error("Rest should be usable from an empty tile with full mana and consume 5 mana.")
		quit(1)
		return

	root.player_state["current_mana"] = 12
	root.player_state["current_life"] = 5
	root.player_state["current_energy"] = 5
	root._rest()

	if int(root.player_state["current_mana"]) != 7 or int(root.player_state["current_life"]) < 6 or int(root.player_state["current_life"]) > 9 or int(root.player_state["current_energy"]) < 6 or int(root.player_state["current_energy"]) > 11:
		push_error("Rest should restore life and energy in rule ranges while consuming 5 mana.")
		quit(1)
		return

	root.player_state["current_mana"] = 4
	root.player_state["current_life"] = 5
	root.player_state["current_energy"] = 5
	root._rest()

	if int(root.player_state["current_mana"]) != 4 or int(root.player_state["current_life"]) != 5 or int(root.player_state["current_energy"]) != 5:
		push_error("Rest should do nothing without enough mana.")
		quit(1)
		return

	root.current_location = root.dungeon["locations"][1]
	root._update_exploration_actions()
	if not root.retreat_button.disabled:
		push_error("Retreat should be disabled away from the entrance.")
		quit(1)
		return

	root.current_location = root.dungeon["locations"][0]
	root.player_state["current_energy"] = 1
	root._update_exploration_actions()
	var entrance_color: Color = root._get_location_color(root.current_location)
	if not entrance_color.is_equal_approx(Color(0.2, 0.7, 0.38, 1.0)):
		push_error("Entrance should remain green even when it is visited and current.")
		quit(1)
		return
	root._retreat()
	await process_frame
	if not root.new_game_view.visible or int(root.player_state["current_energy"]) != int(root.player_state["energy"]):
		push_error("Retreat from entrance should exit alive even when it spends the last energy point.")
		quit(1)
		return

	quit(0)

func _create_effect_dungeon() -> Dictionary:
	return {
		"number_of_columns": 3,
		"number_of_rows": 1,
		"q_locations": 3,
		"locations": [
			_create_location(1, 1, "ENTRANCE"),
			_create_location(2, 1, "SANCTUARY"),
			_create_location(3, 1, "QUEST"),
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
