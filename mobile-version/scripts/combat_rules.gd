class_name CombatRules

const ENERGY_MOVE_COST := 1
const ENERGY_ATTACK_COST := 1
const ENERGY_QUEST_COST := 1
const ENERGY_RETREAT_COST := 1
const REST_MANA_COST := 5
const QUEST_REWARD_EXPERIENCE := 5
const QUEST_FAILURE_DAMAGE := 2
## A treasure (quest) succeeds on a d20 roll of this value or more; lower rolls trigger the trap.
const QUEST_SUCCESS_ROLL := 10
## Rest restores a random percentage of maximum energy and life within these bounds.
const REST_ENERGY_PERCENT_MIN := 5
const REST_ENERGY_PERCENT_MAX := 25
const REST_LIFE_PERCENT_MIN := 10
const REST_LIFE_PERCENT_MAX := 40
## A sanctuary restores a random percentage of maximum life, energy and mana within these bounds.
const SANCTUARY_PERCENT_MIN := 50
const SANCTUARY_PERCENT_MAX := 100
const LEVEL_UP_POINTS := 3
const INITIAL_PROGRESSION_POINTS := 5
const ATTACK_BASE_DIFFICULTY := 10
const MIN_REQUIRED_ATTACK_ROLL := 3
const MAX_REQUIRED_ATTACK_ROLL := 19
const DODGE_BASE_DIFFICULTY := 20
const MIN_REQUIRED_DODGE_ROLL := 14
const MAX_REQUIRED_DODGE_ROLL := 20
const ATTRIBUTE_SCALE_DIVISOR := 2.0
const STRENGTH_DAMAGE_BASELINE := 3
const THRESHOLD_CAP := 1 << 52
const PLAYER_ABILITIES_PATH := "res://data/player_abilities.json"
const PLAYER_CLASSES_PATH := "res://data/player_classes.json"
const STAT_GROWTH := {
	"life": 5,
	"energy": 5,
	"mana": 4,
	"armor": 1,
	"speed": 1,
	"strength": 1,
}
const DEFAULT_PLAYER_ATTACK := {
	"id": "basic_attack",
	"name": "Strike",
	"unlock_level": 1,
	"type": "attack",
	"active": true,
	"damage": 3,
	"critical_threshold": 20,
	"critical_damage_percent": 100,
	"mana_cost": 0,
	"energy_cost": ENERGY_ATTACK_COST,
	"class_requirements": [],
	"simple_skill_group": "",
	"effects": [],
}
const FALLBACK_PLAYER_ABILITIES := [
	{"id": "basic_attack", "name": "Strike", "unlock_level": 1, "type": "attack", "active": true, "damage": 3, "critical_threshold": 20, "critical_damage_percent": 100, "energy_cost": 1, "mana_cost": 0, "class_requirements": [], "simple_skill_group": "level_1_simple", "effects": []},
	{"id": "guarded_rest", "name": "Guarded Rest", "unlock_level": 1, "type": "self_effect", "active": true, "damage": 0, "critical_threshold": 20, "critical_damage_percent": 0, "energy_cost": 0, "mana_cost": REST_MANA_COST, "class_requirements": [], "simple_skill_group": "", "effects": ["rest"]},
	{"id": "arcane_spark", "name": "Arcane Spark", "unlock_level": 10, "type": "attack", "active": true, "damage": 4, "critical_threshold": 19, "critical_damage_percent": 10, "energy_cost": 1, "mana_cost": 3, "class_requirements": ["mage"], "simple_skill_group": "level_10_simple", "effects": []},
	{"id": "mana_shell", "name": "Mana Shell", "unlock_level": 10, "type": "passive", "active": false, "damage": 0, "critical_threshold": 20, "critical_damage_percent": 0, "energy_cost": 0, "mana_cost": 0, "class_requirements": ["mage"], "simple_skill_group": "level_10_simple", "effects": ["mana_recovery"]},
	{"id": "shield_wall", "name": "Shield Wall", "unlock_level": 10, "type": "passive", "active": false, "damage": 0, "critical_threshold": 20, "critical_damage_percent": 0, "energy_cost": 0, "mana_cost": 0, "class_requirements": ["knight"], "simple_skill_group": "level_10_simple", "effects": ["armor_boost"]},
	{"id": "quick_hands", "name": "Quick Hands", "unlock_level": 10, "type": "passive", "active": false, "damage": 0, "critical_threshold": 20, "critical_damage_percent": 0, "energy_cost": 0, "mana_cost": 0, "class_requirements": ["thief"], "simple_skill_group": "level_10_simple", "effects": ["energy_recovery"]},
]
const FALLBACK_PLAYER_CLASSES := [
	{"id": "mage", "name": "Mage", "progression": {"points_per_level": LEVEL_UP_POINTS, "stat_growth": {"life": 3, "energy": 4, "mana": 6, "armor": 1, "speed": 1, "strength": 1}, "automatic_increment_every": 2, "automatic_increments": {"mana": 1}}},
	{"id": "knight", "name": "Knight", "progression": {"points_per_level": LEVEL_UP_POINTS, "stat_growth": {"life": 7, "energy": 4, "mana": 3, "armor": 2, "speed": 1, "strength": 1}, "automatic_increment_every": 2, "automatic_increments": {"life": 1, "armor": 1}}},
	{"id": "thief", "name": "Thief", "progression": {"points_per_level": LEVEL_UP_POINTS, "stat_growth": {"life": 4, "energy": 7, "mana": 3, "armor": 1, "speed": 2, "strength": 1}, "automatic_increment_every": 2, "automatic_increments": {"energy": 1, "speed": 1}}},
]

