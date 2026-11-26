class_name DungeonGenerator
extends RefCounted

const LOCATION_MONSTER := "MONSTER"
const LOCATION_BLOCK := "BLOCK"
const LOCATION_QUEST := "QUEST"
const LOCATION_SANCTUARY := "SANCTUARY"
const LOCATION_ENTRANCE := "ENTRANCE"
const LOCATION_EMPTY := "EMPTY"
const MONSTER_TEMPLATES_PATH := "res://data/monsters.json"
const EFFECT_TEMPLATES_PATH := "res://data/effects.json"
## Experience a monster grants: template value x multiplier + monster level x per-level bonus.
const MAX_DIMENSION := 25
const MONSTER_LEVELS_BELOW_PLAYER := 2
const MONSTER_LEVEL_SPREAD_HIGH := 3
const MONSTER_LEVELS_ABOVE_PLAYER_HIGH := 1
## Random stat points a monster receives per level above 1, rounded down over all levels
## (players receive 3 per level). A var so tools/playtest.gd can try alternatives.
static var monster_points_per_level: float = 2.0
const EXPERIENCE_TEMPLATE_MULTIPLIER := 4
const EXPERIENCE_PER_MONSTER_LEVEL := 0
const STAT_GROWTH := {
	"life": 5,
	"mana": 4,
	"armor": 1,
	"speed": 1,
	"strength": 1,
}

const FALLBACK_MONSTER_TEMPLATES := [
	{"name": "Rat", "life": 6, "armor": 4, "mana": 10, "strength": 1, "speed": 5, "experience": 1, "image": "Rat", "attacks": [{"name": "Strike", "damage": 1, "critical_threshold": 20, "critical_damage_percent": 100, "mana_cost": 0, "effects": [], "unlock_level": 1}, {"name": "Bite", "damage": 2, "critical_threshold": 20, "critical_damage_percent": 100, "mana_cost": 0, "effects": [], "unlock_level": 1}]},
]

static func create_dungeon(_dungeon_type: int = 1, rng: RandomNumberGenerator = null, player_level: int = 1) -> Dictionary:
	var random_source := rng if rng != null else RandomNumberGenerator.new()
	if rng == null:
		random_source.randomize()

	var normalized_level := maxi(1, player_level)
	var min_columns := 5
	# From level 10 the map grows with the player (level x level), up to 25 x 25.
	var max_columns := 5 if normalized_level < 10 else mini(MAX_DIMENSION, normalized_level)
	var min_rows := 5
	var max_rows := 7 if normalized_level < 10 else mini(MAX_DIMENSION, normalized_level)
	var dungeon := {
		"_id": null,
		"number_of_columns": random_source.randi_range(min_columns, max_columns),
		"number_of_rows": random_source.randi_range(min_rows, max_rows),
		"locations": [],
		"q_locations": 0,
		"total_monsters": 0,
		"defeated_monsters": 0,
		"completed": false,
	}
	var edge_locations: Array[Dictionary] = []

	for row in range(1, int(dungeon["number_of_rows"]) + 1):
		for column in range(1, int(dungeon["number_of_columns"]) + 1):
			var location := _create_location(column, row)
			dungeon["locations"].append(location)

			if row == 1 or row == int(dungeon["number_of_rows"]) or column == 1 or column == int(dungeon["number_of_columns"]):
				edge_locations.append(location)

	var entrance_location: Dictionary = edge_locations[random_source.randi_range(0, edge_locations.size() - 1)]
	entrance_location["type"] = LOCATION_ENTRANCE
	entrance_location["content"] = {
		"image": "dungeon entrance",
	}
	entrance_location["visited"] = true
	entrance_location["visible"] = true

	var available_locations: Array[Dictionary] = []
	for location: Dictionary in dungeon["locations"]:
		if location["type"] == LOCATION_ENTRANCE:
			continue
		location["type"] = LOCATION_EMPTY
		location["content"] = {}
		available_locations.append(location)
	_shuffle_locations(available_locations, random_source)

	var cursor := 0
	var monster_target := get_monster_count_target(normalized_level, available_locations.size(), random_source)
	var templates := get_monster_templates()
	for _index in range(monster_target):
		var location := available_locations[cursor]
		cursor += 1
		var template := templates[random_source.randi_range(0, templates.size() - 1)]
		location["type"] = LOCATION_MONSTER
		location["content"] = _monster_from_template(template, random_source, normalized_level)
		dungeon["total_monsters"] = int(dungeon["total_monsters"]) + 1

	var quest_target := mini(3, 1 + floori(float(normalized_level) / 5.0))
	for _index in range(mini(quest_target, available_locations.size() - cursor)):
		var location := available_locations[cursor]
		cursor += 1
		location["type"] = LOCATION_QUEST
		location["content"] = _create_quest_option(random_source)

	var sanctuary_target := 1 if available_locations.size() - cursor > 0 else 0
	for _index in range(sanctuary_target):
		var location := available_locations[cursor]
		cursor += 1
		location["type"] = LOCATION_SANCTUARY
		location["content"] = {"image": "sanctuary"}

	var block_target := mini(roundi(float(available_locations.size()) * 0.08), available_locations.size() - cursor)
	for _index in range(block_target):
		var location := available_locations[cursor]
		cursor += 1
		location["type"] = LOCATION_BLOCK
		location["content"] = {}
	_ensure_objectives_reachable(dungeon)

	dungeon["q_locations"] = dungeon["locations"].size()
	return dungeon

