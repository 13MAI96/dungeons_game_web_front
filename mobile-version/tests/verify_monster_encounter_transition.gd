extends SceneTree

func _init() -> void:
	var scene := load("res://scenes/main.tscn") as PackedScene
	var root := scene.instantiate()
	get_root().add_child(root)
	await process_frame
	root.player_state["in_dungeon"] = true
	root.player_state["dungeon_experience"] = 0

	root.dungeon = _create_encounter_dungeon()
	root.current_location = root.dungeon["locations"][0]
	root.previous_location = {}
	root._mark_visible_locations()
	root._render_map()
	root._show_dungeon_explore_view()

	root.move_player("right")
	await process_frame

	if not root.monster_encounter_view.visible:
		push_error("Monster encounter view should be visible after moving into a living monster.")
		quit(1)
		return

	if root.dungeon_explore_view.visible:
		push_error("Dungeon exploration view should be hidden during monster encounter.")
		quit(1)
		return

	if root.monster_image_asset.texture == null:
		push_error("Monster encounter should show a monster image asset.")
		quit(1)
		return

	if root.monster_stat_bars.get_node_or_null("LifeStatBar") == null or root.encounter_player_stat_bars.get_node_or_null("LifeStatBar") == null:
		push_error("Monster encounter should render monster and player stat bars.")
		quit(1)
		return

	if root.monster_stat_bars.get_child(0).name != "LifeStatBar" or root.encounter_player_stat_bars.get_child(0).name != "LifeStatBar":
		push_error("Encounter stat bars should start with life for both monster and player.")
		quit(1)
		return

	var monster_visible_children := _visible_child_names(root.monster_image.get_parent())
	if monster_visible_children != ["MonsterPanel", "MonsterImageAsset"]:
		push_error("Monster encounter row should place stats on the left and rival image on the right.")
		quit(1)
		return

	var player_visible_children := _visible_child_names(root.encounter_player_image.get_parent())
	if player_visible_children != ["EncounterPlayerAsset", "EncounterPlayerPanel"]:
		push_error("Player encounter row should place player image on the left and stats on the right.")
		quit(1)
		return

	root.next_attack_roll = 11.0
	root.next_dodge_roll = 1.0
	root.next_counter_roll = 0.0
	root._fight()
	await process_frame

	var monster_life_bar := root.monster_stat_bars.get_node("LifeStatBar/Bar") as ProgressBar
	# The value label sits next to the bar, in the same row (DNG-18).
	var monster_life_value := root.monster_stat_bars.get_node("LifeStatBar/Value") as Label
	var expected_life := 4 - int(preload("res://scripts/combat_rules.gd").get_player_ability("basic_attack")["damage"])
	if monster_life_value.text != "%d/4" % expected_life or int(monster_life_bar.value) != expected_life or int(monster_life_bar.max_value) != 4:
		push_error("Damaged monster life bar should show remaining life over original total.")
		quit(1)
		return

	if root.player_roll_display.text != "" or root.monster_roll_display.text != "":
		push_error("Encounter should not display raw D20 roll values below actor stats.")
		quit(1)
		return

	# The fight log explains both attacks in plain language, with the damage dealt (DNG-13).
	var log_texts: Array[String] = root.fight_log.get_entry_texts()
	var expected_hit := "You hit Rat for %d" % (4 - expected_life)
	if log_texts != [expected_hit, "Your armor stopped Rat's Bite"]:
		push_error("Encounter should explain player and monster attack outcomes in the fight log, got %s." % [log_texts])
		quit(1)
		return

	if not root.monster_info_button.visible:
		push_error("Monster encounter should show an info button near the monster image.")
		quit(1)
		return
	var info_style := root.monster_info_button.get_theme_stylebox("normal") as StyleBoxFlat
	if info_style == null or info_style.corner_radius_top_left < 17:
		push_error("Monster info button should be circular.")
		quit(1)
		return

	root._show_monster_info()
	await process_frame
	if not root.monster_info_modal.visible or not root.monster_info_text.text.contains("Bite"):
		push_error("Monster info modal should list the active monster attacks.")
		quit(1)
		return
	if root.monster_info_modal.color.a < 1.0:
		push_error("Monster info modal background should be opaque.")
		quit(1)
		return
	root._hide_monster_info()
	await process_frame
	if root.monster_info_modal.visible:
		push_error("Monster info modal should be dismissible.")
		quit(1)
		return

	root.dungeon["locations"][1]["content"]["life"] = 4
	root.dungeon["locations"][1]["content"]["max_life"] = 4
	root.dungeon["locations"][1]["content"]["current_life"] = 4

	var energy_before_flee: int = int(root.player_state["current_energy"])
	root.next_flee_roll = 1.0
	root._flee_encounter()
	await process_frame

	if root.monster_encounter_view.visible:
		push_error("Monster encounter should close after fleeing.")
		quit(1)
		return

	if not root.dungeon_explore_view.visible:
		push_error("Dungeon exploration should return after fleeing.")
		quit(1)
		return

	if int(root.player_state["current_energy"]) != energy_before_flee - 1:
		push_error("Flee should consume 1 energy.")
		quit(1)
		return

	if bool(root.dungeon["locations"][1]["visited"]):
		push_error("Fled monster location should remain unvisited.")
		quit(1)
		return

	root.current_location = root.dungeon["locations"][0]
	root.previous_location = {}
	root.move_player("right")
	await process_frame

	if not root.monster_encounter_view.visible:
		push_error("Living monster should trigger encounter again after fleeing and returning.")
		quit(1)
		return

	root.dungeon["locations"][1]["content"]["life"] = 2
	root.dungeon["locations"][1]["content"]["current_life"] = 2
	root.next_attack_roll = 20.0
	root._fight()
	await process_frame

	if root.monster_encounter_view.visible:
		push_error("Monster encounter should close after the monster is defeated.")
		quit(1)
		return

	if not root.dungeon_explore_view.visible:
		push_error("Dungeon exploration should return after the monster is defeated.")
		quit(1)
		return

	if not bool(root.dungeon["locations"][1]["visited"]):
		push_error("Defeated monster location should be marked visited.")
		quit(1)
		return

	if int(root.player_state["current_experience"]) != 0 or int(root.player_state["dungeon_experience"]) != 1:
		push_error("Defeated monster should grant provisional dungeon experience without changing permanent experience.")
		quit(1)
		return

	if root.explore_feedback.text != "":
		push_error("Experience feedback should not remain as exploration text after defeating a monster.")
		quit(1)
		return

	if not root.fight_victory_modal.visible or not root.fight_victory_message.text.contains("+1"):
		push_error("Experience gain should be shown on the fight victory screen.")
		quit(1)
		return

	var victory_icon := root.fight_victory_modal.find_child("Icon", true, false) as TextureRect
	if victory_icon == null or victory_icon.texture == null or String(victory_icon.texture.resource_path) != "res://assets/feedback/underhand.svg":
		push_error("Experience feedback should use underhand asset.")
		quit(1)
		return
	root._hide_fight_victory()

	root.current_location = root.dungeon["locations"][0]
	root.previous_location = {}
	root.move_player("right")
	await process_frame

	if root.monster_encounter_view.visible:
		push_error("Defeated monster should not trigger encounter again.")
		quit(1)
		return

	root.move_player("right")
	await process_frame
	if not root.monster_encounter_view.visible:
		push_error("Second living monster should trigger encounter.")
		quit(1)
		return
	root.dungeon["locations"][2]["content"]["life"] = 2
	root.dungeon["locations"][2]["content"]["current_life"] = 2
	root.next_attack_roll = 20.0
	root._fight()
	await process_frame
	if not root.new_game_view.visible or int(root.player_state["current_reputation"]) != 2 or int(root.player_state["current_experience"]) != 4 or int(root.player_state["dungeon_experience"]) != 0:
		push_error("Defeating every monster should complete the dungeon and award reputation plus matching completion experience.")
		quit(1)
		return

	quit(0)