static func create_default_player() -> Dictionary:
	return {
		"life": 10,
		"current_life": 10,
		"energy": 25,
		"current_energy": 25,
		"mana": 12,
		"current_mana": 12,
		"armor": 3,
		"current_armor": 3,
		"strength": 3,
		"current_strength": 3,
		"speed": 3,
		"current_speed": 3,
		"reputation": get_reputation_threshold(1),
		"current_reputation": 0,
		"current_experience": 0,
		"dungeon_experience": 0,
		"in_dungeon": false,
		"experience_next_level": get_experience_threshold(1),
		"level": 1,
		"level_up_available": true,
		"pending_level_points": INITIAL_PROGRESSION_POINTS,
		"reserved_progression_points": INITIAL_PROGRESSION_POINTS,
		"selected_class": "",
			"selected_simple_abilities": {},
			"reputation_level": 1,
			"reputation_next_level": get_reputation_threshold(1),
			"vision": 1,
				"life_sequel_active": false,
				"life_sequel_penalty": 0,
			"save_deleted": false,
			"attacks": [get_player_ability("basic_attack") if not get_player_ability("basic_attack").is_empty() else DEFAULT_PLAYER_ATTACK.duplicate(true)],
		}

static func get_experience_threshold(level: int) -> int:
	if level <= 10:
		return maxi(1, level) * 100
	var threshold := 1000.0
	for current_level in range(11, level + 1):
		# Grows by (10 + level / 10) percent per level: level 11 needs 1111, level 20 about 2900.
		threshold += threshold * (10.0 + float(current_level) / 10.0) / 100.0
	# Capped far beyond any reachable level so the float never overflows into a negative int.
	return mini(roundi(threshold), THRESHOLD_CAP)

static func get_reputation_threshold(level: int) -> int:
	if level <= 10:
		return maxi(1, level) * 10
	var threshold := 100.0
	for current_level in range(11, level + 1):
		threshold += threshold * (25.0 + float(current_level) / 10.0) / 100.0
	# Capped far beyond any reachable level so the float never overflows into a negative int.
	return mini(roundi(threshold), THRESHOLD_CAP)

static func refresh_level_up_state(player: Dictionary) -> Dictionary:
	var current_level: int = int(player.get("level", 1))
	var threshold: int = int(player.get("experience_next_level", get_experience_threshold(current_level)))
	player["experience_next_level"] = threshold
	var reserved_points: int = int(player.get("reserved_progression_points", player.get("pending_level_points", 0)))
	player["reserved_progression_points"] = reserved_points
	player["pending_level_points"] = reserved_points
	player["level_up_available"] = reserved_points > 0 or int(player.get("current_experience", 0)) >= threshold
	return {"available": bool(player["level_up_available"]), "points": reserved_points, "convertible_levels": get_convertible_level_count(player)}

static func get_convertible_level_count(player: Dictionary) -> int:
	var level: int = int(player.get("level", 1))
	var experience: int = int(player.get("current_experience", 0))
	var count: int = 0
	var threshold: int = get_experience_threshold(level)
	while experience >= threshold:
		count += 1
		level += 1
		threshold = get_experience_threshold(level)
	return count

static func convert_available_level_ups(player: Dictionary) -> Dictionary:
	var converted_levels: int = 0
	var gained_points: int = 0
	var automatic_increments: Dictionary = {}
	while int(player.get("current_experience", 0)) >= get_experience_threshold(int(player.get("level", 1))):
		player["level"] = int(player.get("level", 1)) + 1
		converted_levels += 1
		gained_points += _get_points_per_level(player)
		var class_increments := _get_class_automatic_increments_for_level(player, int(player["level"]))
		_apply_stat_increments(player, class_increments, false)
		for stat_key: String in class_increments:
			automatic_increments[stat_key] = int(automatic_increments.get(stat_key, 0)) + int(class_increments[stat_key])

	if converted_levels > 0:
		_clear_life_sequel(player)
		player["reserved_progression_points"] = int(player.get("reserved_progression_points", player.get("pending_level_points", 0))) + gained_points
		player["pending_level_points"] = int(player["reserved_progression_points"])
		player["experience_next_level"] = get_experience_threshold(int(player.get("level", 1)))
		player["level_up_available"] = int(player["reserved_progression_points"]) > 0 or int(player.get("current_experience", 0)) >= int(player["experience_next_level"])
	else:
		refresh_level_up_state(player)
	return {"converted_levels": converted_levels, "points": gained_points, "automatic_increments": automatic_increments}

