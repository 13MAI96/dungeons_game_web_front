extends SceneTree

const CombatRules := preload("res://scripts/combat_rules.gd")

func _init() -> void:
	await process_frame
	_verify_player_defaults_and_thresholds()
	_verify_leveling_rules()
	_verify_critical_hit()
	_verify_configured_critical_damage()
	_verify_normal_hit_and_counterattack()
	_verify_monster_attack_mana_and_effects()
	_verify_flee_roll()
	_verify_miss_and_dodge()
	_verify_strength_and_resource_rules()
	_verify_defeat_grants_experience()
	_verify_recovery_quest_and_death()
	await process_frame
	quit(0)

func _verify_player_defaults_and_thresholds() -> void:
	var player := CombatRules.create_default_player()
	if int(player["life"]) != 10 or int(player["energy"]) != 25 or int(player["strength"]) != 3 or int(player["speed"]) != 3:
		push_error("Player should start with rules-defined life, energy, strength, and speed.")
		quit(1)
		return
	if player.has("damage") or player.has("current_damage"):
		push_error("Player should not expose persistent damage stats.")
		quit(1)
		return
	if int(player["reserved_progression_points"]) != 5 or int(player["pending_level_points"]) != 5 or not bool(player["level_up_available"]):
		push_error("Player should start with 5 reserved progression points.")
		quit(1)
		return
	if CombatRules.get_experience_threshold(1) != 100 or CombatRules.get_experience_threshold(10) != 1000:
		push_error("Experience thresholds through level 10 should increase by 100.")
		quit(1)
		return
	if CombatRules.get_reputation_threshold(1) != 10 or CombatRules.get_reputation_threshold(10) != 100:
		push_error("Reputation thresholds through level 10 should increase by 10.")
		quit(1)
		return
	if CombatRules.get_experience_threshold(11) != 2200 or CombatRules.get_reputation_threshold(11) != 235:
		push_error("Post-level-10 thresholds should use percentage plus level/10 scaling.")
		quit(1)
		return

