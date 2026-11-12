extends SceneTree

const DungeonGenerator := preload("res://scripts/dungeon_generator.gd")

func _init() -> void:
	_verify_monster_template_json()
	_verify_monster_leveling_rules()
	_verify_large_dungeon_size_variance()
	var rng := RandomNumberGenerator.new()
	rng.seed = 42
	var dungeon: Dictionary = DungeonGenerator.create_dungeon(1, rng)
	var columns: int = int(dungeon["number_of_columns"])
	var rows: int = int(dungeon["number_of_rows"])
	var locations := dungeon["locations"] as Array
	var entrances := 0
	var monsters := 0
	var empty_locations := 0

	if columns != 5 or rows < 5 or rows > 7:
		push_error("Pre-level-10 dungeon dimensions should fit within 5 by 7.")
		quit(1)
		return

	var large_rng := RandomNumberGenerator.new()
	large_rng.seed = 42
	var large_dungeon: Dictionary = DungeonGenerator.create_dungeon(1, large_rng, 10)
	if int(large_dungeon["number_of_columns"]) < 5 or int(large_dungeon["number_of_columns"]) > 25 or int(large_dungeon["number_of_rows"]) < 5 or int(large_dungeon["number_of_rows"]) > 25:
		push_error("Level 10 dungeon dimensions should allow up to 25 by 25.")
		quit(1)
		return

	if int(dungeon["q_locations"]) != columns * rows or locations.size() != columns * rows:
		push_error("Dungeon q_locations does not match generated grid size.")
		quit(1)
		return

	for location: Dictionary in locations:
		if location["type"] == DungeonGenerator.LOCATION_ENTRANCE:
			entrances += 1
			var column: int = int(location["column"])
			var row: int = int(location["row"])
			if not (column == 1 or column == columns or row == 1 or row == rows):
				push_error("Entrance is not on an edge location.")
				quit(1)
				return
		if location["type"] == DungeonGenerator.LOCATION_MONSTER:
			monsters += 1
			var monster := location["content"] as Dictionary
			if not monster.has("level") or not monster.has("speed") or not monster.has("strength") or not monster.has("attacks"):
				push_error("Generated monsters should include new rule stats and attacks.")
				quit(1)
				return
			if int(monster["level"]) != 1:
				push_error("Player level 1 dungeon should generate only level 1 monsters.")
				quit(1)
				return
		elif location["type"] == DungeonGenerator.LOCATION_EMPTY:
			empty_locations += 1

	if entrances != 1:
		push_error("Dungeon must contain exactly one entrance.")
		quit(1)
		return
	if monsters < 5 or monsters > 7 or empty_locations <= 0:
		push_error("Level 1 dungeons should contain 5-7 monsters and retain empty exploration cells.")
		quit(1)
		return

	quit(0)

func _verify_large_dungeon_size_variance() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 2510
	var minimum_dimension := 25
	var maximum_dimension := 5
	for _sample in range(200):
		var dungeon := DungeonGenerator.create_dungeon(1, rng, 10)
		minimum_dimension = mini(minimum_dimension, mini(int(dungeon["number_of_columns"]), int(dungeon["number_of_rows"])))
		maximum_dimension = maxi(maximum_dimension, maxi(int(dungeon["number_of_columns"]), int(dungeon["number_of_rows"])))
		if int(dungeon["total_monsters"]) * 4 < int(dungeon["q_locations"]):
			push_error("Level 10 dungeons should place monsters in at least 25 percent of all cells.")
			quit(1)
			return
	if minimum_dimension > 7 or maximum_dimension < 23:
		push_error("Level 10 dungeons should sample both small and near-maximum dimensions from the 5-25 range.")
		quit(1)

