extends SceneTree

const CombatRules := preload("res://scripts/combat_rules.gd")
const DungeonGenerator := preload("res://scripts/dungeon_generator.gd")
const SAMPLE_COUNT := 250

func _init() -> void:
	for player_level in [1, 5, 10]:
		_report_dungeons(player_level)
	_report_combat()
	quit(0)

func _report_dungeons(player_level: int) -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 7100 + player_level
	var totals := {
		"cells": 0,
		"monsters": 0,
		"quests": 0,
		"sanctuaries": 0,
		"blocks": 0,
	}
	var min_monsters := 1000000
	var max_monsters := 0
	for _sample in range(SAMPLE_COUNT):
		var dungeon := DungeonGenerator.create_dungeon(1, rng, player_level)
		var monsters := 0
		for location: Dictionary in dungeon["locations"]:
			var location_type := String(location.get("type", ""))
			match location_type:
				DungeonGenerator.LOCATION_MONSTER:
					monsters += 1
				DungeonGenerator.LOCATION_QUEST:
					totals["quests"] += 1
				DungeonGenerator.LOCATION_SANCTUARY:
					totals["sanctuaries"] += 1
				DungeonGenerator.LOCATION_BLOCK:
					totals["blocks"] += 1
		totals["cells"] += int(dungeon["q_locations"])
		totals["monsters"] += monsters
		min_monsters = mini(min_monsters, monsters)
		max_monsters = maxi(max_monsters, monsters)
	print("DUNGEON level=%d samples=%d avg_cells=%.2f avg_monsters=%.2f min_monsters=%d max_monsters=%d avg_quests=%.2f avg_sanctuaries=%.2f avg_blocks=%.2f min_attack_energy=%.2f" % [
		player_level,
		SAMPLE_COUNT,
		float(totals["cells"]) / SAMPLE_COUNT,
		float(totals["monsters"]) / SAMPLE_COUNT,
		min_monsters,
		max_monsters,
		float(totals["quests"]) / SAMPLE_COUNT,
		float(totals["sanctuaries"]) / SAMPLE_COUNT,
		float(totals["blocks"]) / SAMPLE_COUNT,
		float(totals["monsters"]) * CombatRules.ENERGY_ATTACK_COST / SAMPLE_COUNT,
	])

func _report_combat() -> void:
	var templates := DungeonGenerator.get_monster_templates()
	var basic_attack := CombatRules.get_player_ability("basic_attack")
	for strength in [3, 8]:
		var player := CombatRules.create_default_player()
		player["strength"] = strength
		player["current_strength"] = strength
		var hit_total := 0
		var damage_total := 0
		var attempts := 0
		for template: Dictionary in templates:
			for attack_roll in range(1, 21):
				for dodge_roll in range(1, 21):
					var result := CombatRules.resolve_attack(player, template, basic_attack, attack_roll, dodge_roll)
					hit_total += 1 if bool(result["hit"]) else 0
					damage_total += int(result["damage"]) if bool(result["hit"]) else 0
					attempts += 1
		print("PLAYER_COMBAT strength=%d hit_rate=%.3f expected_damage_per_action=%.3f" % [strength, float(hit_total) / attempts, float(damage_total) / attempts])

	for speed in [3, 8]:
		var defender := CombatRules.create_default_player()
		defender["speed"] = speed
		defender["current_speed"] = speed
		var dodges := 0
		var eligible_hits := 0
		for template: Dictionary in templates:
			var attack := (template["attacks"] as Array)[0] as Dictionary
			for attack_roll in range(1, 21):
				for dodge_roll in range(1, 21):
					var result := CombatRules.resolve_attack(template, defender, attack, attack_roll, dodge_roll)
					dodges += 1 if bool(result["dodged"]) else 0
					eligible_hits += 1 if bool(result["hit"]) or bool(result["dodged"]) else 0
		print("PLAYER_DEFENSE speed=%d dodge_rate_when_attack_passes=%.3f" % [speed, float(dodges) / maxi(1, eligible_hits)])