func _verify_leveling_rules() -> void:
	var player := CombatRules.create_default_player()
	player["reserved_progression_points"] = 0
	player["pending_level_points"] = 0
	player["level_up_available"] = false
	player["current_experience"] = 350
	player["life_sequel_active"] = true
	player["life_sequel_penalty"] = 1
	var level_state: Dictionary = CombatRules.refresh_level_up_state(player)
	if int(player["current_experience"]) != 350 or not bool(level_state["available"]) or int(level_state["convertible_levels"]) != 3 or int(player["pending_level_points"]) != 0:
		push_error("Experience should overflow thresholds without immediately creating reserved points.")
		quit(1)
		return

	var conversion: Dictionary = CombatRules.convert_available_level_ups(player)
	if int(conversion["converted_levels"]) != 3 or int(player["level"]) != 4 or int(player["reserved_progression_points"]) != 9:
		push_error("Opening progression should convert every available level into reserved points.")
		quit(1)
		return
	if bool(player["life_sequel_active"]) or int(player["life_sequel_penalty"]) != 0:
		push_error("Converted level-up should clear death sequel.")
		quit(1)
		return

	var empty: Dictionary = CombatRules.confirm_level_allocation(player, {})
	if bool(empty["confirmed"]) or int(player["reserved_progression_points"]) != 9:
		push_error("Empty allocation should not be confirmed.")
		quit(1)
		return

	var excessive: Dictionary = CombatRules.confirm_level_allocation(player, {"life": 10})
	if bool(excessive["confirmed"]) or int(player["reserved_progression_points"]) != 9:
		push_error("Allocation should not exceed reserved points.")
		quit(1)
		return

	var confirmed: Dictionary = CombatRules.confirm_level_allocation(player, {"life": 1, "energy": 1, "mana": 1})
	if not bool(confirmed["confirmed"]):
		push_error("Partial level allocation using reserved points should be confirmed.")
		quit(1)
		return
	if int(player["level"]) != 4 or int(player["life"]) != 15 or int(player["energy"]) != 30 or int(player["mana"]) != 16:
		push_error("Level allocation should increase permanent stats with fixed growth values.")
		quit(1)
		return
	if int(player["reserved_progression_points"]) != 6 or int(player["pending_level_points"]) != 6 or not bool(player["level_up_available"]):
		push_error("Confirmed partial allocation should keep unspent points reserved.")
		quit(1)
		return

	var classes := CombatRules.load_player_classes()
	if classes.size() < 3:
		push_error("Player classes should load from JSON.")
		quit(1)
		return
	var early_class: Dictionary = CombatRules.select_player_class(player, "mage")
	if bool(early_class["selected"]):
		push_error("Class selection should remain locked before level 10.")
		quit(1)
		return
	player["level"] = 10
	var class_result: Dictionary = CombatRules.select_player_class(player, "mage")
	if not bool(class_result["selected"]) or String(player["selected_class"]) != "mage":
		push_error("Player should be able to select a class at level 10.")
		quit(1)
		return

	var abilities := CombatRules.load_player_abilities()
	if abilities.is_empty():
		push_error("Player abilities should load from JSON.")
		quit(1)
		return
	var available_abilities := CombatRules.get_available_player_abilities(player)
	var has_mage_ability := false
	for ability: Dictionary in available_abilities:
		if String(ability.get("id", "")) == "arcane_spark" and int(ability.get("mana_cost", -1)) == 3:
			has_mage_ability = true
	if not has_mage_ability:
		push_error("Class-gated player abilities should become available for the selected class.")
		quit(1)
		return
	var simple_result: Dictionary = CombatRules.select_simple_ability(player, "arcane_spark")
	if not bool(simple_result["selected"]):
		push_error("Eligible simple ability should be selectable.")
		quit(1)
		return
	var conflicting_result: Dictionary = CombatRules.select_simple_ability(player, "mana_shell")
	if bool(conflicting_result["selected"]):
		push_error("Simple abilities unlocked at the same level should be exclusive.")
		quit(1)
		return

	var class_player := CombatRules.create_default_player()
	class_player["reserved_progression_points"] = 0
	class_player["pending_level_points"] = 0
	class_player["level"] = 10
	class_player["selected_class"] = "mage"
	class_player["current_experience"] = 2200
	var class_conversion: Dictionary = CombatRules.convert_available_level_ups(class_player)
	if int(class_conversion["converted_levels"]) != 2 or int(class_player["level"]) != 12 or int(class_player["reserved_progression_points"]) != 6:
		push_error("Class progression should always convert every available level into 3 assignable points.")
		quit(1)
		return
	if int(class_player["mana"]) != 16:
		push_error("Class automatic increments should apply when gained levels match the class cadence.")
		quit(1)
		return
	var class_allocation: Dictionary = CombatRules.confirm_level_allocation(class_player, {"mana": 1, "energy": 1, "life": 1})
	if not bool(class_allocation["confirmed"]) or int(class_player["mana"]) != 22 or int(class_player["energy"]) != 29 or int(class_player["life"]) != 13:
		push_error("Selected class stat growth should define how much each assigned point increases each stat.")
		quit(1)
		return

	player = CombatRules.create_default_player()
	player["current_reputation"] = 10
	var reputation_result: Dictionary = CombatRules.apply_reputation_progression(player)
	if int(reputation_result["gained_levels"]) != 1 or int(player["reputation_level"]) != 2 or int(player["reputation_next_level"]) != 20:
		push_error("Reputation level should advance automatically when threshold is reached.")
		quit(1)
		return

func _verify_critical_hit() -> void:
	var player := CombatRules.create_default_player()
	var location := _monster_location(6, 99, 1, 2)
	var result: Dictionary = CombatRules.attack_monster(player, location, 20.0, 20.0, 1.0, 1.0)

	if not bool(result["critical"]) or int(location["content"]["current_life"]) != 2:
		push_error("Critical hit should bypass armor and apply configured critical damage.")
		quit(1)
		return

	if int(player["current_energy"]) != 23:
		push_error("Default attack should consume 2 energy.")
		quit(1)
		return

