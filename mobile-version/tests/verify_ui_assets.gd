extends SceneTree

const REQUIRED_ASSETS := [
	"res://assets/characters/player.svg",
	"res://assets/feedback/bomb_explosion.svg",
	"res://assets/feedback/underhand.svg",
	"res://assets/monsters/d20.svg",
	"res://assets/icons/life.svg",
	"res://assets/icons/energy.svg",
	"res://assets/icons/mana.svg",
	"res://assets/icons/armor.svg",
	"res://assets/icons/strength.svg",
	"res://assets/icons/speed.svg",
	"res://assets/icons/reputation.svg",
	"res://assets/icons/experience.svg",
	"res://assets/icons/monster.svg",
	"res://assets/icons/quest.svg",
	"res://assets/icons/sanctuary.svg",
	"res://assets/monsters/fallback.svg",
	"res://assets/monsters/rat.svg",
	"res://assets/monsters/snake.svg",
	"res://assets/monsters/giant_spider.svg",
	"res://assets/monsters/bat.svg",
	"res://assets/monsters/golem.svg",
	"res://assets/monsters/wasp.svg",
	"res://assets/monsters/wolf.svg",
	"res://assets/monsters/giant_scorpion.svg",
	"res://assets/monsters/kobold.svg",
	"res://assets/monsters/goblin.svg",
]
const STAT_ICON_COLORS := {
	"life": "#eb8b8b",
	"energy": "#e7e757",
	"mana": "#82c4c4",
	"armor": "#c2c2c2",
	"strength": "#f3b267",
	"speed": "#8fd3ff",
	"reputation": "#85db7a",
	"experience": "#797bf5",
}

func _init() -> void:
	for asset_path: String in REQUIRED_ASSETS:
		if not FileAccess.file_exists(asset_path):
			push_error("Required UI asset is missing: %s" % asset_path)
			quit(1)
			return

	for feedback_asset: String in ["res://assets/feedback/bomb_explosion.svg", "res://assets/feedback/underhand.svg"]:
		var svg := FileAccess.get_file_as_string(feedback_asset)
		if svg.contains("fill=\"#000000\""):
			push_error("Feedback asset should not render as a black silhouette: %s" % feedback_asset)
			quit(1)
			return

	var experience_svg := FileAccess.get_file_as_string("res://assets/feedback/underhand.svg")
	if not experience_svg.contains("#22c55e") and not experience_svg.contains("#38bdf8"):
		push_error("Experience feedback should use a green, blue, or cyan color.")
		quit(1)
		return

	for stat_key: String in STAT_ICON_COLORS:
		var icon_svg := FileAccess.get_file_as_string("res://assets/icons/%s.svg" % stat_key)
		if not icon_svg.contains(String(STAT_ICON_COLORS[stat_key])):
			push_error("Stat icon should use the web-front stat color: %s" % stat_key)
			quit(1)
			return

	var d20_svg := FileAccess.get_file_as_string("res://assets/monsters/d20.svg")
	if not d20_svg.contains(">20<") or d20_svg.contains(">1<"):
		push_error("D20 asset should show one primary roll value without competing face numbers.")
		quit(1)
		return

	var scene := load("res://scenes/main.tscn") as PackedScene
	var root := scene.instantiate()
	get_root().add_child(root)
	await process_frame

	if root.character_portrait.texture == null:
		push_error("Character portrait should load a local texture.")
		quit(1)
		return

	if root.character_portrait.custom_minimum_size.y <= root.character_portrait.custom_minimum_size.x:
		push_error("Character portrait slot should favor a full-body vertical image.")
		quit(1)
		return

	if root.exploration_stats_container.get_node_or_null("LifeStatBar") == null:
		push_error("Exploration stats should include life stat bar.")
		quit(1)
		return

	root.player_state["current_experience"] = 20
	root.player_state["dungeon_experience"] = 7
	root._apply_player_stats()
	var permanent_experience := root.exploration_stats_container.get_node_or_null("ExperienceStatBar") as HBoxContainer
	var dungeon_experience := root.exploration_stats_container.get_node_or_null("DungeonExperienceStatBar") as HBoxContainer
	if permanent_experience == null or dungeon_experience == null:
		push_error("Exploration should display separate permanent and dungeon experience bars.")
		quit(1)
		return
	if (permanent_experience.get_node("Value") as Label).text != "20/100" or (dungeon_experience.get_node("Value") as Label).text != "7/100":
		push_error("Permanent and dungeon experience bars should display independent values.")
		quit(1)
		return
	if (permanent_experience.get_node("Label") as Label).text == (dungeon_experience.get_node("Label") as Label).text:
		push_error("Experience bars should have distinct visible labels.")
		quit(1)
		return

	if root.stats_column.get_child(0).name != "LifeStatBar" or root.stats_column.get_child(1).name != "EnergyStatBar":
		push_error("Player stat bars should start with life, then energy.")
		quit(1)
		return

	if root.stats_column.get_node_or_null("DamageStatBar") != null or root.stats_column.get_node_or_null("StrengthStatBar") == null or root.stats_column.get_node_or_null("SpeedStatBar") == null:
		push_error("Player stat bars should remove damage and include strength and speed.")
		quit(1)
		return

	var life_stat_bar := root.stats_column.get_node("LifeStatBar") as HBoxContainer
	var life_icon := life_stat_bar.get_node("Icon") as TextureRect
	var life_bar := life_stat_bar.get_node("Bar") as ProgressBar
	var life_fill := life_bar.get_theme_stylebox("fill") as StyleBoxFlat
	var life_background := life_bar.get_theme_stylebox("background") as StyleBoxFlat
	if life_icon.modulate == Color.WHITE or life_fill.bg_color == life_background.bg_color:
		push_error("Stat bars should color the icon and filled bar while keeping the missing segment dark.")
		quit(1)
		return

	if not life_fill.bg_color.is_equal_approx(Color.html("#eb8b8b")):
		push_error("Life stat bar should use the web-front life color.")
		quit(1)
		return

	if root.damage_overlay_icon.texture == null:
		push_error("Damage overlay should load bomb explosion texture.")
		quit(1)
		return

	quit(0)