static func confirm_level_allocation(player: Dictionary, allocation: Dictionary, in_dungeon: bool = false) -> Dictionary:
	var reserved_points: int = int(player.get("reserved_progression_points", player.get("pending_level_points", 0)))
	if reserved_points <= 0:
		return {"confirmed": false, "message": "NO_PENDING_POINTS"}
	var used_points: int = 0

	for stat_variant: Variant in STAT_GROWTH.keys():
		var stat_name: String = String(stat_variant)
		var points: int = int(allocation.get(stat_name, 0))
		if points < 0:
			return {"confirmed": false, "message": "INVALID_ALLOCATION"}
		used_points += points
	if used_points <= 0:
		return {"confirmed": false, "message": "INCOMPLETE_ALLOCATION"}
	if used_points > reserved_points:
		return {"confirmed": false, "message": "ALLOCATION_EXCEEDS_RESERVE"}

	for stat_variant: Variant in STAT_GROWTH.keys():
		var stat_name: String = String(stat_variant)
		var points: int = int(allocation.get(stat_name, 0))
		if points <= 0:
			continue
		_apply_stat_increase(player, stat_name, get_stat_growth_for_player(player, stat_name) * points, in_dungeon)

	player["reserved_progression_points"] = reserved_points - used_points
	player["pending_level_points"] = int(player["reserved_progression_points"])
	player["experience_next_level"] = get_experience_threshold(int(player.get("level", 1)))
	player["level_up_available"] = int(player["reserved_progression_points"]) > 0 or int(player.get("current_experience", 0)) >= int(player["experience_next_level"])
	return {"confirmed": true, "level": int(player.get("level", 1)), "spent_points": used_points, "reserved_points": int(player["reserved_progression_points"])}

static func load_player_abilities() -> Array[Dictionary]:
	return _load_dictionary_array(PLAYER_ABILITIES_PATH, FALLBACK_PLAYER_ABILITIES)

static func load_player_classes() -> Array[Dictionary]:
	return _load_dictionary_array(PLAYER_CLASSES_PATH, FALLBACK_PLAYER_CLASSES)

static func get_available_player_abilities(player: Dictionary) -> Array[Dictionary]:
	var available: Array[Dictionary] = []
	var selected_simple_abilities := player.get("selected_simple_abilities", {}) as Dictionary
	for ability: Dictionary in load_player_abilities():
		if int(player.get("level", 1)) < int(ability.get("unlock_level", 1)):
			continue
		if not _class_requirement_is_satisfied(player, ability):
			continue
		var simple_key := _get_simple_ability_key(ability)
		if simple_key != "":
			var selected_id: String = String(selected_simple_abilities.get(simple_key, ""))
			if selected_id != "" and selected_id != String(ability.get("id", "")):
				continue
		available.append(ability.duplicate(true))
	return available

static func select_simple_ability(player: Dictionary, ability_id: String) -> Dictionary:
	var ability := get_player_ability(ability_id)
	if ability.is_empty():
		return {"selected": false, "message": "ABILITY_NOT_FOUND"}
	var simple_key := _get_simple_ability_key(ability)
	if simple_key == "":
		return {"selected": false, "message": "ABILITY_NOT_SIMPLE"}
	if int(player.get("level", 1)) < int(ability.get("unlock_level", 1)) or not _class_requirement_is_satisfied(player, ability):
		return {"selected": false, "message": "ABILITY_LOCKED"}
	var selected_simple_abilities := player.get("selected_simple_abilities", {}) as Dictionary
	if selected_simple_abilities.has(simple_key) and String(selected_simple_abilities[simple_key]) != ability_id:
		return {"selected": false, "message": "SIMPLE_ABILITY_ALREADY_SELECTED"}
	selected_simple_abilities[simple_key] = ability_id
	player["selected_simple_abilities"] = selected_simple_abilities
	return {"selected": true, "ability_id": ability_id, "simple_key": simple_key}

static func get_player_ability(ability_id: String) -> Dictionary:
	for ability: Dictionary in load_player_abilities():
		if String(ability.get("id", "")) == ability_id:
			return ability.duplicate(true)
	return {}

## Replaces each saved player attack with the current definition from the ability data (matched
## by id), so balance changes to attacks reach existing saves. Unknown ids are kept as saved.
static func refresh_player_attacks(player: Dictionary) -> void:
	var refreshed: Array = []
	for attack_variant: Variant in player.get("attacks", []):
		if not attack_variant is Dictionary:
			continue
		var attack := attack_variant as Dictionary
		var current := get_player_ability(String(attack.get("id", "")))
		refreshed.append(current if not current.is_empty() else attack)
	if refreshed.is_empty():
		var basic := get_player_ability("basic_attack")
		refreshed.append(basic if not basic.is_empty() else DEFAULT_PLAYER_ATTACK.duplicate(true))
	player["attacks"] = refreshed

static func get_player_class(class_id: String) -> Dictionary:
	for player_class: Dictionary in load_player_classes():
		if String(player_class.get("id", "")) == class_id:
			return player_class.duplicate(true)
	return {}

static func select_player_class(player: Dictionary, class_id: String) -> Dictionary:
	if int(player.get("level", 1)) < 10:
		return {"selected": false, "message": "CLASS_LOCKED"}
	if String(player.get("selected_class", "")) != "":
		return {"selected": false, "message": "CLASS_ALREADY_SELECTED"}
	var player_class := get_player_class(class_id)
	if player_class.is_empty():
		return {"selected": false, "message": "CLASS_NOT_FOUND"}
	player["selected_class"] = class_id
	return {"selected": true, "class_id": class_id}