func _verify_configured_critical_damage() -> void:
	var attacker := {"strength": 0, "current_strength": 0}
	var defender := {"armor": 99, "current_armor": 99, "speed": 100, "current_speed": 100, "current_life": 10}
	var low_bonus: Dictionary = CombatRules.resolve_attack(attacker, defender, {"damage": 3, "critical_threshold": 19, "critical_damage_percent": 10}, 19.0, 20.0)
	if not bool(low_bonus["critical"]) or not bool(low_bonus["hit"]) or bool(low_bonus["dodged"]) or int(low_bonus["damage"]) != 3:
		push_error("Configured critical threshold should bypass armor and floor decimal critical damage.")
		quit(1)
		return

	var high_bonus: Dictionary = CombatRules.resolve_attack(attacker, defender, {"damage": 2, "critical_threshold": 19, "critical_damage_percent": 500}, 19.0, 20.0)
	if int(high_bonus["damage"]) != 12:
		push_error("Configured critical damage percent should apply to the selected attack damage.")
		quit(1)
		return

func _verify_normal_hit_and_counterattack() -> void:
	var player := CombatRules.create_default_player()
	var location := _monster_location(6, 4, 1, 2)
	var result: Dictionary = CombatRules.attack_monster(player, location, 11.0, 1.0, 11.0, 1.0)

	if not bool(result["hit"]) or int(location["content"]["current_life"]) != 4:
		push_error("Normal hit should apply selected attack damage.")
		quit(1)
		return

	if not bool(result["counterattack_hit"]) or int(player["current_life"]) != 9:
		push_error("Monster counterattack should use D20 attack rules and damage player.")
		quit(1)
		return

func _verify_monster_attack_mana_and_effects() -> void:
	var player := CombatRules.create_default_player()
	var location := _monster_location(6, 4, 1, 2)
	location["content"]["attacks"] = [
		{"name": "Scratch", "damage": 1, "critical_threshold": 20, "critical_damage_percent": 0, "mana_cost": 0, "effects": []},
		{"name": "Venom Bite", "damage": 2, "critical_threshold": 20, "critical_damage_percent": 0, "mana_cost": 3, "effects": ["poison"]},
	]
	location["content"]["current_mana"] = 10
	var result: Dictionary = CombatRules.attack_monster(player, location, 1.0, 1.0, 20.0, 1.0, 1)

	if String(result["monster_attack_name"]) != "Venom Bite":
		push_error("Monster counterattack should select the requested attack in deterministic tests.")
		quit(1)
		return
	if int(location["content"]["current_mana"]) != 7:
		push_error("Monster attacks should consume mana cost.")
		quit(1)
		return
	var effects: Array = result["monster_attack_effects"] as Array
	if effects.size() != 1 or String(effects[0]) != "poison":
		push_error("Monster attack effects should be exposed when the attack hits.")
		quit(1)
		return

	if not bool(result["counterattack_hit"]) or int(player["current_life"]) != 8:
		push_error("Selected monster attack should damage player using its attack definition.")
		quit(1)
		return

func _verify_flee_roll() -> void:
	var player := CombatRules.create_default_player()
	var location := _monster_location(6, 4, 1, 2)
	var success: Dictionary = CombatRules.attempt_flee(player, location, 1.0, 1.0, 1.0)
	if not bool(success["fled"]) or bool(success["failed"]) or int(player["current_energy"]) != 24:
		push_error("Flee should consume 1 energy and succeed when D20 plus player speed beats monster speed.")
		quit(1)
		return

	player = CombatRules.create_default_player()
	location = _monster_location(6, 4, 1, 2)
	location["content"]["speed"] = 25
	location["content"]["current_speed"] = 25
	var failure: Dictionary = CombatRules.attempt_flee(player, location, 1.0, 20.0, 1.0)
	if bool(failure["fled"]) or not bool(failure["failed"]) or not bool(failure["counterattack_hit"]):
		push_error("Failed flee should keep combat active and resolve a normal monster attack.")
		quit(1)
		return
	if int(player["current_energy"]) != 24 or int(player["current_life"]) != 9:
		push_error("Failed flee should consume 1 energy and apply monster attack damage when it hits.")
		quit(1)
		return

func _verify_miss_and_dodge() -> void:
	var player := CombatRules.create_default_player()
	var location := _monster_location(6, 20, 1, 2)
	var miss: Dictionary = CombatRules.attack_monster(player, location, 1.0, 1.0, 1.0, 1.0)
	if not bool(miss["miss"]) or int(location["content"]["current_life"]) != 6:
		push_error("Resolved attack value less than or equal to zero should miss.")
		quit(1)
		return

	var attacker := {"strength": 1, "current_strength": 1}
	var defender := {"armor": 1, "current_armor": 1, "speed": 100, "current_speed": 100, "current_life": 10}
	var dodge: Dictionary = CombatRules.resolve_attack(attacker, defender, {"damage": 3}, 10.0, 20.0)
	if not bool(dodge["dodged"]):
		push_error("Defender should dodge when D20 plus defender speed meets the opposed speed difficulty.")
		quit(1)
		return

