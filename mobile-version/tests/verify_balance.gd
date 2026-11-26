extends SceneTree
## Balance regression guard. Runs the playtest bot for a short early-game session and checks
## loose bounds, so tuning that makes the game unwinnable (or trivial) fails loudly.
## Full measurements: tools/playtest.gd.

const CombatRules := preload("res://scripts/combat_rules.gd")
const DungeonGenerator := preload("res://scripts/dungeon_generator.gd")
const PlaytestBot := preload("res://tools/playtest_bot.gd")

func _init() -> void:
	await process_frame
	if not _check_rules():
		return
	var bot := PlaytestBot.new(self)
	var summary: Dictionary = await bot.run_playtest(12, 6, 11, "user://verify_balance")
	print("BALANCE ", JSON.stringify({
		"runs": summary["runs"], "completed_rate": summary["completed_rate"],
		"died_rate": summary["died_rate"], "energy_out_rate": summary["energy_out_rate"],
		"runs_to_level": summary["runs_to_level"],
	}))
	if int(summary["stuck"]) > 0:
		_fail("No run should get stuck: %s" % summary.get("stuck_reasons", {}))
		return
	if int(summary["game_over"]) > 0:
		_fail("A careful player should not lose the save in the first runs.")
		return
	if float(summary["completed_rate"]) < 0.15:
		_fail("At least 15%% of early dungeons should be completable (got %.0f%%)." % (float(summary["completed_rate"]) * 100.0))
		return
	if float(summary["died_rate"]) > 0.15:
		_fail("Early deaths should stay at or below 15%% (got %.0f%%)." % (float(summary["died_rate"]) * 100.0))
		return
	var to_level_two := float(summary["runs_to_level"].get("2", 999.0))
	if to_level_two > 10.0:
		_fail("Level 2 should be reached within 10 runs on average (got %.1f)." % to_level_two)
		return
	quit(0)

func _check_rules() -> bool:
	if CombatRules.get_strength_damage_bonus(3) != 0 or CombatRules.get_strength_damage_bonus(5) != 1 or CombatRules.get_strength_damage_bonus(9) != 3:
		return _fail("Strength should add +1 damage per 2 points above 3.")
	var attack := {"damage": 3, "critical_damage_percent": 100}
	if CombatRules.get_attack_damage(attack, false, 7) != 5 or CombatRules.get_attack_damage(attack, true, 7) != 10:
		return _fail("Strength bonus should add to base damage before critical scaling.")
	for level: int in [1, 10, 25, 40]:
		var expected_max := 7 + floori(float(level - 1) / 3.0)
		for sample in 20:
			var dungeon := DungeonGenerator.create_dungeon(1, null, level)
			if int(dungeon["total_monsters"]) > expected_max:
				return _fail("Level %d dungeons should have at most %d monsters." % [level, expected_max])
	return true

func _fail(message: String) -> bool:
	push_error(message)
	quit(1)
	return false
