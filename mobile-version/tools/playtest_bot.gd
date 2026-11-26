extends RefCounted
## Automated player for balance measurement, driving the real main scene through its methods.
##
## Plays like a sensible player: spends points, explores with path-finding toward the nearest
## unexplored cell or living monster, collects treasure, rests when hurt, flees when weak, and
## walks back to retreat before energy runs out. Overlay timers are skipped so runs are fast.
## Used by tools/playtest.gd (command line) and tests/verify_balance.gd.

const CombatRules := preload("res://scripts/combat_rules.gd")
const DungeonGenerator := preload("res://scripts/dungeon_generator.gd")
const MAX_ACTIONS_PER_RUN := 3000

var tree: SceneTree
var main: Control
var rng := RandomNumberGenerator.new()

func _init(scene_tree: SceneTree) -> void:
	tree = scene_tree

## Plays `runs` dungeon runs per game, for `games` independent games. Returns aggregate metrics.
func run_playtest(runs: int, games: int, random_seed: int, dir: String) -> Dictionary:
	seed(random_seed)
	rng.seed = random_seed
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(dir))
	var totals := {
		"runs": 0, "completed": 0, "retreated": 0, "energy_out": 0, "abandoned": 0, "died": 0,
		"game_over": 0, "stuck": 0, "levels_reached": [], "runs_to_level": {}, "monsters_killed": 0,
		"fights": 0, "flee_attempts": 0, "actions": 0,
	}
	for game in games:
		_start_game(dir, game)
		var runs_to_level: Dictionary = {}
		for run in runs:
			if bool(main.player_state.get("save_deleted", false)) or not main.new_game_view.visible:
				totals["game_over"] += 1
				break
			_spend_points()
			var level := int(main.player_state.get("level", 1))
			if not runs_to_level.has(level):
				runs_to_level[level] = run
			main.start_dungeon_exploration()
			var outcome: String = await _play_dungeon(totals)
			totals["runs"] += 1
			totals[outcome] = int(totals.get(outcome, 0)) + 1
			var band := "L1" if level <= 1 else ("L2-4" if level <= 4 else ("L5-9" if level <= 9 else "L10+"))
			var by_band: Dictionary = totals.get("by_level", {})
			var stats: Dictionary = by_band.get(band, {"runs": 0})
			stats["runs"] = int(stats["runs"]) + 1
			stats[outcome] = int(stats.get(outcome, 0)) + 1
			by_band[band] = stats
			totals["by_level"] = by_band
		_spend_points()
		totals["levels_reached"].append(int(main.player_state.get("level", 1)))
		for level: int in runs_to_level:
			var key := str(level)
			if not totals["runs_to_level"].has(key):
				totals["runs_to_level"][key] = []
			totals["runs_to_level"][key].append(runs_to_level[level])
		_end_game()
		await tree.process_frame
	var run_count := maxf(1.0, float(totals["runs"]))
	for key: String in ["completed", "retreated", "energy_out", "died", "stuck"]:
		totals["%s_rate" % key] = snappedf(float(totals[key]) / run_count, 0.001)
	var levels: Array = totals["levels_reached"]
	totals["avg_level"] = snappedf(float(levels.reduce(func(a, b): return a + b, 0)) / maxf(1.0, levels.size()), 0.01)
	for key: String in totals["runs_to_level"]:
		var values: Array = totals["runs_to_level"][key]
		totals["runs_to_level"][key] = snappedf(float(values.reduce(func(a, b): return a + b, 0)) / values.size(), 0.1)
	return totals

func _start_game(dir: String, index: int) -> void:
	main = (load("res://scenes/main.tscn") as PackedScene).instantiate() as Control
	main.save_path = "%s/playtest_%d.json" % [dir, index]
	main.settings_path = "%s/playtest_settings.cfg" % dir
	var layout_rng := RandomNumberGenerator.new()
	layout_rng.seed = rng.randi()
	main.dungeon_rng = layout_rng
	tree.root.add_child(main)
	main._start_new_game()

func _end_game() -> void:
	tree.root.remove_child(main)
	main.free()

