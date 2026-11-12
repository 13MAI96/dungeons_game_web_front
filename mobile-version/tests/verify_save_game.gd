extends SceneTree

const CombatRules := preload("res://scripts/combat_rules.gd")
const SaveGame := preload("res://scripts/save_game.gd")
const TEST_SAVE_PATH := "user://verify_save_game.json"

func _init() -> void:
	SaveGame.delete_save(TEST_SAVE_PATH)
	var player := CombatRules.create_default_player()
	player["level"] = 4
	player["current_experience"] = 175
	player["dungeon_experience"] = 12
	player["in_dungeon"] = true
	player["life_sequel_active"] = true
	player["life_sequel_penalty"] = 2
	player["selected_class"] = "mage"
	player["selected_simple_abilities"] = {"mage": "arcane_spark"}

	if not SaveGame.save_player(player, TEST_SAVE_PATH):
		_fail("Player save should be written successfully.")
		return
	var loaded := SaveGame.load_player(CombatRules.create_default_player(), TEST_SAVE_PATH)
	if not bool(loaded.get("success", false)):
		_fail("A valid player save should load successfully.")
		return
	var loaded_player := loaded["player"] as Dictionary
	if int(loaded_player["level"]) != 4 or int(loaded_player["current_experience"]) != 175:
		_fail("Level and experience should survive a save round trip.")
		return
	if int(loaded_player["dungeon_experience"]) != 0 or bool(loaded_player["in_dungeon"]):
		_fail("Loading should discard provisional experience from an interrupted dungeon.")
		return
	if int(loaded_player["life_sequel_penalty"]) != 2 or not bool(loaded_player["life_sequel_active"]):
		_fail("Permanent death sequels should survive a save round trip.")
		return
	if String(loaded_player["selected_class"]) != "mage" or String(loaded_player["selected_simple_abilities"].get("mage", "")) != "arcane_spark":
		_fail("Class and ability progression should survive a save round trip.")
		return

	if not SaveGame.delete_save(TEST_SAVE_PATH) or SaveGame.has_save(TEST_SAVE_PATH):
		_fail("Deleting an invalidated save should remove it from storage.")
		return
	var missing := SaveGame.load_player(CombatRules.create_default_player(), TEST_SAVE_PATH)
	if bool(missing.get("success", false)) or String(missing.get("error", "")) != "missing_save":
		_fail("A deleted save should no longer be loadable.")
		return

	var scene := load("res://scenes/main.tscn") as PackedScene
	var root := scene.instantiate() as Control
	root.save_path = TEST_SAVE_PATH
	get_root().add_child(root)
	await process_frame
	var start_button := root.get_node("MainMenuView/MenuArea/MenuButtons/StartGameButton") as Button
	var load_button := root.get_node("MainMenuView/MenuArea/MenuButtons/LoadGameButton") as Button
	if not load_button.disabled:
		_fail("Load Game should be disabled when no save exists.")
		return
	start_button.pressed.emit()
	await process_frame
	if not SaveGame.has_save(TEST_SAVE_PATH) or load_button.disabled:
		_fail("Starting a game should create a save and enable Load Game.")
		return
	root.player_state["level"] = 7
	root._persist_player_state()
	root.player_state["level"] = 1
	load_button.pressed.emit()
	await process_frame
	if int(root.player_state["level"]) != 7:
		_fail("Load Game should restore the persisted player state.")
		return
	root.player_state["save_deleted"] = true
	root._persist_player_state()
	if SaveGame.has_save(TEST_SAVE_PATH) or not load_button.disabled:
		_fail("An invalidated player should delete the save and disable Load Game.")
		return
	quit(0)

func _fail(message: String) -> void:
	SaveGame.delete_save(TEST_SAVE_PATH)
	push_error(message)
	quit(1)