func _visible_child_names(parent: Node) -> Array[String]:
	var names: Array[String] = []
	for child: Node in parent.get_children():
		if child is CanvasItem and (child as CanvasItem).visible:
			names.append(child.name)
	return names

func _create_encounter_dungeon() -> Dictionary:
	return {
		"number_of_columns": 3,
		"number_of_rows": 1,
		"q_locations": 3,
		"locations": [
			_create_location(1, 1, "ENTRANCE", {}),
			_create_location(2, 1, "MONSTER", {
				"name": "Rat",
				"level": 1,
				"life": 4,
				"max_life": 4,
				"current_life": 4,
				"armor": 4,
				"mana": 10,
				"max_mana": 10,
				"current_mana": 10,
				"strength": 1,
				"current_strength": 1,
				"speed": 3,
				"current_speed": 3,
				"experience": 1,
				"image": "Rat",
				"attacks": [{"name": "Bite", "damage": 1, "energy_cost": 0}],
			}),
			_create_location(3, 1, "MONSTER", {
				"name": "Snake",
				"level": 1,
				"life": 4,
				"max_life": 4,
				"current_life": 4,
				"armor": 4,
				"mana": 10,
				"max_mana": 10,
				"current_mana": 10,
				"strength": 1,
				"current_strength": 1,
				"speed": 3,
				"current_speed": 3,
				"experience": 1,
				"image": "Snake",
				"attacks": [{"name": "Bite", "damage": 1, "energy_cost": 0}],
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