static func get_monster_count_target(player_level: int, available_cells: int, rng: RandomNumberGenerator = null) -> int:
	# One formula for every level, so dungeons stay completable: level 1 has 5-7 monsters,
	# level 10 has 8-10, level 25 has 13-15. Larger maps add exploration, not a wall of monsters.
	var normalized_level := maxi(1, player_level)
	var base_target := 5 + floori(float(normalized_level - 1) / 3.0)
	var difficulty_variation := rng.randi_range(0, 2) if rng != null else 1
	return mini(available_cells, base_target + difficulty_variation)

static func _shuffle_locations(locations: Array[Dictionary], rng: RandomNumberGenerator) -> void:
	for index in range(locations.size() - 1, 0, -1):
		var swap_index := rng.randi_range(0, index)
		var temporary := locations[index]
		locations[index] = locations[swap_index]
		locations[swap_index] = temporary

static func _ensure_objectives_reachable(dungeon: Dictionary) -> void:
	var entrance := get_entrance(dungeon)
	if entrance.is_empty():
		return
	for location: Dictionary in dungeon["locations"]:
		if location.get("type") not in [LOCATION_MONSTER, LOCATION_QUEST, LOCATION_SANCTUARY]:
			continue
		var column := int(entrance["column"])
		var row := int(entrance["row"])
		while column != int(location["column"]):
			column += 1 if column < int(location["column"]) else -1
			_clear_block_at(dungeon, column, row)
		while row != int(location["row"]):
			row += 1 if row < int(location["row"]) else -1
			_clear_block_at(dungeon, column, row)

static func _clear_block_at(dungeon: Dictionary, column: int, row: int) -> void:
	var location := get_location(dungeon, column, row)
	if not location.is_empty() and location.get("type") == LOCATION_BLOCK:
		location["type"] = LOCATION_EMPTY
		location["content"] = {}

static func get_location(dungeon: Dictionary, column: int, row: int) -> Dictionary:
	for location: Dictionary in dungeon["locations"]:
		if int(location["column"]) == column and int(location["row"]) == row:
			return location
	return {}

static func get_entrance(dungeon: Dictionary) -> Dictionary:
	for location: Dictionary in dungeon["locations"]:
		if location["type"] == LOCATION_ENTRANCE:
			return location
	return {}

static func is_monster_alive(location: Dictionary) -> bool:
	if location.is_empty() or location.get("type") != LOCATION_MONSTER:
		return false
	var content := location.get("content", {}) as Dictionary
	return int(content.get("current_life", content.get("life", 0))) > 0 and not bool(location.get("visited", false))

static func count_total_monsters(dungeon: Dictionary) -> int:
	var total := 0
	for location: Dictionary in dungeon.get("locations", []):
		if location.get("type") == LOCATION_MONSTER:
			total += 1
	return total

static func count_defeated_monsters(dungeon: Dictionary) -> int:
	var total := 0
	for location: Dictionary in dungeon.get("locations", []):
		if location.get("type") != LOCATION_MONSTER:
			continue
		var content := location.get("content", {}) as Dictionary
		if bool(location.get("visited", false)) or int(content.get("current_life", content.get("life", 0))) <= 0:
			total += 1
	return total

static func _create_location(column: int, row: int) -> Dictionary:
	return {
		"_id": null,
		"column": column,
		"row": row,
		"type": null,
		"content": null,
		"visited": false,
		"visible": false,
		"show": false,
		"canVisit": false,
	}

static func _initial_location_options() -> Array[Dictionary]:
	var options: Array[Dictionary] = []
	for monster: Dictionary in get_monster_templates():
		var option: Dictionary = monster.duplicate(true)
		option["kind"] = LOCATION_MONSTER
		options.append(option)
	return options

static func get_monster_templates() -> Array[Dictionary]:
	var templates: Array[Dictionary] = []
	if FileAccess.file_exists(MONSTER_TEMPLATES_PATH):
		var content: String = FileAccess.get_file_as_string(MONSTER_TEMPLATES_PATH)
		var parsed: Variant = JSON.parse_string(content)
		if parsed is Array:
			for item: Variant in parsed:
				if item is Dictionary:
					templates.append((item as Dictionary).duplicate(true))
	if templates.is_empty():
		for fallback: Dictionary in FALLBACK_MONSTER_TEMPLATES:
			templates.append(fallback.duplicate(true))
	return templates

static func _create_quest_option(rng: RandomNumberGenerator) -> Dictionary:
	var actions := ["Challenge", "Open"]
	var alternative_actions := ["Escape", null]
	return {
		"kind": LOCATION_QUEST,
		"action": actions[rng.randi_range(0, actions.size() - 1)],
		"alternative_action": alternative_actions[rng.randi_range(0, alternative_actions.size() - 1)],
	}