func _spend_points() -> void:
	CombatRules.convert_available_level_ups(main.player_state)
	var points := int(main.player_state.get("reserved_progression_points", 0))
	if points <= 0:
		return
	main._show_level_allocation_view()
	if int(main.player_state.get("level", 1)) >= 10 and String(main.player_state.get("selected_class", "")) == "":
		var classes: Array = CombatRules.load_player_classes()
		main._select_player_class(String(classes[rng.randi_range(0, classes.size() - 1)].get("id", "")))
	var order := ["strength", "life", "energy", "strength", "armor", "life", "speed", "energy"]
	for i in points:
		main._stage_level_point(order[i % order.size()])
	main._confirm_level_allocation()
	if not main.new_game_view.visible:
		main._show_new_game_view()

## Settles timers the UI would wait for, so the bot never waits on real time.
func _settle() -> void:
	# The first-run tutorial opens on the first dungeon entry; skip it like a returning player.
	if main.tutorial_overlay.is_open():
		main.tutorial_overlay.skip()
	if main.damage_overlay.visible:
		main._hide_damage_overlay()
	if main.dungeon_exit_pending:
		main._finish_depleted_dungeon_exit()

func _play_dungeon(totals: Dictionary) -> String:
	for step in MAX_ACTIONS_PER_RUN:
		totals["actions"] += 1
		# Let deferred calls and freed nodes flush; the UI queues work every action.
		if step % 8 == 0:
			await tree.process_frame
		_settle()
		# The fight victory screen is an in-run summary, not a run result: press Continue and keep
		# playing (a low-energy warning from the same fight may follow and is handled below).
		if main.fight_victory_modal.visible:
			main._hide_fight_victory()
			continue
		# The low-energy warning is an in-run notice, not a run result: dismiss it and keep playing.
		if main.game_result_modal.visible and main.game_result_title.text == main.tr(main.LOW_ENERGY_TITLE_KEY):
			main._hide_game_result()
			continue
		if main.game_result_modal.visible:
			var title: String = main.game_result_title.text
			var message: String = main.game_result_message.text
			main._hide_game_result()
			return _classify(title, message)
		if main.monster_encounter_view.visible:
			_combat_turn(totals)
			continue
		if main.dungeon_explore_view.visible:
			if not _explore_turn():
				return _stuck(totals, "no_path")
			continue
		return _stuck(totals, "no_view")
	return _stuck(totals, "action_limit")

func _stuck(totals: Dictionary, reason: String) -> String:
	var reasons: Dictionary = totals.get("stuck_reasons", {})
	var key := "%s@L%d(%dx%d,%d monsters)" % [reason, int(main.player_state.get("level", 1)), int(main.dungeon.get("number_of_columns", 0)), int(main.dungeon.get("number_of_rows", 0)), DungeonGenerator.count_total_monsters(main.dungeon)]
	reasons[key] = int(reasons.get(key, 0)) + 1
	totals["stuck_reasons"] = reasons
	# Leave the run so the game can continue.
	main.dungeon = {}
	main.current_location = {}
	main.active_monster_location = {}
	main.player_state["in_dungeon"] = false
	main.player_state["dungeon_experience"] = 0
	CombatRules.restore_status_after_alive_exit(main.player_state)
	main._show_new_game_view()
	return "stuck"

func _classify(title: String, message: String) -> String:
	if title == main.tr("RESULT_COMPLETED_TITLE"):
		return "completed"
	if title == main.tr("RESULT_DEFEAT_TITLE") or title == main.tr("RESULT_GAME_OVER_TITLE"):
		return "died"
	if message == main.tr("RESULT_RETREATED_MESSAGE"):
		return "retreated"
	if message == main.tr("RESULT_ABANDONED_MESSAGE"):
		return "abandoned"
	return "energy_out"

func _combat_turn(totals: Dictionary) -> void:
	var player: Dictionary = main.player_state
	var life_ratio := float(player["current_life"]) / maxf(1.0, float(player["life"]))
	var monster: Dictionary = main.active_monster_location.get("content", {})
	var monster_life := int(monster.get("current_life", monster.get("life", 0)))
	# Flee when badly hurt and the monster is not almost dead, or when the attack is unaffordable.
	if main.fight_button.disabled or (life_ratio <= 0.3 and monster_life > 2):
		totals["flee_attempts"] += 1
		main._flee_encounter()
		return
	var alive_before := DungeonGenerator.is_monster_alive(main.active_monster_location)
	var location: Dictionary = main.active_monster_location
	totals["fights"] += 1
	main._fight()
	if alive_before and not DungeonGenerator.is_monster_alive(location):
		totals["monsters_killed"] += 1

