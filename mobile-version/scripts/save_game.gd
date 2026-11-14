extends RefCounted

## Version 2 adds the optional "run" object (active dungeon). Version 1 saves still load.
const SAVE_VERSION := 2
const SUPPORTED_VERSIONS := [1, 2]
const DEFAULT_SAVE_PATH := "user://player_save.json"

## True when a save file (or a recoverable temporary save) exists, readable or not.
static func has_save(path: String = DEFAULT_SAVE_PATH) -> bool:
	return FileAccess.file_exists(path) or FileAccess.file_exists(_temporary_path(path)) or FileAccess.file_exists(_backup_path(path))

## Writes the save atomically: the new content goes to a temporary file that then replaces the
## main file in one rename, so an interrupted write never leaves the player without a save.
## `run` is the active dungeon run (empty when the player is not in a dungeon).
static func save_player(player: Dictionary, path: String = DEFAULT_SAVE_PATH, run: Dictionary = {}) -> bool:
	var temporary_path := _temporary_path(path)
	var payload := {
		"version": SAVE_VERSION,
		"player": player,
	}
	if not run.is_empty():
		payload["run"] = run
	var file := FileAccess.open(temporary_path, FileAccess.WRITE)
	if file == null:
		return false
	var written := file.store_string(JSON.stringify(payload))
	file.flush()
	var write_error := file.get_error()
	file.close()
	if not written or write_error != OK:
		# Leave the previous save untouched.
		DirAccess.remove_absolute(ProjectSettings.globalize_path(temporary_path))
		return false

	var absolute_path := ProjectSettings.globalize_path(path)
	var absolute_temporary_path := ProjectSettings.globalize_path(temporary_path)
	# rename() replaces the destination atomically on Android/Linux/macOS.
	if DirAccess.rename_absolute(absolute_temporary_path, absolute_path) == OK:
		return true
	# Platforms that refuse to rename over an existing file: move the old save aside (never delete
	# it first), then move the new one in. If anything fails, the old save is put back; if the app
	# dies in between, load_player recovers from the temporary or backup file.
	if not FileAccess.file_exists(temporary_path):
		return false
	var absolute_backup_path := ProjectSettings.globalize_path(_backup_path(path))
	var had_previous := FileAccess.file_exists(path)
	if had_previous:
		DirAccess.remove_absolute(absolute_backup_path)
		if DirAccess.rename_absolute(absolute_path, absolute_backup_path) != OK:
			return false
	if DirAccess.rename_absolute(absolute_temporary_path, absolute_path) == OK:
		DirAccess.remove_absolute(absolute_backup_path)
		return true
	if had_previous:
		DirAccess.rename_absolute(absolute_backup_path, absolute_path)
	return false

static func load_player(default_player: Dictionary, path: String = DEFAULT_SAVE_PATH) -> Dictionary:
	if not has_save(path):
		return {"success": false, "error": "missing_save"}
	var result := _load_file(default_player, path)
	if bool(result.get("success", false)):
		return result
	# Main file missing or damaged: recover a complete temporary save left by an interrupted write.
	for fallback_path: String in [_temporary_path(path), _backup_path(path)]:
		var recovered := _load_file(default_player, fallback_path)
		if bool(recovered.get("success", false)):
			recovered["recovered"] = true
			return recovered
	return result

static func delete_save(path: String = DEFAULT_SAVE_PATH) -> bool:
	for leftover: String in [_temporary_path(path), _backup_path(path)]:
		if FileAccess.file_exists(leftover):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(leftover))
	if not FileAccess.file_exists(path):
		return true
	return DirAccess.remove_absolute(ProjectSettings.globalize_path(path)) == OK

static func _temporary_path(path: String) -> String:
	return "%s.tmp" % path

static func _backup_path(path: String) -> String:
	return "%s.bak" % path

static func _load_file(default_player: Dictionary, path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {"success": false, "error": "missing_save"}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {"success": false, "error": "unreadable_save"}
	var text := file.get_as_text()
	file.close()
	var json := JSON.new()
	if json.parse(text) != OK or not json.data is Dictionary:
		return {"success": false, "error": "invalid_json"}
	var payload := json.data as Dictionary
	if not SUPPORTED_VERSIONS.has(int(payload.get("version", 0))) or not payload.get("player") is Dictionary:
		return {"success": false, "error": "unsupported_save"}
	var run: Dictionary = {}
	if payload.get("run") is Dictionary:
		run = normalize_numbers(payload["run"]) as Dictionary
	var player := _merge_player(default_player, payload["player"] as Dictionary, not run.is_empty())
	if bool(player.get("save_deleted", false)):
		return {"success": false, "error": "deleted_save"}
	return {"success": true, "player": player, "run": run}

## JSON stores every number as float; convert whole numbers back to int so dungeon data keeps
## the same types it had before saving.
static func normalize_numbers(value: Variant) -> Variant:
	match typeof(value):
		TYPE_FLOAT:
			var number := float(value)
			return int(number) if is_equal_approx(number, roundf(number)) else number
		TYPE_DICTIONARY:
			var normalized := {}
			for key: Variant in (value as Dictionary).keys():
				normalized[key] = normalize_numbers(value[key])
			return normalized
		TYPE_ARRAY:
			var items: Array = []
			for item: Variant in value as Array:
				items.append(normalize_numbers(item))
			return items
	return value

static func _merge_player(default_player: Dictionary, saved_player: Dictionary, has_active_run: bool = false) -> Dictionary:
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
					player[key] = normalize_numbers(saved.duplicate(true))
			TYPE_DICTIONARY:
				if typeof(saved) == TYPE_DICTIONARY:
					player[key] = normalize_numbers(saved.duplicate(true))
	_normalize_player(player, has_active_run)
	return player

static func _normalize_player(player: Dictionary, has_active_run: bool = false) -> void:
	for key in ["life", "energy", "mana", "armor", "strength", "speed", "level", "experience_next_level", "reputation_next_level", "reputation_level"]:
		player[key] = maxi(1, int(player.get(key, 1)))
	for key in ["current_life", "current_energy", "current_mana", "current_armor", "current_strength", "current_speed", "current_experience", "dungeon_experience", "current_reputation", "pending_level_points", "reserved_progression_points", "life_sequel_penalty"]:
		player[key] = maxi(0, int(player.get(key, 0)))
	if not has_active_run:
		# Without a saved run there is nothing to resume: no provisional experience survives.
		player["dungeon_experience"] = 0
		player["in_dungeon"] = false
	player["current_life"] = mini(int(player["current_life"]), int(player["life"]))
	player["current_energy"] = mini(int(player["current_energy"]), int(player["energy"]))
	player["current_mana"] = mini(int(player["current_mana"]), int(player["mana"]))