static func get_stat_growth_for_player(player: Dictionary, stat_name: String) -> int:
	var player_class := get_player_class(String(player.get("selected_class", "")))
	if player_class.has("progression") and player_class["progression"] is Dictionary:
		var progression := player_class["progression"] as Dictionary
		if progression.has("stat_growth") and progression["stat_growth"] is Dictionary:
			var stat_growth := progression["stat_growth"] as Dictionary
			if stat_growth.has(stat_name):
				return int(stat_growth[stat_name])
	return int(STAT_GROWTH.get(stat_name, 0))

static func apply_reputation_progression(player: Dictionary) -> Dictionary:
	var gained_levels: int = 0
	var reputation_level: int = int(player.get("reputation_level", 1))
	var threshold: int = int(player.get("reputation_next_level", player.get("reputation", get_reputation_threshold(reputation_level))))
	while int(player.get("current_reputation", 0)) >= threshold:
		reputation_level += 1
		gained_levels += 1
		threshold = get_reputation_threshold(reputation_level)
	player["reputation_level"] = reputation_level
	player["reputation"] = threshold
	player["reputation_next_level"] = threshold
	return {"gained_levels": gained_levels, "reputation_level": reputation_level, "threshold": threshold}

static func consume_movement_energy(player: Dictionary) -> void:
	_consume_energy(player, ENERGY_MOVE_COST)

static func retreat_from_entrance(player: Dictionary) -> Dictionary:
	_consume_energy(player, ENERGY_RETREAT_COST)
	restore_status_after_alive_exit(player)
	return {"retreated": true, "message_key": "EXPLORE_RETREAT_SUCCESS"}

static func attempt_flee(player: Dictionary, location: Dictionary, flee_roll: float = -1.0, monster_attack_roll: float = -1.0, player_dodge_roll: float = -1.0, monster_attack_index: int = -1) -> Dictionary:
	var result := {
		"fled": false,
		"failed": false,
		"player_damaged": false,
		"player_defeated": false,
		"counterattack_hit": false,
		"counterattack_miss": false,
		"counterattack_critical": false,
		"counterattack_dodged": false,
		"flee_roll": 0,
		"monster_attack_roll": 0,
		"player_dodge_roll": 0,
		"monster_attack_name": "",
		"monster_attack_effects": [],
		# Life the monster's counterattack took from the player (0 when it did not hit).
		"counterattack_damage": 0,
		"message_key": "ENCOUNTER_FLEE_SUCCESS",
	}
	_consume_energy(player, ENERGY_MOVE_COST)
	result["player_defeated"] = _is_depleted(player)
	if location.is_empty() or not location.has("content"):
		result["fled"] = true
		return result

	var monster := location["content"] as Dictionary
	_ensure_monster_runtime_stats(monster)
	var roll: int = _roll_twenty(flee_roll)
	result["flee_roll"] = roll
	var flee_value: int = roll + _get_speed(player) - _get_speed(monster)
	if flee_value > 0:
		result["fled"] = true
		location["content"] = monster
		return result

	result["failed"] = true
	result["message_key"] = "ENCOUNTER_FLEE_FAILED"
	var monster_attack := _get_monster_attack(monster, {"name": "Claw", "damage": 1, "mana_cost": 0, "effects": []}, monster_attack_index)
	_consume_mana(monster, int(monster_attack.get("mana_cost", 0)))
	result["monster_attack_name"] = String(monster_attack.get("name", ""))
	result["monster_attack_effects"] = _get_effect_ids(monster_attack)
	var counter := resolve_attack(monster, player, monster_attack, monster_attack_roll, player_dodge_roll)
	result["monster_attack_roll"] = int(counter["attack_roll"])
	result["player_dodge_roll"] = int(counter["dodge_roll"])
	result["counterattack_critical"] = bool(counter["critical"])
	result["counterattack_dodged"] = bool(counter["dodged"])
	result["counterattack_hit"] = bool(counter["hit"])
	result["counterattack_miss"] = bool(counter["miss"])
	if bool(counter["hit"]):
		result["player_damaged"] = true
		result["counterattack_damage"] = int(counter["damage"])
		_damage_actor(player, int(counter["damage"]))
	else:
		result["monster_attack_effects"] = []
	location["content"] = monster
	result["player_defeated"] = _is_depleted(player)
	return result