func _explore_turn() -> bool:
	var player: Dictionary = main.player_state
	if main.collect_treasure_button.visible and not main.collect_treasure_button.disabled:
		main._collect_treasure()
		return true
	var at_entrance: bool = main.current_location.get("type") == DungeonGenerator.LOCATION_ENTRANCE
	var energy := int(player["current_energy"])
	var home_distance := _distance_to_entrance()
	var life_ratio := float(player["current_life"]) / maxf(1.0, float(player["life"]))
	# Rest when hurt and mana allows.
	if life_ratio < 0.5 and int(player["current_mana"]) >= CombatRules.REST_MANA_COST:
		main._rest()
		return true
	# Head home while there is still enough energy to get back and retreat.
	var going_home := energy <= home_distance + 4 or (life_ratio < 0.3 and int(player["current_mana"]) < CombatRules.REST_MANA_COST)
	if going_home and at_entrance:
		main._retreat()
		return true
	var target := _step_toward(_home_predicate() if going_home else _target_predicate())
	if target == "":
		if at_entrance:
			main._retreat()
			return true
		target = _step_toward(_home_predicate())
		if target == "":
			return false
	main.move_player(target)
	return true

func _home_predicate() -> Callable:
	return func(location: Dictionary) -> bool:
		return location.get("type") == DungeonGenerator.LOCATION_ENTRANCE

func _target_predicate() -> Callable:
	return func(location: Dictionary) -> bool:
		if DungeonGenerator.is_monster_alive(location):
			return true
		if location.get("type") == DungeonGenerator.LOCATION_QUEST and not bool(location.get("visited", false)):
			return true
		if location.get("type") == DungeonGenerator.LOCATION_SANCTUARY and not bool(location.get("visited", false)):
			return float(main.player_state["current_life"]) < float(main.player_state["life"]) * 0.7
		return not bool(location.get("visible", false))

## First step of the shortest path to the nearest cell matching `predicate` ("" if none).
func _step_toward(predicate: Callable) -> String:
	var start := Vector2i(int(main.current_location["column"]), int(main.current_location["row"]))
	var first_step := {start: ""}
	var queue: Array[Vector2i] = [start]
	var directions := {"left": Vector2i(-1, 0), "right": Vector2i(1, 0), "up": Vector2i(0, -1), "down": Vector2i(0, 1)}
	while not queue.is_empty():
		var cell: Vector2i = queue.pop_front()
		var location: Dictionary = DungeonGenerator.get_location(main.dungeon, cell.x, cell.y)
		if cell != start and predicate.call(location):
			return String(first_step[cell])
		# Do not path through living monsters or unknown cells beyond the frontier.
		if cell != start and (DungeonGenerator.is_monster_alive(location) or not bool(location.get("visible", false))):
			continue
		for direction: String in directions:
			var next: Vector2i = cell + directions[direction]
			if first_step.has(next):
				continue
			var neighbor: Dictionary = DungeonGenerator.get_location(main.dungeon, next.x, next.y)
			if neighbor.is_empty() or neighbor.get("type") == DungeonGenerator.LOCATION_BLOCK:
				continue
			first_step[next] = direction if cell == start else first_step[cell]
			queue.append(next)
	return ""

func _distance_to_entrance() -> int:
	var entrance: Dictionary = DungeonGenerator.get_entrance(main.dungeon)
	var target := Vector2i(int(entrance["column"]), int(entrance["row"]))
	var start := Vector2i(int(main.current_location["column"]), int(main.current_location["row"]))
	var distance := {start: 0}
	var queue: Array[Vector2i] = [start]
	while not queue.is_empty():
		var cell: Vector2i = queue.pop_front()
		if cell == target:
			return int(distance[cell])
		for offset: Vector2i in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
			var next := cell + offset
			if distance.has(next):
				continue
			var location: Dictionary = DungeonGenerator.get_location(main.dungeon, next.x, next.y)
			if location.is_empty() or location.get("type") == DungeonGenerator.LOCATION_BLOCK:
				continue
			distance[next] = int(distance[cell]) + 1
			queue.append(next)
	return 99
