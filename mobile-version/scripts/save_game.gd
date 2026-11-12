extends RefCounted

const SAVE_VERSION := 1
const DEFAULT_SAVE_PATH := "user://player_save.json"

static func has_save(path: String = DEFAULT_SAVE_PATH) -> bool:
	return FileAccess.file_exists(path)

static func save_player(player: Dictionary, path: String = DEFAULT_SAVE_PATH) -> bool:
	var temporary_path := "%s.tmp" % path
	var file := FileAccess.open(temporary_path, FileAccess.WRITE)
	if file == null:
		return false
	var payload := {
		"version": SAVE_VERSION,
		"player": player,
	}
	file.store_string(JSON.stringify(payload))
	file.close()

	var absolute_path := ProjectSettings.globalize_path(path)
	var absolute_temporary_path := ProjectSettings.globalize_path(temporary_path)
	if FileAccess.file_exists(path):
		if DirAccess.remove_absolute(absolute_path) != OK:
			DirAccess.remove_absolute(absolute_temporary_path)
			return false
	if DirAccess.rename_absolute(absolute_temporary_path, absolute_path) != OK:
		DirAccess.remove_absolute(absolute_temporary_path)
		return false
	return true

static func load_player(default_player: Dictionary, path: String = DEFAULT_SAVE_PATH) -> Dictionary:
	if not has_save(path):
		return {"success": false, "error": "missing_save"}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {"success": false, "error": "unreadable_save"}
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	file.close()
	if not parsed is Dictionary:
		return {"success": false, "error": "invalid_json"}
	var payload := parsed as Dictionary
	if int(payload.get("version", 0)) != SAVE_VERSION or not payload.get("player") is Dictionary:
		return {"success": false, "error": "unsupported_save"}
	var player := _merge_player(default_player, payload["player"] as Dictionary)
	if bool(player.get("save_deleted", false)):
		return {"success": false, "error": "deleted_save"}
	return {"success": true, "player": player}

static func delete_save(path: String = DEFAULT_SAVE_PATH) -> bool:
	var temporary_path := "%s.tmp" % path
	if FileAccess.file_exists(temporary_path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(temporary_path))
	if not has_save(path):
		return true
	return DirAccess.remove_absolute(ProjectSettings.globalize_path(path)) == OK

static func _merge_player(default_player: Dictionary, saved_player: Dictionary) -> Dictionary:
	var player := default_player.duplicate(true)
	for key_variant: Variant in default_player.keys():
		var key := String(key_variant)
		if not saved_player.has(key):
			continue
		var expected: Variant = default_player[key]
		var saved: Variant = saved_player[key]
		match typeof(expected):
			TYPE_INT:
				if typeof(saved) == TYPE_INT or typeof(saved) == TYPE_FLOAT:
					player[key] = int(saved)
			TYPE_BOOL:
				if typeof(saved) == TYPE_BOOL:
					player[key] = saved
			TYPE_STRING:
				if typeof(saved) == TYPE_STRING:
					player[key] = saved
			TYPE_ARRAY:
				if typeof(saved) == TYPE_ARRAY:
					player[key] = saved.duplicate(true)
			TYPE_DICTIONARY:
				if typeof(saved) == TYPE_DICTIONARY:
					player[key] = saved.duplicate(true)
	_normalize_player(player)
	return player

static func _normalize_player(player: Dictionary) -> void:
	for key in ["life", "energy", "mana", "armor", "strength", "speed", "level", "experience_next_level", "reputation_next_level", "reputation_level"]:
		player[key] = maxi(1, int(player.get(key, 1)))
	for key in ["current_life", "current_energy", "current_mana", "current_armor", "current_strength", "current_speed", "current_experience", "dungeon_experience", "current_reputation", "pending_level_points", "reserved_progression_points", "life_sequel_penalty"]:
		player[key] = maxi(0, int(player.get(key, 0)))
	player["dungeon_experience"] = 0
	player["in_dungeon"] = false
	player["current_life"] = mini(int(player["current_life"]), int(player["life"]))
	player["current_energy"] = mini(int(player["current_energy"]), int(player["energy"]))
	player["current_mana"] = mini(int(player["current_mana"]), int(player["mana"]))