static func attack_monster(player: Dictionary, location: Dictionary, attack_roll: float = -1.0, dodge_roll: float = -1.0, monster_attack_roll: float = -1.0, player_dodge_roll: float = -1.0, monster_attack_index: int = -1) -> Dictionary:
	var result := {
		"hit": false,
		"miss": false,
		"critical": false,
		"dodged": false,
		"counterattack_hit": false,
		"counterattack_miss": false,
		"counterattack_critical": false,
		"counterattack_dodged": false,
		"monster_defeated": false,
		"player_damaged": false,
		"player_defeated": false,
		"experience_gained": 0,
		"player_attack_roll": 0,
		"monster_dodge_roll": 0,
		"monster_attack_roll": 0,
		"player_dodge_roll": 0,
		"monster_attack_name": "",
		"monster_attack_effects": [],
		"insufficient_resources": false,
		# Life the player's attack took from the monster, and the counterattack from the player
		# (0 when that attack did not hit). Reported for the fight feedback; rules are unchanged.
		"player_attack_damage": 0,
		"counterattack_damage": 0,
		"message_key": "COMBAT_MISS",
	}
	if location.is_empty() or not location.has("content"):
		return result

	var monster := location["content"] as Dictionary
	_ensure_monster_runtime_stats(monster)
	var attack := _get_first_attack(player, DEFAULT_PLAYER_ATTACK)
	var energy_cost := int(attack.get("energy_cost", ENERGY_ATTACK_COST))
	var mana_cost := int(attack.get("mana_cost", 0))
	if int(player.get("current_energy", 0)) < energy_cost or int(player.get("current_mana", 0)) < mana_cost:
		result["insufficient_resources"] = true
		result["message_key"] = "COMBAT_INSUFFICIENT_RESOURCES"
		return result
	_consume_energy(player, energy_cost)
	_consume_mana(player, mana_cost)

	var player_attack := resolve_attack(player, monster, attack, attack_roll, dodge_roll)
	result["player_attack_roll"] = int(player_attack["attack_roll"])
	result["monster_dodge_roll"] = int(player_attack["dodge_roll"])
	result["critical"] = bool(player_attack["critical"])
	result["dodged"] = bool(player_attack["dodged"])
	result["hit"] = bool(player_attack["hit"])
	result["miss"] = bool(player_attack["miss"])

	if bool(player_attack["hit"]):
		result["player_attack_damage"] = int(player_attack["damage"])
		_damage_actor(monster, int(player_attack["damage"]))
		result["message_key"] = "COMBAT_CRITICAL_HIT" if bool(player_attack["critical"]) else "COMBAT_HIT"
	elif bool(player_attack["dodged"]):
		result["message_key"] = "COMBAT_DODGED"
	else:
		result["message_key"] = "COMBAT_MISS"

	if int(monster.get("current_life", monster.get("life", 0))) <= 0:
		monster["current_life"] = 0
		monster["life"] = 0
		location["visited"] = true
		var experience := int(monster.get("experience", 0))
		_add_experience(player, experience)
		result["monster_defeated"] = true
		result["experience_gained"] = experience
		result["message_key"] = "COMBAT_EXPERIENCE_GAINED"
	else:
		var monster_attack := _get_monster_attack(monster, {"name": "Claw", "damage": 1, "mana_cost": 0, "effects": []}, monster_attack_index)
		_consume_mana(monster, int(monster_attack.get("mana_cost", 0)))
		result["monster_attack_name"] = String(monster_attack.get("name", ""))
		result["monster_attack_effects"] = _get_effect_ids(monster_attack)
		var counter := resolve_attack(monster, player, monster_attack, monster_attack_roll, player_dodge_roll)
		result["monster_attack_roll"] = int(counter["attack_roll"])
		result["player_dodge_roll"] = int(counter["dodge_roll"])
		result["counterattack_critical"] = bool(counter["critical"])
		result["counterattack_dodged"] = bool(counter["dodged"])
		result["counterattack_hit"] = bool(counter["hit"])
		result["counterattack_miss"] = bool(counter["miss"])
		if bool(counter["hit"]):
			result["player_damaged"] = true
			result["message_key"] = "COMBAT_COUNTERATTACK_HIT"
			result["counterattack_damage"] = int(counter["damage"])
			_damage_actor(player, int(counter["damage"]))
		else:
			result["monster_attack_effects"] = []

	location["content"] = monster
	result["player_defeated"] = int(player.get("current_life", 0)) <= 0
	return result

static func resolve_attack(attacker: Dictionary, defender: Dictionary, attack: Dictionary, attack_roll: float = -1.0, dodge_roll: float = -1.0) -> Dictionary:
	var roll := _roll_twenty(attack_roll)
	var required_attack_roll := clampi(
		ATTACK_BASE_DIFFICULTY + _get_effective_attribute(_get_armor(defender)) - _get_effective_attribute(_get_strength(attacker)),
		MIN_REQUIRED_ATTACK_ROLL,
		MAX_REQUIRED_ATTACK_ROLL
	)
	var resolved := roll - required_attack_roll + 1
	var critical_threshold := clampi(int(attack.get("critical_threshold", 20)), MIN_REQUIRED_ATTACK_ROLL, 20)
	var critical := roll >= critical_threshold
	var result := {
		"attack_roll": roll,
		"dodge_roll": 0,
		"resolved_value": resolved,
		"hit": false,
		"miss": false,
		"critical": critical,
		"dodged": false,
		"damage": get_attack_damage(attack, critical, _get_strength(attacker)),
	}
	if critical:
		result["hit"] = true
		return result
	if resolved <= 0.0:
		result["miss"] = true
		return result

	var defender_roll := _roll_twenty(dodge_roll)
	result["dodge_roll"] = defender_roll
	var required_dodge_roll := clampi(
		DODGE_BASE_DIFFICULTY + _get_effective_attribute(_get_speed(attacker)) - _get_effective_attribute(_get_speed(defender)),
		MIN_REQUIRED_DODGE_ROLL,
		MAX_REQUIRED_DODGE_ROLL
	)
	if defender_roll >= required_dodge_roll:
		result["dodged"] = true
		return result

	result["hit"] = true
	return result

## Strength above the starting value adds damage: +1 for every 2 points above 3.
static func get_strength_damage_bonus(strength: int) -> int:
	return maxi(0, floori(float(strength - STRENGTH_DAMAGE_BASELINE) / 2.0))

