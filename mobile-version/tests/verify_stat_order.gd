extends SceneTree
## Verifies the consistent-stat-order change (DNG-19): every screen lists its stats in the one
## canonical order of StatOrder.CANONICAL (life, energy, mana, armor, strength, speed,
## reputation, experience, dungeon XP). The order is read from what each screen really shows:
## the hub, the exploration HUD, the Level Up rows and stat guide, and both sides of the fight
## panel. Screens that leave stats out keep the relative order of the rest, so strength always
## comes before speed and no two screens disagree on any pair of stats.
## Run: godot --headless --path . -s res://tests/verify_stat_order.gd

const SaveGame := preload("res://scripts/save_game.gd")
const SettingsStore := preload("res://scripts/settings_store.gd")
const CombatRules := preload("res://scripts/combat_rules.gd")
const DungeonGenerator := preload("res://scripts/dungeon_generator.gd")
const StatOrder := preload("res://scripts/stat_order.gd")
const TEST_SAVE_PATH := "user://verify_stat_order.json"
const TEST_SETTINGS_PATH := "user://verify_stat_order.cfg"
## The order agreed in DNG-19, written out so a change to the shared list is a deliberate one.
const EXPECTED_ORDER := ["life", "energy", "mana", "armor", "strength", "speed", "reputation", "experience", "dungeon_experience"]
## Meta key the stat rows and Level Up guide entries carry (main.gd STAT_KEY_META).
const STAT_KEY_META := &"stat_key"

var main: Control

func _init() -> void:
	SaveGame.delete_save(TEST_SAVE_PATH)
	SettingsStore.delete_settings(TEST_SETTINGS_PATH)
	SettingsStore.save_locale("en", TEST_SETTINGS_PATH)
	SettingsStore.save_tutorial_seen(true, TEST_SETTINGS_PATH)
	get_root().size = Vector2i(1080, 2220)
	main = (load("res://scenes/main.tscn") as PackedScene).instantiate() as Control
	main.save_path = TEST_SAVE_PATH
	main.settings_path = TEST_SETTINGS_PATH
	get_root().add_child(main)
	await process_frame

	if StatOrder.CANONICAL != EXPECTED_ORDER:
		_fail("The canonical stat order should be %s (got %s)." % [EXPECTED_ORDER, StatOrder.CANONICAL])
		return
	if StatOrder.select(["speed", "life", "strength"]) != ["life", "strength", "speed"]:
		_fail("StatOrder.select() should return the given stats in canonical order.")
		return
	var screens := await _collect_screen_orders()
	if screens.is_empty():
		return
	if not _check_screen_orders(screens):
		return
	_cleanup()
	quit(0)

# --- helpers ----------------------------------------------------------------------------

func _cleanup() -> void:
	if is_instance_valid(main):
		get_root().remove_child(main)
		main.free()
	SaveGame.delete_save(TEST_SAVE_PATH)
	SettingsStore.delete_settings(TEST_SETTINGS_PATH)

func _fail(message: String) -> bool:
	push_error(message)
	_cleanup()
	quit(1)
	return false

## Lets containers lay out after a screen change.
func _settle_layout() -> void:
	await process_frame
	await process_frame

## Stat keys of `nodes` in on-screen order, read from the stat key meta. Nodes queued for
## deletion (old Level Up rows) are skipped.
func _stat_keys_of(nodes: Array) -> Array:
	var keys: Array = []
	for node: Node in nodes:
		if node.is_queued_for_deletion():
			continue
		keys.append(String(node.get_meta(STAT_KEY_META, "")))
	return keys