func _verify_strength_and_resource_rules() -> void:
	var defender := {"armor": 6, "current_armor": 6, "speed": 3, "current_speed": 3}
	var weak := {"strength": 1, "current_strength": 1, "speed": 3, "current_speed": 3}
	var strong := {"strength": 6, "current_strength": 6, "speed": 3, "current_speed": 3}
	var weak_result := CombatRules.resolve_attack(weak, defender, {"damage": 2}, 12.0, 1.0)
	var strong_result := CombatRules.resolve_attack(strong, defender, {"damage": 2}, 12.0, 1.0)
	if not bool(weak_result["miss"]) or not bool(strong_result["hit"]):
		push_error("Increasing strength should improve attack accuracy against the same armor.")
		quit(1)
		return

	var overwhelming_attacker := {"strength": 100, "current_strength": 100, "speed": 3, "current_speed": 3}
	var fragile_defender := {"armor": 0, "current_armor": 0, "speed": 3, "current_speed": 3}
	var capped_miss := CombatRules.resolve_attack(overwhelming_attacker, fragile_defender, {"damage": 2, "critical_threshold": 1}, 2.0, 1.0)
	var capped_hit := CombatRules.resolve_attack(overwhelming_attacker, fragile_defender, {"damage": 2}, 3.0, 1.0)
	if not bool(capped_miss["miss"]) or not bool(capped_hit["hit"]):
		push_error("Attack accuracy should remain capped at 90 percent even with overwhelming strength.")
		quit(1)
		return

	var slow_attacker := {"strength": 3, "current_strength": 3, "speed": 0, "current_speed": 0}
	var fast_defender := {"armor": 0, "current_armor": 0, "speed": 100, "current_speed": 100}
	var capped_dodge_fail := CombatRules.resolve_attack(slow_attacker, fast_defender, {"damage": 2}, 10.0, 13.0)
	var capped_dodge_success := CombatRules.resolve_attack(slow_attacker, fast_defender, {"damage": 2}, 10.0, 14.0)
	if bool(capped_dodge_fail["dodged"]) or not bool(capped_dodge_success["dodged"]):
		push_error("Dodge chance should remain capped at 35 percent even with overwhelming speed.")
		quit(1)
		return

	var player := CombatRules.create_default_player()
	player["current_energy"] = 1
	var location := _monster_location(6, 1, 1, 1)
	var result := CombatRules.attack_monster(player, location, 20.0, 1.0)
	if not bool(result["insufficient_resources"]) or int(player["current_energy"]) != 1 or int(location["content"]["current_life"]) != 6:
		push_error("An attack should be rejected without enough energy and should not consume partial resources.")
		quit(1)
		return

	player = CombatRules.create_default_player()
	player["current_mana"] = 2
	player["attacks"] = [{"name": "Test Spell", "damage": 4, "critical_threshold": 20, "critical_damage_percent": 100, "energy_cost": 1, "mana_cost": 3}]
	location = _monster_location(6, 1, 1, 1)
	result = CombatRules.attack_monster(player, location, 20.0, 1.0)
	if not bool(result["insufficient_resources"]) or int(player["current_mana"]) != 2 or int(player["current_energy"]) != 25:
		push_error("An attack should be rejected without enough mana and should preserve both resources.")
		quit(1)
		return

func _verify_defeat_grants_experience() -> void:
	var player := CombatRules.create_default_player()
	var location := _monster_location(2, 4, 1, 3)
	var result: Dictionary = CombatRules.attack_monster(player, location, 20.0, 0.0)

	if not bool(result["monster_defeated"]):
		push_error("Monster should be defeated when life reaches zero.")
		quit(1)
		return

	if not bool(location["visited"]) or int(player["current_experience"]) != 3:
		push_error("Defeated monster should mark visited and grant dungeon experience.")
		quit(1)
		return