static func get_attack_damage(attack: Dictionary, critical: bool = false, strength: int = STRENGTH_DAMAGE_BASELINE) -> int:
	var base_damage := int(attack.get("damage", 0)) + get_strength_damage_bonus(strength)
	if not critical:
		return base_damage
	var critical_damage_percent := int(attack.get("critical_damage_percent", 100))
	var multiplier := 1.0 + float(critical_damage_percent) / 100.0
	return floori(float(base_damage) * multiplier)

static func rest(player: Dictionary, energy_percent: int = -1, life_percent: int = -1) -> Dictionary:
	if int(player.get("current_mana", 0)) < REST_MANA_COST:
		return {"rested": false, "message_key": "COMBAT_INSUFFICIENT_MANA"}
	var energy_restore := energy_percent if energy_percent >= 0 else randi_range(REST_ENERGY_PERCENT_MIN, REST_ENERGY_PERCENT_MAX)
	var life_restore := life_percent if life_percent >= 0 else randi_range(REST_LIFE_PERCENT_MIN, REST_LIFE_PERCENT_MAX)
	var energy_percent_applied := clampi(energy_restore, REST_ENERGY_PERCENT_MIN, REST_ENERGY_PERCENT_MAX)
	var life_percent_applied := clampi(life_restore, REST_LIFE_PERCENT_MIN, REST_LIFE_PERCENT_MAX)
	player["current_mana"] = int(player.get("current_mana", 0)) - REST_MANA_COST
	_restore_energy(player, energy_percent_applied)
	_restore_life(player, life_percent_applied)
	return {
		"rested": true,
		"energy_percent": energy_percent_applied,
		"life_percent": life_percent_applied,
		"message_key": "COMBAT_REST",
	}

static func rest_with_mana(player: Dictionary) -> Dictionary:
	return rest(player)

static func apply_sanctuary(player: Dictionary, location: Dictionary, life_percent: int = -1, energy_percent: int = -1, mana_percent: int = -1) -> Dictionary:
	var life_restore := life_percent if life_percent >= 0 else randi_range(SANCTUARY_PERCENT_MIN, SANCTUARY_PERCENT_MAX)
	var energy_restore := energy_percent if energy_percent >= 0 else randi_range(SANCTUARY_PERCENT_MIN, SANCTUARY_PERCENT_MAX)
	var mana_restore := mana_percent if mana_percent >= 0 else randi_range(SANCTUARY_PERCENT_MIN, SANCTUARY_PERCENT_MAX)
	if bool(location.get("visited", false)):
		# Each sanctuary heals once per run; re-entering a used one does nothing.
		return {"sanctuary": false, "message_key": "COMBAT_SANCTUARY_USED"}
	_restore_life(player, clampi(life_restore, SANCTUARY_PERCENT_MIN, SANCTUARY_PERCENT_MAX))
	_restore_energy(player, clampi(energy_restore, SANCTUARY_PERCENT_MIN, SANCTUARY_PERCENT_MAX))
	_restore_mana(player, clampi(mana_restore, SANCTUARY_PERCENT_MIN, SANCTUARY_PERCENT_MAX))
	location["visited"] = true
	return {
		"sanctuary": true,
		"life_percent": clampi(life_restore, SANCTUARY_PERCENT_MIN, SANCTUARY_PERCENT_MAX),
		"energy_percent": clampi(energy_restore, SANCTUARY_PERCENT_MIN, SANCTUARY_PERCENT_MAX),
		"mana_percent": clampi(mana_restore, SANCTUARY_PERCENT_MIN, SANCTUARY_PERCENT_MAX),
		"message_key": "COMBAT_SANCTUARY",
	}

static func resolve_quest(player: Dictionary, location: Dictionary, quest_roll: float = -1.0) -> Dictionary:
	_consume_energy(player, ENERGY_QUEST_COST)
	location["visited"] = true
	var roll := _roll_twenty(quest_roll)
	if roll >= QUEST_SUCCESS_ROLL:
		_add_experience(player, QUEST_REWARD_EXPERIENCE)
		return {
			"success": true,
			"experience_gained": QUEST_REWARD_EXPERIENCE,
			"message_key": "COMBAT_QUEST_SUCCESS",
		}

	_lose_life(player, QUEST_FAILURE_DAMAGE)
	return {
		"success": false,
		"player_damaged": true,
		"message_key": "COMBAT_QUEST_TRAP",
	}

static func restore_status_after_alive_exit(player: Dictionary) -> void:
	player["current_life"] = _get_effective_max_life(player)
	player["current_energy"] = int(player.get("energy", 0))
	player["current_mana"] = int(player.get("mana", 0))
	player["current_armor"] = int(player.get("armor", 0))
	player["current_strength"] = int(player.get("strength", 0))
	player["current_speed"] = int(player.get("speed", 0))
	refresh_level_up_state(player)
	apply_reputation_progression(player)

static func restore_status(player: Dictionary) -> void:
	restore_status_after_alive_exit(player)
	discard_dungeon_experience(player)