static func get_monster_level_range(player_level: int) -> Vector2i:
	var normalized_player_level: int = maxi(1, player_level)
	# Narrow ranges keep encounters close to the player's strength (playtest-tuned).
	if normalized_player_level < 10:
		return Vector2i(maxi(1, normalized_player_level - MONSTER_LEVELS_BELOW_PLAYER), normalized_player_level)
	return Vector2i(maxi(1, normalized_player_level - MONSTER_LEVEL_SPREAD_HIGH), normalized_player_level + MONSTER_LEVELS_ABOVE_PLAYER_HIGH)

static func create_monster_from_template_for_level(template: Dictionary, rng: RandomNumberGenerator, player_level: int) -> Dictionary:
	return _monster_from_template(template, rng, player_level)

static func _monster_from_template(template: Dictionary, rng: RandomNumberGenerator, player_level: int = 1) -> Dictionary:
	var monster_level: int = int(template.get("level", 0))
	if monster_level <= 0:
		var level_range: Vector2i = get_monster_level_range(player_level)
		monster_level = rng.randi_range(level_range.x, level_range.y)
	var monster := {
		"name": String(template["name"]),
		"level": monster_level,
		"life": int(template["life"]),
		"max_life": int(template["life"]),
		"current_life": int(template["life"]),
		"armor": int(template["armor"]),
		"mana": int(template["mana"]),
		"max_mana": int(template["mana"]),
		"current_mana": int(template["mana"]),
		"strength": int(template.get("strength", template.get("damage", 1))),
		"current_strength": int(template.get("strength", template.get("damage", 1))),
		"speed": int(template.get("speed", 3)),
		"current_speed": int(template.get("speed", 3)),
		"experience": int(template["experience"]) * EXPERIENCE_TEMPLATE_MULTIPLIER + monster_level * EXPERIENCE_PER_MONSTER_LEVEL,
		"image": String(template["image"]),
		"attacks": _create_monster_attacks(template, monster_level),
	}
	_apply_monster_level_scaling(monster, rng)
	return monster

static func _create_monster_attacks(template: Dictionary, monster_level: int = 1) -> Array[Dictionary]:
	if template.has("attacks") and template["attacks"] is Array and not (template["attacks"] as Array).is_empty():
		var attacks: Array[Dictionary] = []
		for attack: Variant in template["attacks"]:
			if attack is Dictionary:
				var normalized_attack: Dictionary = _normalize_monster_attack(attack as Dictionary)
				if int(normalized_attack.get("unlock_level", 1)) <= monster_level:
					attacks.append(normalized_attack)
		if not attacks.is_empty():
			var limited_attacks: Array[Dictionary] = []
			for index: int in range(mini(attacks.size(), 5)):
				limited_attacks.append(attacks[index])
			return limited_attacks
	var damage: int = int(template.get("strength", template.get("damage", 1)))
	return [
		{"name": "Strike", "damage": damage, "critical_threshold": 20, "critical_damage_percent": 100, "mana_cost": 0, "effects": [], "unlock_level": 1},
		{"name": "Bite", "damage": maxi(1, damage + 1), "critical_threshold": 20, "critical_damage_percent": 100, "mana_cost": 0, "effects": [], "unlock_level": 1},
	]

static func _normalize_monster_attack(attack: Dictionary) -> Dictionary:
	var effects: Array[String] = []
	if attack.has("effects") and attack["effects"] is Array:
		for effect_id: Variant in attack["effects"]:
			effects.append(String(effect_id))
	return {
		"name": String(attack.get("name", "Attack")),
		"damage": int(attack.get("damage", 1)),
		"critical_threshold": clampi(int(attack.get("critical_threshold", 20)), 1, 20),
		"critical_damage_percent": int(attack.get("critical_damage_percent", 100)),
		"mana_cost": int(attack.get("mana_cost", attack.get("energy_cost", 0))),
		"effects": effects,
		"unlock_level": int(attack.get("unlock_level", 1)),
	}

static func _apply_monster_level_scaling(monster: Dictionary, rng: RandomNumberGenerator) -> void:
	var points_to_assign: int = floori(maxi(0, int(monster.get("level", 1)) - 1) * monster_points_per_level)
	var stat_keys: Array[String] = ["life", "mana", "armor", "speed", "strength"]
	for _index: int in range(points_to_assign):
		var stat_key: String = stat_keys[rng.randi_range(0, stat_keys.size() - 1)]
		var increase: int = int(STAT_GROWTH[stat_key])
		monster[stat_key] = int(monster.get(stat_key, 0)) + increase
		if stat_key == "life":
			monster["max_life"] = int(monster.get("max_life", 0)) + increase
			monster["current_life"] = int(monster.get("life", 0))
		elif stat_key == "mana":
			monster["max_mana"] = int(monster.get("max_mana", 0)) + increase
			monster["current_mana"] = int(monster.get("mana", 0))
		else:
			monster["current_%s" % stat_key] = int(monster.get(stat_key, 0))