func _verify_recovery_quest_and_death() -> void:
	var player := CombatRules.create_default_player()
	player["current_life"] = 5
	player["current_energy"] = 5
	player["current_mana"] = 12
	CombatRules.rest(player, 20, 40)

	if int(player["current_mana"]) != 7 or int(player["current_life"]) != 9 or int(player["current_energy"]) != 10:
		push_error("Rest should restore life and energy while consuming 5 mana.")
		quit(1)
		return

	player["current_mana"] = 4
	player["current_life"] = 5
	player["current_energy"] = 5
	var failed_rest: Dictionary = CombatRules.rest(player, 20, 40)
	if bool(failed_rest["rested"]) or int(player["current_mana"]) != 4 or int(player["current_life"]) != 5 or int(player["current_energy"]) != 5:
		push_error("Rest should do nothing without 5 available mana.")
		quit(1)
		return

	var sanctuary := _location("SANCTUARY")
	player["current_life"] = 3
	player["current_energy"] = 4
	player["current_mana"] = 2
	CombatRules.apply_sanctuary(player, sanctuary, 50, 50, 50)
	if not bool(sanctuary["visited"]) or int(player["current_life"]) != 8 or int(player["current_energy"]) != 17 or int(player["current_mana"]) != 8:
		push_error("Sanctuary should restore 50-100 percent life, energy, and mana and then count as visited.")
		quit(1)
		return
	player["current_life"] = 3
	var reuse: Dictionary = CombatRules.apply_sanctuary(player, sanctuary, 50, 50, 50)
	if bool(reuse.get("sanctuary", true)) or int(player["current_life"]) != 3:
		push_error("A used sanctuary should not heal again in the same run.")
		quit(1)
		return

	var quest := _location("QUEST")
	CombatRules.resolve_quest(player, quest, 10.0)
	if not bool(quest["visited"]) or int(player["current_energy"]) != 16 or int(player["current_experience"]) != 5:
		push_error("Quest success should consume energy, mark visited, and grant experience on D20 rolls from 10 to 20.")
		quit(1)
		return

	var failed_quest := _location("QUEST")
	player["current_life"] = 10
	player["current_energy"] = 16
	CombatRules.resolve_quest(player, failed_quest, 9.0)
	if not bool(failed_quest["visited"]) or int(player["current_energy"]) != 15 or int(player["current_life"]) != 8:
		push_error("Quest failure should consume energy, mark visited, and damage player on D20 rolls below 10.")
		quit(1)
		return

	player["current_life"] = 0
	player["current_experience"] = 7
	player["dungeon_experience"] = 5
	player["in_dungeon"] = true
	CombatRules.apply_death_sequel(player)
	if int(player["life"]) != 10 or int(player["current_life"]) != 9 or int(player["life_sequel_penalty"]) != 1 or int(player["current_experience"]) != 7 or int(player["dungeon_experience"]) != 0 or bool(player["save_deleted"]):
		push_error("Death should apply temporary 10 percent max-life sequel, preserve accumulated experience, and clear dungeon experience.")
		quit(1)
		return

	player["life"] = 20
	player["life_sequel_penalty"] = 0
	player["current_life"] = 0
	CombatRules.apply_death_sequel(player)
	if int(player["life"]) != 20 or int(player["current_life"]) != 18 or int(player["life_sequel_penalty"]) != 2:
		push_error("Death sequel should scale as 10 percent of maximum life.")
		quit(1)
		return

	player["life"] = 1
	player["life_sequel_penalty"] = 0
	player["current_life"] = 0
	var deleted: Dictionary = CombatRules.apply_death_sequel(player)
	if not bool(deleted["save_deleted"]) or not bool(player["save_deleted"]):
		push_error("Death at one maximum life should mark save deleted.")
		quit(1)
		return

func _monster_location(life: int, armor: int, strength: int, experience: int) -> Dictionary:
	var location := _location("MONSTER")
	location["content"] = {
		"name": "Rat",
		"life": life,
		"max_life": life,
		"current_life": life,
		"armor": armor,
		"mana": 10,
		"max_mana": 10,
		"current_mana": 10,
		"strength": strength,
		"current_strength": strength,
		"speed": 3,
		"current_speed": 3,
		"experience": experience,
			"attacks": [{"name": "Bite", "damage": strength, "critical_threshold": 20, "critical_damage_percent": 0, "mana_cost": 0, "effects": []}],
		}
	return location

func _location(location_type: String) -> Dictionary:
	return {
		"type": location_type,
		"visited": false,
		"content": {},
	}