static func apply_death_sequel(player: Dictionary) -> Dictionary:
	discard_dungeon_experience(player)
	var current_max_life: int = _get_effective_max_life(player)
	var sequel_amount: int = maxi(1, ceili(float(current_max_life) * 0.10))
	var reduced_life: int = current_max_life - sequel_amount
	player["life_sequel_active"] = true
	player["life_sequel_penalty"] = int(player.get("life_sequel_penalty", 0)) + sequel_amount
	if reduced_life <= 0:
		player["current_life"] = 0
		player["save_deleted"] = true
		return {"save_deleted": true, "message_key": "COMBAT_SAVE_DELETED"}
	player["current_life"] = reduced_life
	player["current_energy"] = int(player.get("energy", 0))
	player["current_mana"] = int(player.get("mana", 0))
	return {"save_deleted": false, "sequel_amount": sequel_amount, "message_key": "COMBAT_DEATH_SEQUEL"}

static func _get_effective_max_life(player: Dictionary) -> int:
	return maxi(0, int(player.get("life", 0)) - int(player.get("life_sequel_penalty", 0)))

static func _roll_twenty(value: float) -> int:
	if value >= 0.0:
		return clampi(roundi(value), 1, 20)
	return randi_range(1, 20)

static func _ensure_monster_runtime_stats(monster: Dictionary) -> void:
	if not monster.has("max_life"):
		monster["max_life"] = int(monster.get("life", 1))
	if not monster.has("current_life"):
		monster["current_life"] = int(monster.get("life", monster.get("max_life", 1)))
	if not monster.has("life"):
		monster["life"] = int(monster.get("current_life", monster.get("max_life", 1)))
	if not monster.has("max_mana"):
		monster["max_mana"] = int(monster.get("mana", 0))
	if not monster.has("current_mana"):
		monster["current_mana"] = int(monster.get("mana", monster.get("max_mana", 0)))
	if not monster.has("strength"):
		monster["strength"] = int(monster.get("damage", 1))
	if not monster.has("speed"):
		monster["speed"] = 3
	if not monster.has("level"):
		monster["level"] = 1
	if not monster.has("attacks"):
		monster["attacks"] = [{"name": "Strike", "damage": int(monster.get("damage", 1)), "critical_threshold": 20, "critical_damage_percent": 100, "mana_cost": 0, "effects": []}]

static func _damage_actor(actor: Dictionary, amount: int) -> void:
	actor["current_life"] = int(actor.get("current_life", actor.get("life", 0))) - amount
	if actor.has("max_life"):
		actor["life"] = int(actor["current_life"])

static func _consume_energy(player: Dictionary, amount: int) -> void:
	player["current_energy"] = maxi(0, int(player.get("current_energy", 0)) - amount)

static func _consume_mana(actor: Dictionary, amount: int) -> void:
	actor["current_mana"] = maxi(0, int(actor.get("current_mana", 0)) - amount)

static func _restore_energy(player: Dictionary, percent: int) -> void:
	var maximum := int(player.get("energy", 0))
	var restored := int(player.get("current_energy", 0)) + roundi(float(maximum * percent) / 100.0)
	player["current_energy"] = mini(restored, maximum)

static func _restore_life(player: Dictionary, percent: int) -> void:
	var maximum := _get_effective_max_life(player)
	var restored := int(player.get("current_life", 0)) + roundi(float(maximum * percent) / 100.0)
	player["current_life"] = mini(restored, maximum)

static func _restore_mana(player: Dictionary, percent: int) -> void:
	var maximum := int(player.get("mana", 0))
	var restored := int(player.get("current_mana", 0)) + roundi(float(maximum * percent) / 100.0)
	player["current_mana"] = mini(restored, maximum)

static func _lose_life(player: Dictionary, amount: int) -> void:
	player["current_life"] = int(player.get("current_life", 0)) - amount

static func _add_experience(player: Dictionary, amount: int) -> void:
	if bool(player.get("in_dungeon", false)):
		player["dungeon_experience"] = int(player.get("dungeon_experience", 0)) + amount
		return
	player["current_experience"] = int(player.get("current_experience", 0)) + amount

static func begin_dungeon_experience(player: Dictionary) -> void:
	player["in_dungeon"] = true
	player["dungeon_experience"] = 0

static func commit_dungeon_experience(player: Dictionary, completion_bonus: int = 0) -> int:
	var gained := int(player.get("dungeon_experience", 0)) + maxi(0, completion_bonus)
	player["current_experience"] = int(player.get("current_experience", 0)) + gained
	player["dungeon_experience"] = 0
	player["in_dungeon"] = false
	refresh_level_up_state(player)
	return gained

static func discard_dungeon_experience(player: Dictionary) -> void:
	player["dungeon_experience"] = 0
	player["in_dungeon"] = false

## True when the player can pay the energy and mana cost of their current attack.
static func can_afford_attack(player: Dictionary) -> bool:
	var attack := _get_first_attack(player, DEFAULT_PLAYER_ATTACK)
	return int(player.get("current_energy", 0)) >= int(attack.get("energy_cost", ENERGY_ATTACK_COST)) \
		and int(player.get("current_mana", 0)) >= int(attack.get("mana_cost", 0))

static func _get_first_attack(actor: Dictionary, fallback: Dictionary) -> Dictionary:
	var attacks: Array = actor.get("attacks", [])
	if attacks.is_empty():
		return fallback.duplicate(true)
	return (attacks[0] as Dictionary).duplicate(true)