## Opens each screen and records the stat order it shows, keyed by a screen name.
## Returns an empty dictionary (after failing) when a screen has no stats.
func _collect_screen_orders() -> Dictionary:
	var screens := {}
	main._start_new_game()
	await _settle_layout()
	screens["hub"] = _stat_keys_of(main.stats_column.get_children())

	main._show_level_allocation_view()
	await _settle_layout()
	var preview_bars: Array = []
	for row: Node in main.allocation_buttons_container.get_children():
		if not row.is_queued_for_deletion():
			preview_bars.append(row.get_node("StatPreview"))
	screens["level up rows"] = _stat_keys_of(preview_bars)
	var guide_entries: Array = []
	for entry: Node in main.allocation_stat_guide.get_children():
		if entry.has_meta(STAT_KEY_META):
			guide_entries.append(entry)
	screens["level up guide"] = _stat_keys_of(guide_entries)
	main._show_new_game_view()

	CombatRules.begin_dungeon_experience(main.player_state)
	main.dungeon = {"number_of_columns": 2, "number_of_rows": 1, "locations": [
		{"column": 1, "row": 1, "type": DungeonGenerator.LOCATION_ENTRANCE, "visible": true, "visited": true, "content": {}},
		{"column": 2, "row": 1, "type": DungeonGenerator.LOCATION_MONSTER, "visible": true, "visited": false,
			"content": {"name": "Rat", "level": 1, "life": 5, "current_life": 5, "max_life": 5, "armor": 1, "speed": 1, "strength": 1, "mana": 2, "experience": 2, "attacks": []}},
	]}
	main.current_location = main.dungeon["locations"][0]
	main._mark_visible_locations()
	main._render_map()
	main._apply_player_stats()
	main._show_dungeon_explore_view()
	await _settle_layout()
	screens["exploration"] = _stat_keys_of(main.exploration_stats_container.get_children())
	main._show_monster_encounter(main.dungeon["locations"][1])
	await _settle_layout()
	screens["fight panel (player)"] = _stat_keys_of(main.encounter_player_stat_bars.get_children())
	screens["fight panel (monster)"] = _stat_keys_of(main.monster_stat_bars.get_children())

	for screen_name: String in screens:
		if (screens[screen_name] as Array).size() < 2:
			_fail("The %s should list its stats (got %s)." % [screen_name, screens[screen_name]])
			return {}
	return screens

## Every screen is in canonical order, so any two screens agree on every pair of stats they
## both show. Also checks the screens that the ticket named explicitly.
func _check_screen_orders(screens: Dictionary) -> bool:
	for screen_name: String in screens:
		var keys: Array = screens[screen_name]
		if not StatOrder.is_canonical(keys):
			return _fail("The %s should list stats in the canonical order %s (got %s)." % [screen_name, StatOrder.select(keys), keys])
		if keys.has("strength") and keys.has("speed") and keys.find("strength") > keys.find("speed"):
			return _fail("The %s should show strength before speed (got %s)." % [screen_name, keys])
	# Pairwise: for every two screens, the stats they share appear in the same relative order.
	var names := screens.keys()
	for first: int in names.size():
		for second: int in range(first + 1, names.size()):
			var first_keys: Array = screens[names[first]]
			var second_keys: Array = screens[names[second]]
			var shared_in_first := first_keys.filter(func(key: String) -> bool: return second_keys.has(key))
			var shared_in_second := second_keys.filter(func(key: String) -> bool: return first_keys.has(key))
			if shared_in_first != shared_in_second:
				return _fail("The %s %s and the %s %s should order their shared stats the same way." % [names[first], first_keys, names[second], second_keys])
	var allocatable: Array = screens["level up rows"]
	if screens["level up guide"] != allocatable:
		return _fail("The Level Up guide should follow the Level Up rows (%s vs %s)." % [screens["level up guide"], allocatable])
	if allocatable != ["life", "energy", "mana", "armor", "strength", "speed"]:
		return _fail("Level Up should offer life, energy, mana, armor, strength, speed (got %s)." % [allocatable])
	if screens["fight panel (monster)"] != ["life", "mana", "armor", "strength", "speed"]:
		return _fail("The monster panel should show life, mana, armor, strength, speed (got %s)." % [screens["fight panel (monster)"]])
	var hub: Array = screens["hub"]
	if screens["fight panel (player)"] != hub + ["dungeon_experience"]:
		return _fail("The fight panel player stats should be the hub stats plus dungeon XP (got %s)." % [screens["fight panel (player)"]])
	return true