func _verify_monster_template_json() -> void:
	if not FileAccess.file_exists(DungeonGenerator.MONSTER_TEMPLATES_PATH):
		push_error("Monster templates JSON should exist.")
		quit(1)
		return
	if not FileAccess.file_exists(DungeonGenerator.EFFECT_TEMPLATES_PATH):
		push_error("Effect templates JSON should exist.")
		quit(1)
		return
	var templates: Array[Dictionary] = DungeonGenerator.get_monster_templates()
	if templates.size() < 10:
		push_error("Monster templates should be loaded from JSON.")
		quit(1)
		return
	for template: Dictionary in templates:
		for required_key in ["name", "life", "armor", "mana", "strength", "speed", "experience", "image", "attacks"]:
			if not template.has(required_key):
				push_error("Monster template is missing required key: %s" % required_key)
				quit(1)
				return
		var attacks: Array = template["attacks"] as Array
		if attacks.size() < 2 or attacks.size() > 5:
			push_error("Monster template should define between 2 and 5 attacks.")
			quit(1)
			return
		for attack: Variant in attacks:
			if not attack is Dictionary:
				push_error("Monster attacks should be dictionaries.")
				quit(1)
				return
			var attack_data: Dictionary = attack as Dictionary
			if not attack_data.has("mana_cost") or not attack_data.has("effects") or not attack_data.has("unlock_level") or not attack_data.has("critical_threshold") or not attack_data.has("critical_damage_percent"):
				push_error("Monster attacks should define mana cost, unlock level, critical data, and effect ids.")
				quit(1)
				return
			if not attack_data["effects"] is Array:
				push_error("Monster attack effects should be an array.")
				quit(1)
				return
		_verify_effect_template_json()

func _verify_monster_leveling_rules() -> void:
	var low_range: Vector2i = DungeonGenerator.get_monster_level_range(4)
	if low_range.x != 1 or low_range.y != 4:
		push_error("Pre-level-10 monster range should stay within player level and no more than 5 lower.")
		quit(1)
		return
	var high_range: Vector2i = DungeonGenerator.get_monster_level_range(10)
	if high_range.x != 5 or high_range.y != 15:
		push_error("Level-10 monster range should allow player level plus or minus 5.")
		quit(1)
		return

	var rng := RandomNumberGenerator.new()
	rng.seed = 7
	var template := {
		"name": "Test Monster",
		"level": 3,
		"life": 10,
		"armor": 1,
		"mana": 8,
		"strength": 2,
		"speed": 3,
		"experience": 1,
		"image": "Test",
		"attacks": [
			{"name": "Scratch", "damage": 1, "critical_threshold": 20, "critical_damage_percent": 100, "mana_cost": 0, "effects": [], "unlock_level": 1},
			{"name": "Roar", "damage": 2, "critical_threshold": 19, "critical_damage_percent": 10, "mana_cost": 1, "effects": [], "unlock_level": 4},
		],
	}
	var monster: Dictionary = DungeonGenerator.create_monster_from_template_for_level(template, rng, 3)
	if int(monster["level"]) != 3:
		push_error("Generated monster should keep explicit level before scaling.")
		quit(1)
		return
	var assigned_points: int = int((int(monster["life"]) - 10) / 5)
	assigned_points += int((int(monster["mana"]) - 8) / 4)
	assigned_points += int(monster["armor"]) - 1
	assigned_points += int(monster["speed"]) - 3
	assigned_points += int(monster["strength"]) - 2
	if assigned_points != 4:
		push_error("Monster should receive 2 random stat points for every level above 1.")
		quit(1)
		return
	if int(monster["current_life"]) != int(monster["max_life"]) or int(monster["current_mana"]) != int(monster["max_mana"]):
		push_error("Scaled monster current life and mana should match scaled maximums.")
		quit(1)
		return
	var attacks: Array = monster["attacks"] as Array
	var first_attack := attacks[0] as Dictionary
	if attacks.size() != 1 or String(first_attack["name"]) != "Scratch":
		push_error("Monster attack unlock filtering should exclude attacks above monster level.")
		quit(1)
		return
	if int(first_attack.get("critical_threshold", 0)) != 20 or int(first_attack.get("critical_damage_percent", -1)) != 100:
		push_error("Monster attack normalization should preserve critical threshold and damage percent.")
		quit(1)
		return

func _verify_effect_template_json() -> void:
	var content: String = FileAccess.get_file_as_string(DungeonGenerator.EFFECT_TEMPLATES_PATH)
	var parsed: Variant = JSON.parse_string(content)
	if not parsed is Array:
		push_error("Effect templates JSON should contain an array.")
		quit(1)
		return
	for effect: Variant in parsed:
		if not effect is Dictionary:
			push_error("Effect templates should be dictionaries.")
			quit(1)
			return
		var effect_data: Dictionary = effect as Dictionary
		for required_key in ["id", "precision", "duration_turns", "target", "cause", "stat", "operation", "amount"]:
			if not effect_data.has(required_key):
				push_error("Effect template is missing required key: %s" % required_key)
				quit(1)
				return