static func _get_monster_attack(monster: Dictionary, fallback: Dictionary, preferred_index: int = -1) -> Dictionary:
	var attacks: Array = monster.get("attacks", [])
	if attacks.is_empty():
		return fallback.duplicate(true)

	var affordable_attacks: Array[Dictionary] = []
	var current_mana: int = int(monster.get("current_mana", monster.get("mana", 0)))
	for attack: Variant in attacks:
		if attack is Dictionary and int((attack as Dictionary).get("mana_cost", 0)) <= current_mana:
			affordable_attacks.append((attack as Dictionary).duplicate(true))

	if affordable_attacks.is_empty():
		return fallback.duplicate(true)
	if preferred_index >= 0 and preferred_index < affordable_attacks.size():
		return affordable_attacks[preferred_index].duplicate(true)
	return affordable_attacks[randi_range(0, affordable_attacks.size() - 1)].duplicate(true)

static func _get_effect_ids(attack: Dictionary) -> Array[String]:
	var effect_ids: Array[String] = []
	if attack.has("effects") and attack["effects"] is Array:
		for effect_id: Variant in attack["effects"]:
			effect_ids.append(String(effect_id))
	return effect_ids

static func _load_dictionary_array(path: String, fallback: Array) -> Array[Dictionary]:
	var items: Array[Dictionary] = []
	if FileAccess.file_exists(path):
		var content: String = FileAccess.get_file_as_string(path)
		var parsed: Variant = JSON.parse_string(content)
		if parsed is Array:
			for item: Variant in parsed:
				if item is Dictionary:
					items.append((item as Dictionary).duplicate(true))
	if items.is_empty():
		for fallback_item: Variant in fallback:
			if fallback_item is Dictionary:
				items.append((fallback_item as Dictionary).duplicate(true))
	return items

static func _get_points_per_level(player: Dictionary) -> int:
	var player_class := get_player_class(String(player.get("selected_class", "")))
	if player_class.has("progression") and player_class["progression"] is Dictionary:
		var progression := player_class["progression"] as Dictionary
		return maxi(1, int(progression.get("points_per_level", LEVEL_UP_POINTS)))
	return LEVEL_UP_POINTS

static func _get_class_automatic_increments_for_level(player: Dictionary, level: int) -> Dictionary:
	var increments: Dictionary = {}
	var player_class := get_player_class(String(player.get("selected_class", "")))
	if player_class.is_empty() or not player_class.has("progression") or not player_class["progression"] is Dictionary:
		return increments
	var progression := player_class["progression"] as Dictionary
	var cadence: int = int(progression.get("automatic_increment_every", 0))
	if cadence <= 0 or level % cadence != 0:
		return increments
	if progression.has("automatic_increments") and progression["automatic_increments"] is Dictionary:
		for stat_variant: Variant in (progression["automatic_increments"] as Dictionary).keys():
			var stat_key := String(stat_variant)
			if STAT_GROWTH.has(stat_key):
				increments[stat_key] = int((progression["automatic_increments"] as Dictionary)[stat_key])
	return increments

static func _apply_stat_increments(player: Dictionary, increments: Dictionary, in_dungeon: bool) -> void:
	for stat_variant: Variant in increments.keys():
		var stat_key := String(stat_variant)
		if not STAT_GROWTH.has(stat_key):
			continue
		_apply_stat_increase(player, stat_key, int(STAT_GROWTH[stat_key]) * int(increments[stat_key]), in_dungeon)

static func _apply_stat_increase(player: Dictionary, stat_name: String, increase: int, in_dungeon: bool) -> void:
	player[stat_name] = int(player.get(stat_name, 0)) + increase
	if not in_dungeon:
		player["current_%s" % stat_name] = int(player.get("current_%s" % stat_name, player.get(stat_name, 0))) + increase

static func _clear_life_sequel(player: Dictionary) -> void:
	if bool(player.get("life_sequel_active", false)):
		player["life_sequel_active"] = false
		player["life_sequel_penalty"] = 0

static func _class_requirement_is_satisfied(player: Dictionary, ability: Dictionary) -> bool:
	if not ability.has("class_requirements") or not ability["class_requirements"] is Array:
		return true
	var required_classes := ability["class_requirements"] as Array
	if required_classes.is_empty():
		return true
	var selected_class := String(player.get("selected_class", ""))
	for required_class: Variant in required_classes:
		if String(required_class) == selected_class:
			return true
	return false

static func _get_simple_ability_key(ability: Dictionary) -> String:
	var group := String(ability.get("simple_skill_group", ""))
	if group != "":
		return group
	if bool(ability.get("simple", false)):
		return "level_%s" % str(int(ability.get("unlock_level", 1)))
	return ""

static func _get_armor(actor: Dictionary) -> int:
	return int(actor.get("current_armor", actor.get("armor", 0)))

static func _get_strength(actor: Dictionary) -> int:
	return int(actor.get("current_strength", actor.get("strength", 0)))

static func _get_speed(actor: Dictionary) -> int:
	return int(actor.get("current_speed", actor.get("speed", 0)))

static func _get_effective_attribute(value: int) -> int:
	return floori(float(maxi(0, value)) / ATTRIBUTE_SCALE_DIVISOR)

static func _is_depleted(player: Dictionary) -> bool:
	return int(player.get("current_life", 0)) <= 0 or int(player.get("current_energy", 0)) <= 0
