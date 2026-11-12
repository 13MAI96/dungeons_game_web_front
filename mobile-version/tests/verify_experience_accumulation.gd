extends SceneTree

const CombatRules := preload("res://scripts/combat_rules.gd")
const SaveGame := preload("res://scripts/save_game.gd")
const TEST_SAVE_PATH := "user://verify_experience_accumulation.json"

func _init() -> void:
	SaveGame.delete_save(TEST_SAVE_PATH)
	var scene := load("res://scenes/main.tscn") as PackedScene
	var root := scene.instantiate() as Control
	root.save_path = TEST_SAVE_PATH
	get_root().add_child(root)
	await process_frame

	root.player_state["current_experience"] = 10
	root.player_state["dungeon_experience"] = 99
	CombatRules.begin_dungeon_experience(root.player_state)
	if int(root.player_state["current_experience"]) != 10 or int(root.player_state["dungeon_experience"]) != 0:
		_fail("A new dungeon should start provisional experience at zero without changing permanent experience.")
		return
	root.player_state["dungeon_experience"] = 3
	_complete_dungeon(root, 3)
	if int(root.player_state["current_experience"]) != 15:
		_fail("The first dungeon should add its 3 experience and 2 completion experience to the accumulated total.")
		return

	CombatRules.begin_dungeon_experience(root.player_state)
	root.player_state["dungeon_experience"] = 4
	_complete_dungeon(root, 4)
	if int(root.player_state["current_experience"]) != 21:
		_fail("A second dungeon should add its rewards to the previous accumulated experience.")
		return

	var loaded := SaveGame.load_player(CombatRules.create_default_player(), TEST_SAVE_PATH)
	if not bool(loaded.get("success", false)) or int((loaded["player"] as Dictionary)["current_experience"]) != 21:
		_fail("Accumulated experience should survive a save round trip.")
		return

	CombatRules.begin_dungeon_experience(root.player_state)
	root.player_state["dungeon_experience"] = 9
	CombatRules.discard_dungeon_experience(root.player_state)
	if int(root.player_state["current_experience"]) != 21 or int(root.player_state["dungeon_experience"]) != 0:
		_fail("Discarding a failed run should clear only provisional dungeon experience.")
		return

	SaveGame.delete_save(TEST_SAVE_PATH)
	root.queue_free()
	quit(0)

func _complete_dungeon(root: Control, dungeon_experience: int) -> void:
	root.player_state["dungeon_experience"] = dungeon_experience
	root.dungeon = _create_completed_dungeon()
	root._complete_dungeon_if_ready(0)

func _create_completed_dungeon() -> Dictionary:
	return {
		"number_of_columns": 3,
		"number_of_rows": 1,
		"q_locations": 3,
		"locations": [
			_create_location(1, "ENTRANCE", {}),
			_create_location(2, "MONSTER", {"life": 0}),
			_create_location(3, "MONSTER", {"life": 0}),
		],
	}

func _create_location(column: int, location_type: String, content: Dictionary) -> Dictionary:
	return {
		"_id": null,
		"column": column,
		"row": 1,
		"type": location_type,
		"content": content,
		"visited": true,
		"visible": true,
		"show": false,
		"canVisit": false,
	}

func _fail(message: String) -> void:
	SaveGame.delete_save(TEST_SAVE_PATH)
	push_error(message)
	quit(1)
