extends SceneTree
## Command-line balance playtest. See tools/playtest_bot.gd for the player behaviour.
##
## Usage:
##   godot --headless --path . -s res://tools/playtest.gd -- [runs=200] [games=1] [seed=1] [dir=user://playtest]
## Prints one JSON summary line prefixed with "PLAYTEST ".

const PlaytestBot := preload("res://tools/playtest_bot.gd")

func _init() -> void:
	var options := {"runs": 200, "games": 1, "seed": 1, "dir": "user://playtest"}
	for arg: String in OS.get_cmdline_user_args():
		var parts := arg.split("=", true, 1)
		options[parts[0]] = parts[1] if parts.size() > 1 else true
	if options.has("monster_points"):
		preload("res://scripts/dungeon_generator.gd").monster_points_per_level = float(options["monster_points"])
	await process_frame
	var bot := PlaytestBot.new(self)
	var summary: Dictionary = await bot.run_playtest(int(options["runs"]), int(options["games"]), int(options["seed"]), String(options["dir"]))
	print("PLAYTEST ", JSON.stringify(summary))
	quit(0)
