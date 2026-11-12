extends Control

const SaveGame := preload("res://scripts/save_game.gd")
const SettingsStore := preload("res://scripts/settings_store.gd")

const LOCALE_ENGLISH := "en"
const LOCALE_SPANISH := "es"

const START_GAME_KEY := "MENU_START_GAME"
const LOAD_GAME_KEY := "MENU_LOAD_GAME"
const SETTINGS_KEY := "MENU_SETTINGS"
const CHARACTER_PLACEHOLDER_KEY := "NEW_GAME_CHARACTER_PLACEHOLDER"
const EXPLORE_DUNGEON_KEY := "NEW_GAME_EXPLORE_DUNGEON"
const CHALLENGE_DUNGEON_KEY := "NEW_GAME_CHALLENGE_DUNGEON"
const MANAGE_EQUIPMENT_KEY := "NEW_GAME_MANAGE_EQUIPMENT"
const SHOP_KEY := "NEW_GAME_SHOP"
const EXIT_KEY := "NEW_GAME_EXIT"
const REST_KEY := "EXPLORE_REST"
const RETREAT_KEY := "EXPLORE_RETREAT"
const COLLECT_TREASURE_KEY := "EXPLORE_COLLECT_TREASURE"
const FIGHT_KEY := "ENCOUNTER_FIGHT"
const FLEE_KEY := "ENCOUNTER_FLEE"
const PLAYER_TITLE_KEY := "ENCOUNTER_PLAYER"
const ALLOCATION_TITLE_KEY := "LEVEL_ALLOCATION_TITLE"
const ALLOCATION_REMAINING_KEY := "LEVEL_ALLOCATION_REMAINING"
const ALLOCATION_CONFIRM_KEY := "LEVEL_ALLOCATION_CONFIRM"
const ALLOCATION_BACK_KEY := "LEVEL_ALLOCATION_BACK"
const ALLOCATION_NO_POINTS_KEY := "LEVEL_ALLOCATION_NO_POINTS"
const CLASS_CHOICE_TITLE_KEY := "LEVEL_CLASS_CHOICE_TITLE"
const PROGRESSION_PENDING_KEY := "LEVEL_PROGRESSION_PENDING"
const DUNGEON_ENERGY_DEPLETED_KEY := "DUNGEON_ENERGY_DEPLETED"
const DUNGEON_LIFE_DEPLETED_KEY := "DUNGEON_LIFE_DEPLETED"
const MONSTER_INFO_KEY := "ENCOUNTER_MONSTER_INFO"
const MONSTER_ATTACKS_TITLE_KEY := "ENCOUNTER_MONSTER_ATTACKS_TITLE"
const MONSTER_ATTACK_LINE_KEY := "ENCOUNTER_MONSTER_ATTACK_LINE"
const SETTINGS_TITLE_KEY := "SETTINGS_TITLE"
const SETTINGS_LANGUAGE_KEY := "SETTINGS_LANGUAGE"
const SETTINGS_ENGLISH_KEY := "SETTINGS_ENGLISH"
const SETTINGS_SPANISH_KEY := "SETTINGS_SPANISH"
const SETTINGS_BACK_KEY := "SETTINGS_BACK"
const COMING_SOON_KEY := "COMING_SOON"
const CONFIRM_NEW_GAME_TITLE_KEY := "CONFIRM_NEW_GAME_TITLE"
const CONFIRM_NEW_GAME_MESSAGE_KEY := "CONFIRM_NEW_GAME_MESSAGE"
const CONFIRM_EXIT_TITLE_KEY := "CONFIRM_EXIT_TITLE"
const CONFIRM_EXIT_MESSAGE_KEY := "CONFIRM_EXIT_MESSAGE"
const CONFIRM_ACCEPT_KEY := "CONFIRM_ACCEPT"
const CONFIRM_CANCEL_KEY := "CONFIRM_CANCEL"
const RESULT_CONTINUE_KEY := "RESULT_CONTINUE"
const RESULT_COMPLETED_TITLE_KEY := "RESULT_COMPLETED_TITLE"
const RESULT_RETREATED_TITLE_KEY := "RESULT_RETREATED_TITLE"
const RESULT_RETREATED_MESSAGE_KEY := "RESULT_RETREATED_MESSAGE"
const RESULT_ENDED_TITLE_KEY := "RESULT_ENDED_TITLE"
const RESULT_DEFEAT_TITLE_KEY := "RESULT_DEFEAT_TITLE"
const RESULT_GAME_OVER_TITLE_KEY := "RESULT_GAME_OVER_TITLE"

const CHARACTER_ASSET := "res://assets/characters/player.svg"
const FALLBACK_MONSTER_ASSET := "res://assets/monsters/fallback.svg"
const DAMAGE_FEEDBACK_ASSET := "res://assets/feedback/bomb_explosion.svg"
const EXPERIENCE_FEEDBACK_ASSET := "res://assets/feedback/underhand.svg"
const MAP_VIEW_COLUMNS := 5
const MAP_VIEW_ROWS := 7
const STAT_ICON_PATHS := {
	"energy": "res://assets/icons/energy.svg",
	"life": "res://assets/icons/life.svg",
	"mana": "res://assets/icons/mana.svg",
	"armor": "res://assets/icons/armor.svg",
	"strength": "res://assets/icons/strength.svg",
	"speed": "res://assets/icons/speed.svg",
	"reputation": "res://assets/icons/reputation.svg",
	"experience": "res://assets/icons/experience.svg",
	"dungeon_experience": "res://assets/icons/experience.svg",
}
const STAT_COLORS := {
	"life": "#eb8b8b",
	"energy": "#e7e757",
	"mana": "#82c4c4",
	"armor": "#c2c2c2",
	"strength": "#f3b267",
	"speed": "#8fd3ff",
	"reputation": "#85db7a",
	"experience": "#797bf5",
	"dungeon_experience": "#38bdf8",
}
const LOCATION_ICON_PATHS := {
	"MONSTER": "res://assets/icons/monster.svg",
	"QUEST": "res://assets/icons/quest.svg",
	"SANCTUARY": "res://assets/icons/sanctuary.svg",
}
const MONSTER_ASSET_PATHS := {
	"Rat": "res://assets/monsters/rat.svg",
	"Snake": "res://assets/monsters/snake.svg",
	"Giant Spider": "res://assets/monsters/giant_spider.svg",
	"Bat": "res://assets/monsters/bat.svg",
	"Golem": "res://assets/monsters/golem.svg",
	"Wasp": "res://assets/monsters/wasp.svg",
	"Wolf": "res://assets/monsters/wolf.svg",
	"Giant Scorpion": "res://assets/monsters/giant_scorpion.svg",
	"Kobold": "res://assets/monsters/kobold.svg",
	"Goblin": "res://assets/monsters/goblin.svg",
}
const PLAYER_STATS := [
	{
		"name": "Life",
		"key": "life",
	},
	{
		"name": "Energy",
		"key": "energy",
	},
	{
		"name": "Mana",
		"key": "mana",
	},
	{
		"name": "Armor",
		"key": "armor",
	},
	{
		"name": "Strength",
		"key": "strength",
	},
	{
		"name": "Speed",
		"key": "speed",
	},
	{
		"name": "Reputation",
		"key": "reputation",
	},
	{
		"name": "Experience",
		"key": "experience",
		"label_key": "STAT_EXPERIENCE",
	},
]
const EXPLORATION_STATS := [
	{"name": "Life", "key": "life"},
	{"name": "Energy", "key": "energy"},
	{"name": "Mana", "key": "mana"},
	{"name": "Experience", "key": "experience", "label_key": "STAT_EXPERIENCE"},
	{"name": "DungeonExperience", "key": "dungeon_experience", "label_key": "STAT_DUNGEON_EXPERIENCE"},
]
const MONSTER_STATS := [
	{"name": "Life", "key": "life"},
	{"name": "Mana", "key": "mana"},
	{"name": "Armor", "key": "armor"},
	{"name": "Speed", "key": "speed"},
	{"name": "Strength", "key": "strength"},
]

var dungeon: Dictionary = {}
var current_location: Dictionary = {}
var previous_location: Dictionary = {}
var active_monster_location: Dictionary = {}
var player_state: Dictionary = CombatRules.create_default_player()
var map_cells: Array[Control] = []
var next_attack_roll: float = -1.0
var next_counter_roll: float = -1.0
var next_dodge_roll: float = -1.0
var next_player_dodge_roll: float = -1.0
var next_quest_roll: float = -1.0
var next_flee_roll: float = -1.0
var character_portrait: TextureRect
var exploration_stats_container: VBoxContainer
var monster_stat_bars: VBoxContainer
var encounter_player_stat_bars: VBoxContainer
var monster_image_asset: TextureRect
var encounter_player_asset: TextureRect
var collect_treasure_button: Button
var damage_overlay: ColorRect
var damage_overlay_icon: TextureRect
var damage_overlay_text: Label
var monster_roll_display: Label
var player_roll_display: Label
var level_allocation_view: Control
var settings_view: Control
var settings_title: Label
var settings_language_label: Label
var settings_english_button: Button
var settings_spanish_button: Button
var settings_back_button: Button
var action_confirmation: ConfirmationDialog
var pending_confirmation_action: Callable
var game_result_modal: ColorRect
var game_result_title: Label
var game_result_message: Label
var game_result_continue_button: Button
var progression_indicator: Panel
var allocation_remaining_label: Label
var allocation_buttons_container: VBoxContainer
var allocation_confirm_button: Button
var class_choice_container: VBoxContainer
var monster_info_button: Button
var monster_info_modal: Control
var monster_info_text: Label
var dungeon_exit_pending: bool = false
var staged_allocation: Dictionary = {}
var save_path: String = SaveGame.DEFAULT_SAVE_PATH
var settings_path: String = SettingsStore.DEFAULT_SETTINGS_PATH
var pending_game_result_title: String = ""
var pending_game_result_message: String = ""

@onready var main_menu_view: Control = $MainMenuView
@onready var new_game_view: Control = $NewGameView
@onready var dungeon_explore_view: Control = $DungeonExploreView
@onready var monster_encounter_view: Control = $MonsterEncounterView
@onready var start_game_button: Button = $MainMenuView/MenuArea/MenuButtons/StartGameButton
@onready var load_game_button: Button = $MainMenuView/MenuArea/MenuButtons/LoadGameButton
@onready var settings_button: Button = $MainMenuView/MenuArea/MenuButtons/SettingsButton
@onready var character_placeholder: Label = $NewGameView/CharacterArea/CharacterColumns/CharacterImageSlot/CharacterImagePlaceholder
@onready var stats_column: VBoxContainer = $NewGameView/CharacterArea/CharacterColumns/StatsColumn
@onready var explore_dungeon_button: Button = $NewGameView/ActionArea/ActionButtons/ExploreDungeonButton
@onready var challenge_dungeon_button: Button = $NewGameView/ActionArea/ActionButtons/ChallengeDungeonButton
@onready var manage_equipment_button: Button = $NewGameView/ActionArea/ActionButtons/ManageEquipmentButton
@onready var shop_button: Button = $NewGameView/ActionArea/ActionButtons/ShopButton
@onready var exit_button: Button = $NewGameView/ActionArea/ActionButtons/ExitButton
@onready var map_grid: GridContainer = $DungeonExploreView/MapArea/MapFrame/MapGrid
@onready var move_left_button: Button = $DungeonExploreView/ExploreActions/ExploreActionStack/DirectionPad/DirectionRow/MoveLeftButton
@onready var move_up_button: Button = $DungeonExploreView/ExploreActions/ExploreActionStack/DirectionPad/DirectionRow/VerticalDirections/MoveUpButton
@onready var move_down_button: Button = $DungeonExploreView/ExploreActions/ExploreActionStack/DirectionPad/DirectionRow/VerticalDirections/MoveDownButton
@onready var move_right_button: Button = $DungeonExploreView/ExploreActions/ExploreActionStack/DirectionPad/DirectionRow/MoveRightButton
@onready var rest_button: Button = $DungeonExploreView/ExploreActions/ExploreActionStack/ExploreSecondaryActions/RestButton
@onready var retreat_button: Button = $DungeonExploreView/ExploreActions/ExploreActionStack/ExploreSecondaryActions/RetreatButton
@onready var explore_feedback: Label = $DungeonExploreView/ExploreActions/ExploreActionStack/ExploreFeedback
@onready var monster_image: Label = $MonsterEncounterView/EncounterInfoArea/EncounterStack/MonsterRow/MonsterImage
@onready var monster_name: Label = $MonsterEncounterView/EncounterInfoArea/EncounterStack/MonsterRow/MonsterPanel/MonsterName
@onready var monster_stats: Label = $MonsterEncounterView/EncounterInfoArea/EncounterStack/MonsterRow/MonsterPanel/MonsterStats
@onready var encounter_player_title: Label = $MonsterEncounterView/EncounterInfoArea/EncounterStack/PlayerRow/EncounterPlayerPanel/EncounterPlayerTitle
@onready var encounter_player_stats: Label = $MonsterEncounterView/EncounterInfoArea/EncounterStack/PlayerRow/EncounterPlayerPanel/EncounterPlayerStats
@onready var encounter_player_image: Label = $MonsterEncounterView/EncounterInfoArea/EncounterStack/PlayerRow/EncounterPlayerImage
@onready var fight_button: Button = $MonsterEncounterView/EncounterActions/EncounterActionButtons/FightButton
@onready var flee_button: Button = $MonsterEncounterView/EncounterActions/EncounterActionButtons/FleeButton
@onready var encounter_feedback: Label = $MonsterEncounterView/EncounterActions/EncounterActionButtons/EncounterFeedback

func _ready() -> void:
	TranslationServer.set_locale(SettingsStore.load_locale(_get_supported_locale(), settings_path))
	_build_runtime_ui()
	_apply_menu_text()
	_apply_player_stats()
	_connect_navigation_signals()
	_update_load_game_button()
	_show_main_menu_view()

func _get_supported_locale() -> String:
	return LOCALE_SPANISH if OS.get_locale_language() == LOCALE_SPANISH else LOCALE_ENGLISH

func _apply_menu_text() -> void:
	start_game_button.text = tr(START_GAME_KEY)
	load_game_button.text = tr(LOAD_GAME_KEY)
	settings_button.text = tr(SETTINGS_KEY)
	character_placeholder.text = tr(CHARACTER_PLACEHOLDER_KEY)
	explore_dungeon_button.text = tr(EXPLORE_DUNGEON_KEY)
	challenge_dungeon_button.text = "%s — %s" % [tr(CHALLENGE_DUNGEON_KEY), tr(COMING_SOON_KEY)]
	manage_equipment_button.text = tr(MANAGE_EQUIPMENT_KEY)
	shop_button.text = "%s — %s" % [tr(SHOP_KEY), tr(COMING_SOON_KEY)]
	challenge_dungeon_button.disabled = true
	shop_button.disabled = true
	exit_button.text = tr(EXIT_KEY)
	rest_button.text = tr(REST_KEY)
	retreat_button.text = tr(RETREAT_KEY)
	collect_treasure_button.text = tr(COLLECT_TREASURE_KEY)
	fight_button.text = tr(FIGHT_KEY)
	flee_button.text = tr(FLEE_KEY)
	encounter_player_title.text = tr(PLAYER_TITLE_KEY)
	encounter_player_image.text = tr(PLAYER_TITLE_KEY)
	if is_instance_valid(allocation_confirm_button):
		allocation_confirm_button.text = tr(ALLOCATION_CONFIRM_KEY)
	if is_instance_valid(monster_info_button):
		monster_info_button.text = tr(MONSTER_INFO_KEY)
	if is_instance_valid(settings_title):
		settings_title.text = tr(SETTINGS_TITLE_KEY)
	if is_instance_valid(settings_language_label):
		settings_language_label.text = tr(SETTINGS_LANGUAGE_KEY)
	if is_instance_valid(settings_english_button):
		settings_english_button.text = tr(SETTINGS_ENGLISH_KEY)
	if is_instance_valid(settings_spanish_button):
		settings_spanish_button.text = tr(SETTINGS_SPANISH_KEY)
	if is_instance_valid(settings_back_button):
		settings_back_button.text = tr(SETTINGS_BACK_KEY)
	if is_instance_valid(action_confirmation):
		action_confirmation.get_ok_button().text = tr(CONFIRM_ACCEPT_KEY)
		action_confirmation.get_cancel_button().text = tr(CONFIRM_CANCEL_KEY)
	if is_instance_valid(game_result_continue_button):
		game_result_continue_button.text = tr(RESULT_CONTINUE_KEY)

func _apply_player_stats() -> void:
	_populate_stat_bars(stats_column, PLAYER_STATS, player_state, false)
	if is_instance_valid(exploration_stats_container):
		_populate_stat_bars(exploration_stats_container, EXPLORATION_STATS, player_state, true)
	_update_progression_indicator()

func _connect_navigation_signals() -> void:
	var request_new_game := Callable(self, "_request_new_game")
	var load_game := Callable(self, "_load_game")
	var request_exit_to_menu := Callable(self, "_request_exit_to_menu")
	var start_explore := Callable(self, "start_dungeon_exploration")
	var move_left := Callable(self, "_move_left")
	var move_up := Callable(self, "_move_up")
	var move_down := Callable(self, "_move_down")
	var move_right := Callable(self, "_move_right")
	var retreat := Callable(self, "_retreat")
	var rest := Callable(self, "_rest")
	var collect_treasure := Callable(self, "_collect_treasure")
	var fight := Callable(self, "_fight")
	var flee := Callable(self, "_flee_encounter")
	var show_allocation := Callable(self, "_show_level_allocation_view")
	var show_settings := Callable(self, "_show_settings_view")

	if not start_game_button.pressed.is_connected(request_new_game):
		start_game_button.pressed.connect(request_new_game)
	if not load_game_button.pressed.is_connected(load_game):
		load_game_button.pressed.connect(load_game)

	if not exit_button.pressed.is_connected(request_exit_to_menu):
		exit_button.pressed.connect(request_exit_to_menu)

	if not explore_dungeon_button.pressed.is_connected(start_explore):
		explore_dungeon_button.pressed.connect(start_explore)

	if not manage_equipment_button.pressed.is_connected(show_allocation):
		manage_equipment_button.pressed.connect(show_allocation)
	if not settings_button.pressed.is_connected(show_settings):
		settings_button.pressed.connect(show_settings)

	if not move_left_button.pressed.is_connected(move_left):
		move_left_button.pressed.connect(move_left)
	if not move_up_button.pressed.is_connected(move_up):
		move_up_button.pressed.connect(move_up)
	if not move_down_button.pressed.is_connected(move_down):
		move_down_button.pressed.connect(move_down)
	if not move_right_button.pressed.is_connected(move_right):
		move_right_button.pressed.connect(move_right)
	if not retreat_button.pressed.is_connected(retreat):
		retreat_button.pressed.connect(retreat)
	if not rest_button.pressed.is_connected(rest):
		rest_button.pressed.connect(rest)
	if not collect_treasure_button.pressed.is_connected(collect_treasure):
		collect_treasure_button.pressed.connect(collect_treasure)
	if not fight_button.pressed.is_connected(fight):
		fight_button.pressed.connect(fight)
	if not flee_button.pressed.is_connected(flee):
		flee_button.pressed.connect(flee)

func _start_new_game() -> void:
	player_state = CombatRules.create_default_player()
	_persist_player_state()
	_apply_player_stats()
	_show_new_game_view()

func _request_new_game() -> void:
	var saved := SaveGame.load_player(CombatRules.create_default_player(), save_path)
	if bool(saved.get("success", false)):
		_show_confirmation(tr(CONFIRM_NEW_GAME_TITLE_KEY), tr(CONFIRM_NEW_GAME_MESSAGE_KEY), Callable(self, "_start_new_game"))
		return
	_start_new_game()

func _request_exit_to_menu() -> void:
	_show_confirmation(tr(CONFIRM_EXIT_TITLE_KEY), tr(CONFIRM_EXIT_MESSAGE_KEY), Callable(self, "_show_main_menu_view"))

func _show_confirmation(title: String, message: String, action: Callable) -> void:
	pending_confirmation_action = action
	action_confirmation.title = title
	action_confirmation.dialog_text = message
	action_confirmation.popup_centered(Vector2i(340, 220))

func _confirm_pending_action() -> void:
	var action := pending_confirmation_action
	pending_confirmation_action = Callable()
	if action.is_valid():
		action.call()

func _cancel_pending_action() -> void:
	pending_confirmation_action = Callable()

func _load_game() -> void:
	var result := SaveGame.load_player(CombatRules.create_default_player(), save_path)
	if not bool(result.get("success", false)):
		_update_load_game_button()
		return
	player_state = (result["player"] as Dictionary).duplicate(true)
	_apply_player_stats()
	_show_new_game_view()

func _persist_player_state() -> bool:
	if bool(player_state.get("save_deleted", false)):
		var deleted := SaveGame.delete_save(save_path)
		_update_load_game_button()
		return deleted
	var saved := SaveGame.save_player(player_state, save_path)
	_update_load_game_button()
	return saved

func _update_load_game_button() -> void:
	if is_instance_valid(load_game_button):
		var result := SaveGame.load_player(CombatRules.create_default_player(), save_path)
		load_game_button.disabled = not bool(result.get("success", false))

func _show_new_game_view() -> void:
	dungeon_exit_pending = false
	main_menu_view.visible = false
	new_game_view.visible = true
	dungeon_explore_view.visible = false
	monster_encounter_view.visible = false
	if is_instance_valid(monster_info_modal):
		monster_info_modal.visible = false
	if is_instance_valid(level_allocation_view):
		level_allocation_view.visible = false
	if is_instance_valid(settings_view):
		settings_view.visible = false
	_update_progression_indicator()

func _show_main_menu_view() -> void:
	dungeon_exit_pending = false
	main_menu_view.visible = true
	new_game_view.visible = false
	dungeon_explore_view.visible = false
	monster_encounter_view.visible = false
	if is_instance_valid(monster_info_modal):
		monster_info_modal.visible = false
	if is_instance_valid(level_allocation_view):
		level_allocation_view.visible = false
	if is_instance_valid(settings_view):
		settings_view.visible = false
	_update_load_game_button()

func _show_settings_view() -> void:
	main_menu_view.visible = false
	new_game_view.visible = false
	dungeon_explore_view.visible = false
	monster_encounter_view.visible = false
	level_allocation_view.visible = false
	settings_view.visible = true
	_update_settings_view()

func _select_locale(locale: String) -> void:
	if not SettingsStore.save_locale(locale, settings_path):
		return
	TranslationServer.set_locale(locale)
	_apply_menu_text()
	_update_settings_view()

func _update_settings_view() -> void:
	if not is_instance_valid(settings_english_button) or not is_instance_valid(settings_spanish_button):
		return
	var locale := TranslationServer.get_locale()
	settings_english_button.disabled = locale == LOCALE_ENGLISH
	settings_spanish_button.disabled = locale == LOCALE_SPANISH

func start_dungeon_exploration(dungeon_type: int = 1) -> void:
	dungeon_exit_pending = false
	CombatRules.begin_dungeon_experience(player_state)
	dungeon = DungeonGenerator.create_dungeon(dungeon_type, null, int(player_state.get("level", 1)))
	current_location = DungeonGenerator.get_entrance(dungeon)
	previous_location = {}
	active_monster_location = {}
	_clear_feedback()
	_mark_visible_locations()
	_render_map()
	_update_direction_buttons()
	_update_exploration_actions()
	_show_dungeon_explore_view()

func get_valid_directions() -> Dictionary:
	if current_location.is_empty():
		return {}

	var directions := {
		"left": Vector2i(-1, 0),
		"right": Vector2i(1, 0),
		"up": Vector2i(0, -1),
		"down": Vector2i(0, 1),
	}
	var valid: Dictionary = {}

	for direction: String in directions:
		var offset: Vector2i = directions[direction]
		var target: Dictionary = DungeonGenerator.get_location(
			dungeon,
			int(current_location["column"]) + offset.x,
			int(current_location["row"]) + offset.y
		)

		if _can_move_to(target):
			valid[direction] = target

	return valid

func move_player(direction: String) -> void:
	if dungeon_exit_pending:
		return
	var valid_directions := get_valid_directions()
	if not valid_directions.has(direction):
		return

	previous_location = current_location
	CombatRules.consume_movement_energy(player_state)
	current_location = valid_directions[direction]
	var was_visited := bool(current_location.get("visited", false))
	current_location["visible"] = true
	current_location["show"] = true
	_mark_visible_locations()

	if not was_visited:
		_apply_current_location_effect()

	_render_map()
	_update_direction_buttons()
	_update_exploration_actions()
	_apply_player_stats()

	if _exit_dungeon_if_player_depleted():
		return

	if DungeonGenerator.is_monster_alive(current_location):
		_show_monster_encounter(current_location)

func _show_dungeon_explore_view() -> void:
	main_menu_view.visible = false
	new_game_view.visible = false
	dungeon_explore_view.visible = true
	monster_encounter_view.visible = false
	if is_instance_valid(monster_info_modal):
		monster_info_modal.visible = false
	if is_instance_valid(level_allocation_view):
		level_allocation_view.visible = false
	_update_exploration_actions()

func _show_monster_encounter(location: Dictionary) -> void:
	active_monster_location = location
	_ensure_active_monster_max_stats()
	_update_monster_encounter()
	explore_feedback.text = ""
	encounter_feedback.text = ""
	_clear_roll_displays()
	_update_monster_info_button()
	main_menu_view.visible = false
	new_game_view.visible = false
	dungeon_explore_view.visible = false
	monster_encounter_view.visible = true
	if is_instance_valid(level_allocation_view):
		level_allocation_view.visible = false

func _can_move_to(location: Dictionary) -> bool:
	if location.is_empty() or location.get("type") == DungeonGenerator.LOCATION_BLOCK:
		return false
	return true

func _mark_visible_locations() -> void:
	for location: Dictionary in dungeon.get("locations", []):
		location["canVisit"] = false
		var column_distance: int = abs(int(current_location["column"]) - int(location["column"]))
		var row_distance: int = abs(int(current_location["row"]) - int(location["row"]))

		if column_distance <= 1 and row_distance <= 1:
			location["visible"] = true

		if (column_distance == 1 and row_distance == 0) or (column_distance == 0 and row_distance == 1):
			location["show"] = true
			location["canVisit"] = _can_move_to(location)

	current_location["visible"] = true
	if current_location.get("type") != DungeonGenerator.LOCATION_MONSTER and current_location.get("type") != DungeonGenerator.LOCATION_QUEST and current_location.get("type") != DungeonGenerator.LOCATION_SANCTUARY:
		current_location["visited"] = true

func _render_map() -> void:
	for child: Node in map_grid.get_children():
		map_grid.remove_child(child)
		child.free()
	map_cells.clear()

	var window := _get_map_window()
	map_grid.columns = int(window["columns"])
	var cell_size := _get_map_cell_size()

	for row in range(int(window["start_row"]), int(window["end_row"]) + 1):
		for column in range(int(window["start_column"]), int(window["end_column"]) + 1):
			var location: Dictionary = DungeonGenerator.get_location(dungeon, column, row)
			var cell := Control.new()
			cell.custom_minimum_size = Vector2(cell_size, cell_size)
			var background := ColorRect.new()
			background.color = _get_location_color(location)
			background.set_anchors_preset(Control.PRESET_FULL_RECT)
			cell.add_child(background)
			var icon_path := _get_location_icon_path(location)
			if icon_path != "":
				var icon := TextureRect.new()
				icon.name = "LocationIcon"
				icon.texture = load(icon_path)
				icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
				icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
				icon.custom_minimum_size = Vector2(maxi(10, cell_size - 8), maxi(10, cell_size - 8))
				icon.set_anchors_preset(Control.PRESET_FULL_RECT)
				cell.add_child(icon)
			map_grid.add_child(cell)
			map_cells.append(cell)

func _get_map_cell_size() -> int:
	var columns: int = mini(int(dungeon["number_of_columns"]), MAP_VIEW_COLUMNS)
	var rows: int = mini(int(dungeon["number_of_rows"]), MAP_VIEW_ROWS)
	var viewport_size := get_viewport_rect().size
	var available_width: float = maxf(viewport_size.x - 40.0, 280.0)
	var available_height: float = maxf(viewport_size.y * 0.52, 280.0)
	var width_cell_size: int = int(available_width / float(columns))
	var height_cell_size: int = int(available_height / float(rows))
	return clampi(mini(width_cell_size, height_cell_size), 10, 56)

func _get_location_color(location: Dictionary) -> Color:
	if location.is_empty() or not bool(location.get("visible", false)):
		return Color(0.02, 0.02, 0.02, 1.0)
	if location["type"] == DungeonGenerator.LOCATION_ENTRANCE:
		return Color(0.2, 0.7, 0.38, 1.0)
	if int(location["column"]) == int(current_location["column"]) and int(location["row"]) == int(current_location["row"]):
		return Color(0.95, 0.82, 0.28, 1.0)
	if bool(location.get("visited", false)):
		return Color(0.38, 0.38, 0.38, 1.0)
	if location["type"] == DungeonGenerator.LOCATION_MONSTER:
		return Color(0.65, 0.16, 0.16, 1.0)
	if location["type"] == DungeonGenerator.LOCATION_BLOCK:
		return Color(0.08, 0.08, 0.08, 1.0)
	if location["type"] == DungeonGenerator.LOCATION_SANCTUARY:
		return Color(0.2, 0.7, 0.38, 1.0)
	if location["type"] == DungeonGenerator.LOCATION_QUEST:
		return Color(0.45, 0.32, 0.72, 1.0)
	return Color(0.24, 0.2, 0.16, 1.0)

func _update_direction_buttons() -> void:
	var valid := get_valid_directions()
	move_up_button.visible = true
	move_down_button.visible = true
	move_left_button.visible = true
	move_right_button.visible = true
	move_left_button.disabled = not valid.has("left")
	move_right_button.disabled = not valid.has("right")
	move_up_button.disabled = not valid.has("up")
	move_down_button.disabled = not valid.has("down")

func _update_monster_encounter() -> void:
	var monster := active_monster_location.get("content", {}) as Dictionary
	monster_image.visible = false
	encounter_player_image.visible = false
	monster_image_asset.texture = load(_get_monster_asset_path(monster))
	monster_image.text = String(monster.get("image", "Monster"))
	monster_name.text = "%s Lv. %s" % [String(monster.get("name", "Monster")), str(int(monster.get("level", 1)))]
	monster_stats.visible = false
	encounter_player_stats.visible = false
	_populate_stat_bars(monster_stat_bars, MONSTER_STATS, _normalize_monster_stat_source(monster), true)
	var encounter_stats := PLAYER_STATS.duplicate(true)
	encounter_stats.append({"name": "DungeonExperience", "key": "dungeon_experience", "label_key": "STAT_DUNGEON_EXPERIENCE"})
	_populate_stat_bars(encounter_player_stat_bars, encounter_stats, player_state, true)
	_update_monster_info_button()

func _fight() -> void:
	if active_monster_location.is_empty() or dungeon_exit_pending:
		return
	var previous_life := int(player_state.get("current_life", 0))
	var result: Dictionary = CombatRules.attack_monster(player_state, active_monster_location, next_attack_roll, next_dodge_roll, next_counter_roll, next_player_dodge_roll)
	next_attack_roll = -1.0
	next_counter_roll = -1.0
	next_dodge_roll = -1.0
	next_player_dodge_roll = -1.0
	encounter_feedback.text = _format_combat_feedback(result)
	_update_roll_displays(result)
	_apply_player_stats()

	if _exit_dungeon_if_player_depleted():
		return

	if int(player_state.get("current_life", 0)) < previous_life:
		_show_damage_overlay(tr(String(result.get("message_key", "COMBAT_COUNTERATTACK_HIT"))))

	if bool(result.get("monster_defeated", false)):
		var experience_gained := int(result.get("experience_gained", 0))
		active_monster_location = {}
		_render_map()
		_update_direction_buttons()
		if _complete_dungeon_if_ready(experience_gained):
			return
		_show_dungeon_explore_view()
		explore_feedback.text = ""
		_show_experience_overlay(experience_gained)
		return
	_update_monster_encounter()

func _apply_current_location_effect() -> void:
	if current_location.get("type") == DungeonGenerator.LOCATION_SANCTUARY:
		var result: Dictionary = CombatRules.apply_sanctuary(player_state, current_location)
		explore_feedback.text = tr(String(result.get("message_key", "COMBAT_SANCTUARY")))

func _rest() -> void:
	if dungeon_exit_pending:
		return
	var result: Dictionary = CombatRules.rest(player_state)
	explore_feedback.text = tr(String(result.get("message_key", "COMBAT_REST")))
	_apply_player_stats()
	if _exit_dungeon_if_player_depleted():
		return
	if not active_monster_location.is_empty():
		_update_monster_encounter()

func _collect_treasure() -> void:
	if dungeon_exit_pending or current_location.is_empty() or current_location.get("type") != DungeonGenerator.LOCATION_QUEST or bool(current_location.get("visited", false)):
		return
	var previous_life := int(player_state.get("current_life", 0))
	var result: Dictionary = CombatRules.resolve_quest(player_state, current_location, next_quest_roll)
	next_quest_roll = -1.0
	explore_feedback.text = tr(String(result.get("message_key", "COMBAT_QUEST_TRAP")))
	_render_map()
	_update_direction_buttons()
	_update_exploration_actions()
	_apply_player_stats()

	if _exit_dungeon_if_player_depleted():
		return
	if int(player_state.get("current_life", 0)) < previous_life:
		_show_damage_overlay(tr(String(result.get("message_key", "COMBAT_QUEST_TRAP"))))

func _exit_dungeon_if_player_depleted() -> bool:
	if int(player_state.get("current_life", 0)) > 0 and int(player_state.get("current_energy", 0)) > 0:
		return false
	if dungeon_exit_pending:
		return true

	if int(player_state.get("current_life", 0)) <= 0:
		var death_result := CombatRules.apply_death_sequel(player_state)
		_persist_player_state()
		pending_game_result_title = tr(RESULT_GAME_OVER_TITLE_KEY) if bool(death_result.get("save_deleted", false)) else tr(RESULT_DEFEAT_TITLE_KEY)
		pending_game_result_message = "%s\n%s" % [tr(DUNGEON_LIFE_DEPLETED_KEY), tr(String(death_result.get("message_key", "COMBAT_DEATH_SEQUEL")))]
		_begin_depleted_dungeon_exit(tr(DUNGEON_LIFE_DEPLETED_KEY), tr(String(death_result.get("message_key", "COMBAT_DEATH_SEQUEL"))))
	else:
		CombatRules.discard_dungeon_experience(player_state)
		CombatRules.restore_status_after_alive_exit(player_state)
		_persist_player_state()
		pending_game_result_title = tr(RESULT_ENDED_TITLE_KEY)
		pending_game_result_message = tr(DUNGEON_ENERGY_DEPLETED_KEY)
		_begin_depleted_dungeon_exit(tr(DUNGEON_ENERGY_DEPLETED_KEY), "")
	return true

func _begin_depleted_dungeon_exit(message: String, secondary_message: String) -> void:
	dungeon_exit_pending = true
	move_left_button.disabled = true
	move_right_button.disabled = true
	move_up_button.disabled = true
	move_down_button.disabled = true
	rest_button.disabled = true
	retreat_button.disabled = true
	collect_treasure_button.disabled = true
	fight_button.disabled = true
	flee_button.disabled = true
	var full_message := message
	if secondary_message != "":
		full_message = "%s\n%s" % [message, secondary_message]
	_show_feedback_overlay(full_message, DAMAGE_FEEDBACK_ASSET, Callable(self, "_finish_depleted_dungeon_exit"))

func _finish_depleted_dungeon_exit() -> void:
	dungeon = {}
	current_location = {}
	previous_location = {}
	active_monster_location = {}
	_clear_feedback()
	if bool(player_state.get("save_deleted", false)):
		player_state = CombatRules.create_default_player()
		_apply_player_stats()
		_show_main_menu_view()
		_show_game_result(pending_game_result_title, pending_game_result_message)
		fight_button.disabled = false
		flee_button.disabled = false
		return
	_apply_player_stats()
	_show_new_game_view()
	_show_game_result(pending_game_result_title, pending_game_result_message)
	fight_button.disabled = false
	flee_button.disabled = false

func _clear_feedback() -> void:
	if is_instance_valid(explore_feedback):
		explore_feedback.text = ""
	if is_instance_valid(encounter_feedback):
		encounter_feedback.text = ""

func _get_player_current_stat(stat_name: String) -> int:
	if stat_name == "experience":
		return int(player_state.get("current_experience", 0))
	if stat_name == "dungeon_experience":
		return int(player_state.get("dungeon_experience", 0))
	return int(player_state.get("current_%s" % stat_name, player_state.get(stat_name, 0)))

func _get_player_max_stat(stat_name: String) -> int:
	if stat_name == "experience" or stat_name == "dungeon_experience":
		return int(player_state.get("experience_next_level", 1))
	return int(player_state.get(stat_name, 1))

func _build_runtime_ui() -> void:
	_add_character_portrait()
	_add_progression_indicator()
	exploration_stats_container = VBoxContainer.new()
	exploration_stats_container.name = "ExplorationStats"
	exploration_stats_container.custom_minimum_size = Vector2(312, 110)
	exploration_stats_container.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	exploration_stats_container.add_theme_constant_override("separation", 4)
	$DungeonExploreView/ExploreActions/ExploreActionStack.add_child(exploration_stats_container)

	collect_treasure_button = Button.new()
	collect_treasure_button.name = "CollectTreasureButton"
	collect_treasure_button.custom_minimum_size = Vector2(312, 44)
	collect_treasure_button.add_theme_font_size_override("font_size", 18)
	$DungeonExploreView/ExploreActions/ExploreActionStack/ExploreSecondaryActions.add_child(collect_treasure_button)

	monster_image_asset = _add_texture_child(monster_image.get_parent(), "MonsterImageAsset", FALLBACK_MONSTER_ASSET)
	encounter_player_asset = _add_texture_child(encounter_player_image.get_parent(), "EncounterPlayerAsset", CHARACTER_ASSET)
	monster_image.get_parent().move_child(monster_image_asset, monster_image.get_parent().get_child_count() - 1)
	encounter_player_image.get_parent().move_child(encounter_player_asset, 0)
	_add_monster_info_button()
	monster_stat_bars = VBoxContainer.new()
	monster_stat_bars.name = "MonsterStatBars"
	monster_stat_bars.add_theme_constant_override("separation", 4)
	monster_stats.get_parent().add_child(monster_stat_bars)
	monster_roll_display = _create_roll_display("MonsterRollDisplay")
	monster_stats.get_parent().add_child(monster_roll_display)
	encounter_player_stat_bars = VBoxContainer.new()
	encounter_player_stat_bars.name = "EncounterPlayerStatBars"
	encounter_player_stat_bars.add_theme_constant_override("separation", 4)
	encounter_player_stats.get_parent().add_child(encounter_player_stat_bars)
	player_roll_display = _create_roll_display("PlayerRollDisplay")
	encounter_player_stats.get_parent().add_child(player_roll_display)
	_add_damage_overlay()
	_add_monster_info_modal()
	_add_level_allocation_view()
	_add_settings_view()
	_add_action_confirmation()
	_add_game_result_modal()

func _add_action_confirmation() -> void:
	action_confirmation = ConfirmationDialog.new()
	action_confirmation.name = "ActionConfirmation"
	action_confirmation.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_PRIMARY_SCREEN
	action_confirmation.confirmed.connect(Callable(self, "_confirm_pending_action"))
	action_confirmation.canceled.connect(Callable(self, "_cancel_pending_action"))
	add_child(action_confirmation)

func _add_game_result_modal() -> void:
	game_result_modal = ColorRect.new()
	game_result_modal.name = "GameResultModal"
	game_result_modal.color = Color(0.025, 0.02, 0.018, 0.96)
	game_result_modal.visible = false
	game_result_modal.mouse_filter = Control.MOUSE_FILTER_STOP
	game_result_modal.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(game_result_modal)

	var panel := VBoxContainer.new()
	panel.name = "ResultPanel"
	panel.anchor_left = 0.10
	panel.anchor_top = 0.25
	panel.anchor_right = 0.90
	panel.anchor_bottom = 0.75
	panel.add_theme_constant_override("separation", 18)
	game_result_modal.add_child(panel)

	game_result_title = Label.new()
	game_result_title.name = "Title"
	game_result_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	game_result_title.add_theme_font_size_override("font_size", 28)
	panel.add_child(game_result_title)

	game_result_message = Label.new()
	game_result_message.name = "Message"
	game_result_message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	game_result_message.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	game_result_message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	game_result_message.add_theme_font_size_override("font_size", 18)
	game_result_message.size_flags_vertical = Control.SIZE_EXPAND_FILL
	panel.add_child(game_result_message)

	game_result_continue_button = Button.new()
	game_result_continue_button.name = "ContinueButton"
	game_result_continue_button.custom_minimum_size = Vector2(248, 46)
	game_result_continue_button.pressed.connect(Callable(self, "_hide_game_result"))
	panel.add_child(game_result_continue_button)

func _show_game_result(title: String, message: String) -> void:
	game_result_title.text = title
	game_result_message.text = message
	game_result_modal.visible = true

func _hide_game_result() -> void:
	game_result_modal.visible = false

func _add_settings_view() -> void:
	settings_view = Control.new()
	settings_view.name = "SettingsView"
	settings_view.visible = false
	settings_view.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(settings_view)

	var background := ColorRect.new()
	background.name = "Background"
	background.color = Color(0.05, 0.04, 0.035, 1.0)
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	settings_view.add_child(background)

	var panel := VBoxContainer.new()
	panel.name = "SettingsPanel"
	panel.anchor_left = 0.12
	panel.anchor_top = 0.18
	panel.anchor_right = 0.88
	panel.anchor_bottom = 0.82
	panel.add_theme_constant_override("separation", 14)
	settings_view.add_child(panel)

	settings_title = Label.new()
	settings_title.name = "Title"
	settings_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	settings_title.add_theme_font_size_override("font_size", 26)
	panel.add_child(settings_title)

	settings_language_label = Label.new()
	settings_language_label.name = "LanguageLabel"
	settings_language_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	settings_language_label.add_theme_font_size_override("font_size", 18)
	panel.add_child(settings_language_label)

	settings_english_button = Button.new()
	settings_english_button.name = "EnglishButton"
	settings_english_button.custom_minimum_size = Vector2(248, 46)
	settings_english_button.pressed.connect(Callable(self, "_select_locale").bind(LOCALE_ENGLISH))
	panel.add_child(settings_english_button)

	settings_spanish_button = Button.new()
	settings_spanish_button.name = "SpanishButton"
	settings_spanish_button.custom_minimum_size = Vector2(248, 46)
	settings_spanish_button.pressed.connect(Callable(self, "_select_locale").bind(LOCALE_SPANISH))
	panel.add_child(settings_spanish_button)

	settings_back_button = Button.new()
	settings_back_button.name = "BackButton"
	settings_back_button.custom_minimum_size = Vector2(248, 46)
	settings_back_button.pressed.connect(Callable(self, "_show_main_menu_view"))
	panel.add_child(settings_back_button)
	_update_settings_view()

func _add_character_portrait() -> void:
	character_placeholder.visible = false
	character_portrait = _add_texture_child(character_placeholder.get_parent(), "CharacterPortrait", CHARACTER_ASSET)

func _add_progression_indicator() -> void:
	progression_indicator = Panel.new()
	progression_indicator.name = "ProgressionPendingIndicator"
	progression_indicator.custom_minimum_size = Vector2(12, 12)
	progression_indicator.mouse_filter = Control.MOUSE_FILTER_IGNORE
	progression_indicator.anchor_left = 1.0
	progression_indicator.anchor_right = 1.0
	progression_indicator.anchor_top = 0.0
	progression_indicator.anchor_bottom = 0.0
	progression_indicator.offset_left = -14
	progression_indicator.offset_right = -2
	progression_indicator.offset_top = 2
	progression_indicator.offset_bottom = 14
	var indicator_style := StyleBoxFlat.new()
	indicator_style.bg_color = Color(0.9, 0.05, 0.05, 1.0)
	indicator_style.corner_radius_top_left = 6
	indicator_style.corner_radius_top_right = 6
	indicator_style.corner_radius_bottom_left = 6
	indicator_style.corner_radius_bottom_right = 6
	progression_indicator.add_theme_stylebox_override("panel", indicator_style)
	progression_indicator.visible = false
	manage_equipment_button.tooltip_text = tr(PROGRESSION_PENDING_KEY)
	manage_equipment_button.add_child(progression_indicator)

func _update_progression_indicator() -> void:
	if not is_instance_valid(progression_indicator):
		return
	progression_indicator.visible = int(player_state.get("reserved_progression_points", player_state.get("pending_level_points", 0))) > 0

func _add_texture_child(parent: Node, node_name: String, texture_path: String) -> TextureRect:
	var texture_rect := TextureRect.new()
	texture_rect.name = node_name
	texture_rect.texture = load(texture_path)
	texture_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	texture_rect.custom_minimum_size = Vector2(132, 180)
	texture_rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	texture_rect.size_flags_vertical = Control.SIZE_EXPAND_FILL
	parent.add_child(texture_rect)
	return texture_rect

func _add_monster_info_button() -> void:
	monster_info_button = Button.new()
	monster_info_button.name = "MonsterInfoButton"
	monster_info_button.text = tr(MONSTER_INFO_KEY)
	monster_info_button.custom_minimum_size = Vector2(34, 34)
	monster_info_button.anchor_left = 1.0
	monster_info_button.anchor_right = 1.0
	monster_info_button.anchor_top = 0.0
	monster_info_button.anchor_bottom = 0.0
	monster_info_button.offset_left = -40
	monster_info_button.offset_right = -6
	monster_info_button.offset_top = 6
	monster_info_button.offset_bottom = 40
	monster_info_button.add_theme_stylebox_override("normal", _create_circular_button_style(Color(0.11, 0.13, 0.16, 1.0)))
	monster_info_button.add_theme_stylebox_override("hover", _create_circular_button_style(Color(0.18, 0.21, 0.26, 1.0)))
	monster_info_button.add_theme_stylebox_override("pressed", _create_circular_button_style(Color(0.07, 0.09, 0.12, 1.0)))
	monster_info_button.add_theme_stylebox_override("disabled", _create_circular_button_style(Color(0.11, 0.13, 0.16, 0.55)))
	monster_info_button.visible = false
	monster_info_button.pressed.connect(Callable(self, "_show_monster_info"))
	monster_image_asset.add_child(monster_info_button)

func _add_monster_info_modal() -> void:
	monster_info_modal = ColorRect.new()
	monster_info_modal.name = "MonsterInfoModal"
	monster_info_modal.color = Color(0.04, 0.035, 0.03, 1.0)
	monster_info_modal.visible = false
	monster_info_modal.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(monster_info_modal)

	var panel := VBoxContainer.new()
	panel.name = "Panel"
	panel.anchor_left = 0.08
	panel.anchor_top = 0.18
	panel.anchor_right = 0.92
	panel.anchor_bottom = 0.82
	panel.add_theme_constant_override("separation", 10)
	monster_info_modal.add_child(panel)

	var title := Label.new()
	title.name = "Title"
	title.text = tr(MONSTER_ATTACKS_TITLE_KEY)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 20)
	panel.add_child(title)

	monster_info_text = Label.new()
	monster_info_text.name = "AttackList"
	monster_info_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	monster_info_text.add_theme_font_size_override("font_size", 14)
	panel.add_child(monster_info_text)

	var close_button := Button.new()
	close_button.name = "CloseButton"
	close_button.text = "OK"
	close_button.custom_minimum_size = Vector2(180, 38)
	close_button.pressed.connect(Callable(self, "_hide_monster_info"))
	panel.add_child(close_button)

func _create_circular_button_style(color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.corner_radius_top_left = 17
	style.corner_radius_top_right = 17
	style.corner_radius_bottom_left = 17
	style.corner_radius_bottom_right = 17
	style.content_margin_left = 0
	style.content_margin_right = 0
	style.content_margin_top = 0
	style.content_margin_bottom = 0
	return style

func _add_damage_overlay() -> void:
	damage_overlay = ColorRect.new()
	damage_overlay.name = "DamageOverlay"
	damage_overlay.color = Color(0, 0, 0, 0.72)
	damage_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	damage_overlay.visible = false
	damage_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(damage_overlay)

	damage_overlay_icon = TextureRect.new()
	damage_overlay_icon.name = "DamageOverlayIcon"
	damage_overlay_icon.texture = load(DAMAGE_FEEDBACK_ASSET)
	damage_overlay_icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	damage_overlay_icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	damage_overlay_icon.custom_minimum_size = Vector2(176, 176)
	damage_overlay_icon.anchor_left = 0.5
	damage_overlay_icon.anchor_top = 0.5
	damage_overlay_icon.anchor_right = 0.5
	damage_overlay_icon.anchor_bottom = 0.5
	damage_overlay_icon.offset_left = -88
	damage_overlay_icon.offset_top = -112
	damage_overlay_icon.offset_right = 88
	damage_overlay_icon.offset_bottom = 64
	damage_overlay.add_child(damage_overlay_icon)

	damage_overlay_text = Label.new()
	damage_overlay_text.name = "DamageOverlayText"
	damage_overlay_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	damage_overlay_text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	damage_overlay_text.add_theme_font_size_override("font_size", 22)
	damage_overlay_text.anchor_left = 0.0
	damage_overlay_text.anchor_top = 0.78
	damage_overlay_text.anchor_right = 1.0
	damage_overlay_text.anchor_bottom = 0.9
	damage_overlay_text.offset_left = 24
	damage_overlay_text.offset_right = -24
	damage_overlay.add_child(damage_overlay_text)

func _add_level_allocation_view() -> void:
	level_allocation_view = Control.new()
	level_allocation_view.name = "LevelAllocationView"
	level_allocation_view.visible = false
	level_allocation_view.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(level_allocation_view)

	var background := ColorRect.new()
	background.name = "Background"
	background.color = Color(0.05, 0.04, 0.035, 1.0)
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	level_allocation_view.add_child(background)

	var panel := VBoxContainer.new()
	panel.name = "AllocationPanel"
	panel.anchor_left = 0.08
	panel.anchor_top = 0.10
	panel.anchor_right = 0.92
	panel.anchor_bottom = 0.92
	panel.add_theme_constant_override("separation", 10)
	level_allocation_view.add_child(panel)

	var title := Label.new()
	title.name = "Title"
	title.text = tr(ALLOCATION_TITLE_KEY)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 24)
	panel.add_child(title)

	allocation_remaining_label = Label.new()
	allocation_remaining_label.name = "RemainingPoints"
	allocation_remaining_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	allocation_remaining_label.add_theme_font_size_override("font_size", 16)
	panel.add_child(allocation_remaining_label)

	allocation_buttons_container = VBoxContainer.new()
	allocation_buttons_container.name = "StatButtons"
	allocation_buttons_container.add_theme_constant_override("separation", 6)
	panel.add_child(allocation_buttons_container)

	class_choice_container = VBoxContainer.new()
	class_choice_container.name = "ClassChoices"
	class_choice_container.add_theme_constant_override("separation", 6)
	panel.add_child(class_choice_container)

	allocation_confirm_button = Button.new()
	allocation_confirm_button.name = "ConfirmAllocationButton"
	allocation_confirm_button.text = tr(ALLOCATION_CONFIRM_KEY)
	allocation_confirm_button.custom_minimum_size = Vector2(260, 42)
	allocation_confirm_button.pressed.connect(Callable(self, "_confirm_level_allocation"))
	panel.add_child(allocation_confirm_button)

	var back_button := Button.new()
	back_button.name = "BackButton"
	back_button.text = tr(ALLOCATION_BACK_KEY)
	back_button.custom_minimum_size = Vector2(260, 42)
	back_button.pressed.connect(Callable(self, "_show_new_game_view"))
	panel.add_child(back_button)

func _populate_stat_bars(container: Control, stats: Array, source: Dictionary, compact: bool) -> void:
	for child: Node in container.get_children():
		container.remove_child(child)
		child.free()
	for stat: Dictionary in stats:
		container.add_child(_create_stat_bar(stat, source, compact))

func _create_stat_bar(stat: Dictionary, source: Dictionary, compact: bool) -> HBoxContainer:
	var stat_key := String(stat["key"])
	var current: int = _get_current_stat(source, stat_key)
	var maximum: int = max(1, _get_max_stat(source, stat_key))
	var clamped_current: int = clampi(current, 0, maximum)
	var stat_color := _get_stat_color(stat_key)
	var row := HBoxContainer.new()
	row.name = "%sStatBar" % String(stat["name"])
	row.custom_minimum_size = Vector2(0, 22)
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_theme_constant_override("separation", 6)
	var icon := TextureRect.new()
	icon.name = "Icon"
	icon.texture = load(String(STAT_ICON_PATHS.get(stat_key, STAT_ICON_PATHS["life"])))
	icon.modulate = stat_color
	icon.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.custom_minimum_size = Vector2(18, 18)
	row.add_child(icon)
	if stat.has("label_key"):
		var stat_label := Label.new()
		stat_label.name = "Label"
		stat_label.text = tr(String(stat["label_key"]))
		stat_label.custom_minimum_size = Vector2(72 if compact else 92, 0)
		stat_label.add_theme_font_size_override("font_size", 10 if compact else 11)
		stat_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		row.add_child(stat_label)
	var bar := ProgressBar.new()
	bar.name = "Bar"
	bar.show_percentage = false
	bar.max_value = maximum
	bar.value = clamped_current
	bar.custom_minimum_size = Vector2(82 if compact else 96, 22)
	bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bar.add_theme_stylebox_override("fill", _create_stat_stylebox(stat_color))
	bar.add_theme_stylebox_override("background", _create_stat_stylebox(Color(0.07, 0.07, 0.07, 1.0)))
	var value := Label.new()
	value.name = "Value"
	value.text = "%s/%s" % [str(maxi(0, current)), str(maximum)]
	value.add_theme_font_size_override("font_size", 11 if compact else 12)
	value.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	value.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	value.set_anchors_preset(Control.PRESET_FULL_RECT)
	bar.add_child(value)
	row.add_child(bar)
	return row

func _create_stat_stylebox(color: Color) -> StyleBoxFlat:
	var stylebox := StyleBoxFlat.new()
	stylebox.bg_color = color
	stylebox.corner_radius_top_left = 3
	stylebox.corner_radius_top_right = 3
	stylebox.corner_radius_bottom_left = 3
	stylebox.corner_radius_bottom_right = 3
	return stylebox

func _get_stat_color(stat_key: String) -> Color:
	return Color.html(String(STAT_COLORS.get(stat_key, "#e5e7eb")))

func _get_current_stat(source: Dictionary, stat_name: String) -> int:
	if stat_name == "experience":
		return int(source.get("current_experience", 0))
	if stat_name == "dungeon_experience":
		return int(source.get("dungeon_experience", 0))
	return int(source.get("current_%s" % stat_name, source.get(stat_name, 0)))

func _get_max_stat(source: Dictionary, stat_name: String) -> int:
	if stat_name == "experience" or stat_name == "dungeon_experience":
		return int(source.get("experience_next_level", 1))
	return int(source.get(stat_name, 1))

func _show_level_allocation_view() -> void:
	CombatRules.convert_available_level_ups(player_state)
	staged_allocation = {}
	for stat_variant: Variant in CombatRules.STAT_GROWTH.keys():
		staged_allocation[String(stat_variant)] = 0
	main_menu_view.visible = false
	new_game_view.visible = false
	dungeon_explore_view.visible = false
	monster_encounter_view.visible = false
	level_allocation_view.visible = true
	_update_progression_indicator()
	_update_level_allocation_view()

func _get_staged_points() -> int:
	var total: int = 0
	for stat_variant: Variant in CombatRules.STAT_GROWTH.keys():
		total += int(staged_allocation.get(String(stat_variant), 0))
	return total

func _stage_level_point(stat_key: String) -> void:
	_stage_level_point_delta(stat_key, 1)

func _stage_level_point_delta(stat_key: String, delta: int) -> void:
	var reserved_points: int = int(player_state.get("reserved_progression_points", player_state.get("pending_level_points", 0)))
	if reserved_points <= 0:
		return
	var current_staged: int = int(staged_allocation.get(stat_key, 0))
	if delta > 0 and _get_staged_points() >= reserved_points:
		return
	if delta < 0 and current_staged <= 0:
		return
	staged_allocation[stat_key] = maxi(0, current_staged + delta)
	_update_level_allocation_view()

func _confirm_level_allocation() -> void:
	var result: Dictionary = CombatRules.confirm_level_allocation(player_state, staged_allocation, not dungeon.is_empty())
	if not bool(result.get("confirmed", false)):
		return
	staged_allocation = {}
	_persist_player_state()
	_apply_player_stats()
	_show_new_game_view()

func _update_level_allocation_view() -> void:
	var reserved_points: int = int(player_state.get("reserved_progression_points", player_state.get("pending_level_points", 0)))
	var remaining: int = maxi(0, reserved_points - _get_staged_points())
	if reserved_points <= 0:
		allocation_remaining_label.text = tr(ALLOCATION_NO_POINTS_KEY)
	else:
		allocation_remaining_label.text = tr(ALLOCATION_REMAINING_KEY) % str(remaining)
	_rebuild_allocation_rows(reserved_points, remaining)
	_rebuild_class_choices()
	allocation_confirm_button.disabled = reserved_points <= 0 or _get_staged_points() <= 0

func _rebuild_allocation_rows(reserved_points: int, remaining: int) -> void:
	for child: Node in allocation_buttons_container.get_children():
		if child is CanvasItem:
			(child as CanvasItem).visible = false
		child.queue_free()
	for stat_key in ["life", "energy", "mana", "armor", "speed", "strength"]:
		allocation_buttons_container.add_child(_create_allocation_row(stat_key, reserved_points, remaining))

func _create_allocation_row(stat_key: String, reserved_points: int, remaining: int) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.name = "%sAllocationRow" % stat_key.capitalize()
	row.custom_minimum_size = Vector2(0, 36)
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_theme_constant_override("separation", 6)

	var preview_source := _get_allocation_preview_source(stat_key)
	var stat_bar := _create_stat_bar({"name": stat_key.capitalize(), "key": stat_key}, preview_source, true)
	stat_bar.name = "StatPreview"
	stat_bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(stat_bar)

	var points_label := Label.new()
	points_label.name = "PointsLabel"
	points_label.text = "+%s" % str(int(staged_allocation.get(stat_key, 0)))
	points_label.custom_minimum_size = Vector2(32, 24)
	points_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	points_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	row.add_child(points_label)

	var minus_button := Button.new()
	minus_button.name = "MinusButton"
	minus_button.text = "-"
	minus_button.custom_minimum_size = Vector2(36, 30)
	minus_button.disabled = reserved_points <= 0 or int(staged_allocation.get(stat_key, 0)) <= 0
	minus_button.pressed.connect(Callable(self, "_stage_level_point_delta").bind(stat_key, -1), CONNECT_DEFERRED)
	row.add_child(minus_button)

	var plus_button := Button.new()
	plus_button.name = "PlusButton"
	plus_button.text = "+"
	plus_button.custom_minimum_size = Vector2(36, 30)
	plus_button.disabled = reserved_points <= 0 or remaining <= 0
	plus_button.pressed.connect(Callable(self, "_stage_level_point_delta").bind(stat_key, 1), CONNECT_DEFERRED)
	row.add_child(plus_button)
	return row

func _get_allocation_preview_source(stat_key: String) -> Dictionary:
	var source := player_state.duplicate(true)
	var staged_points: int = int(staged_allocation.get(stat_key, 0))
	if staged_points <= 0:
		return source
	var increase: int = CombatRules.get_stat_growth_for_player(player_state, stat_key) * staged_points
	source[stat_key] = int(source.get(stat_key, 0)) + increase
	source["current_%s" % stat_key] = int(source.get("current_%s" % stat_key, player_state.get(stat_key, 0))) + increase
	return source

func _rebuild_class_choices() -> void:
	for child: Node in class_choice_container.get_children():
		if child is CanvasItem:
			(child as CanvasItem).visible = false
		child.queue_free()
	if int(player_state.get("level", 1)) < 10 or String(player_state.get("selected_class", "")) != "":
		class_choice_container.visible = false
		return
	class_choice_container.visible = true
	var title := Label.new()
	title.name = "ClassChoiceTitle"
	title.text = tr(CLASS_CHOICE_TITLE_KEY)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 16)
	class_choice_container.add_child(title)
	for player_class: Dictionary in CombatRules.load_player_classes():
		var button := Button.new()
		button.name = "%sClassButton" % String(player_class.get("id", "class")).capitalize()
		button.text = String(player_class.get("name", player_class.get("id", "Class")))
		button.custom_minimum_size = Vector2(260, 36)
		button.pressed.connect(Callable(self, "_select_player_class").bind(String(player_class.get("id", ""))), CONNECT_DEFERRED)
		class_choice_container.add_child(button)

func _select_player_class(class_id: String) -> void:
	var result: Dictionary = CombatRules.select_player_class(player_state, class_id)
	if bool(result.get("selected", false)):
		_persist_player_state()
		_update_level_allocation_view()

func _normalize_monster_stat_source(monster: Dictionary) -> Dictionary:
	return {
		"life": max(1, int(monster.get("max_life", monster.get("life", 1)))),
		"current_life": int(monster.get("current_life", monster.get("life", 0))),
		"armor": max(1, int(monster.get("armor", 1))),
		"current_armor": int(monster.get("armor", 0)),
		"mana": max(1, int(monster.get("max_mana", monster.get("mana", 1)))),
		"current_mana": int(monster.get("current_mana", monster.get("mana", 0))),
		"speed": max(1, int(monster.get("speed", 1))),
		"current_speed": int(monster.get("current_speed", monster.get("speed", 0))),
		"strength": max(1, int(monster.get("strength", 1))),
		"current_strength": int(monster.get("current_strength", monster.get("strength", 0))),
	}

func _ensure_active_monster_max_stats() -> void:
	if active_monster_location.is_empty() or not active_monster_location.get("content", {}) is Dictionary:
		return
	var monster := active_monster_location["content"] as Dictionary
	if not monster.has("max_life"):
		monster["max_life"] = int(monster.get("life", 0))
	if not monster.has("current_life"):
		monster["current_life"] = int(monster.get("life", monster.get("max_life", 0)))
	if not monster.has("max_mana"):
		monster["max_mana"] = int(monster.get("mana", 0))
	if not monster.has("current_mana"):
		monster["current_mana"] = int(monster.get("mana", monster.get("max_mana", 0)))
	if not monster.has("strength"):
		monster["strength"] = int(monster.get("damage", 1))
	if not monster.has("current_strength"):
		monster["current_strength"] = int(monster.get("strength", 1))
	if not monster.has("speed"):
		monster["speed"] = 3
	if not monster.has("current_speed"):
		monster["current_speed"] = int(monster.get("speed", 3))
	if not monster.has("level"):
		monster["level"] = 1
	active_monster_location["content"] = monster

func _get_location_icon_path(location: Dictionary) -> String:
	if location.is_empty() or not bool(location.get("visible", false)):
		return ""
	return String(LOCATION_ICON_PATHS.get(String(location.get("type", "")), ""))

func _get_monster_asset_path(monster: Dictionary) -> String:
	return String(MONSTER_ASSET_PATHS.get(String(monster.get("name", "")), FALLBACK_MONSTER_ASSET))

func _get_map_window() -> Dictionary:
	var total_columns := int(dungeon["number_of_columns"])
	var total_rows := int(dungeon["number_of_rows"])
	var visible_columns := mini(total_columns, MAP_VIEW_COLUMNS)
	var visible_rows := mini(total_rows, MAP_VIEW_ROWS)
	var half_columns := floori(float(visible_columns) / 2.0)
	var half_rows := floori(float(visible_rows) / 2.0)
	var start_column := clampi(int(current_location.get("column", 1)) - half_columns, 1, maxi(1, total_columns - visible_columns + 1))
	var start_row := clampi(int(current_location.get("row", 1)) - half_rows, 1, maxi(1, total_rows - visible_rows + 1))
	return {
		"start_column": start_column,
		"end_column": start_column + visible_columns - 1,
		"start_row": start_row,
		"end_row": start_row + visible_rows - 1,
		"columns": visible_columns,
		"rows": visible_rows,
	}

func _update_exploration_actions() -> void:
	collect_treasure_button.visible = current_location.get("type") == DungeonGenerator.LOCATION_QUEST and not bool(current_location.get("visited", false))
	collect_treasure_button.disabled = dungeon_exit_pending
	rest_button.disabled = dungeon_exit_pending
	retreat_button.disabled = current_location.get("type") != DungeonGenerator.LOCATION_ENTRANCE

func _retreat() -> void:
	if dungeon_exit_pending:
		return
	if current_location.get("type") != DungeonGenerator.LOCATION_ENTRANCE:
		explore_feedback.text = tr("EXPLORE_RETREAT_ENTRANCE_ONLY")
		return
	var result := CombatRules.retreat_from_entrance(player_state)
	if bool(result.get("depleted", false)):
		_exit_dungeon_if_player_depleted()
		return
	CombatRules.commit_dungeon_experience(player_state)
	dungeon = {}
	current_location = {}
	previous_location = {}
	active_monster_location = {}
	_clear_feedback()
	_persist_player_state()
	_apply_player_stats()
	_show_new_game_view()
	_show_game_result(tr(RESULT_RETREATED_TITLE_KEY), tr(RESULT_RETREATED_MESSAGE_KEY))

func _show_damage_overlay(message: String) -> void:
	_show_feedback_overlay(message, DAMAGE_FEEDBACK_ASSET)

func _show_experience_overlay(experience_gained: int) -> void:
	var message := tr("COMBAT_EXPERIENCE_GAINED_AMOUNT") % str(experience_gained)
	_show_feedback_overlay(message, EXPERIENCE_FEEDBACK_ASSET)

func _show_feedback_overlay(message: String, icon_path: String, after_hidden: Callable = Callable()) -> void:
	damage_overlay_text.text = message
	damage_overlay_icon.texture = load(icon_path)
	damage_overlay.visible = true
	var timer := get_tree().create_timer(0.8)
	timer.timeout.connect(Callable(self, "_hide_damage_overlay").bind(after_hidden))

func _hide_damage_overlay(after_hidden: Callable = Callable()) -> void:
	if is_instance_valid(damage_overlay):
		damage_overlay.visible = false
	if after_hidden.is_valid():
		after_hidden.call()

func _create_roll_display(node_name: String) -> Label:
	var label := Label.new()
	label.name = node_name
	label.text = ""
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 12)
	return label

func _update_roll_displays(_result: Dictionary) -> void:
	_clear_roll_displays()

func _clear_roll_displays() -> void:
	if is_instance_valid(player_roll_display):
		player_roll_display.text = ""
	if is_instance_valid(monster_roll_display):
		monster_roll_display.text = ""

func _complete_dungeon_if_ready(_experience_gained: int) -> bool:
	var total_monsters: int = DungeonGenerator.count_total_monsters(dungeon)
	var defeated_monsters: int = DungeonGenerator.count_defeated_monsters(dungeon)
	dungeon["total_monsters"] = total_monsters
	dungeon["defeated_monsters"] = defeated_monsters
	if total_monsters == 0 or defeated_monsters < total_monsters:
		return false
	dungeon["completed"] = true
	var reputation_gained: int = defeated_monsters
	var experience_gained: int
	if bool(player_state.get("in_dungeon", false)):
		experience_gained = CombatRules.commit_dungeon_experience(player_state, reputation_gained)
	else:
		experience_gained = maxi(0, _experience_gained) + reputation_gained
		player_state["current_experience"] = int(player_state.get("current_experience", 0)) + reputation_gained
	player_state["current_reputation"] = int(player_state.get("current_reputation", 0)) + reputation_gained
	CombatRules.restore_status_after_alive_exit(player_state)
	_persist_player_state()
	dungeon = {}
	current_location = {}
	previous_location = {}
	active_monster_location = {}
	_clear_feedback()
	_apply_player_stats()
	_show_new_game_view()
	_show_game_result(tr(RESULT_COMPLETED_TITLE_KEY), tr("DUNGEON_COMPLETED_REWARDS") % [str(experience_gained), str(reputation_gained)])
	return true

func _move_left() -> void:
	move_player("left")

func _move_up() -> void:
	move_player("up")

func _move_down() -> void:
	move_player("down")

func _move_right() -> void:
	move_player("right")

func _basic_attack() -> void:
	_fight()

func _heavy_attack() -> void:
	_fight()

func _flee_encounter() -> void:
	if active_monster_location.is_empty() or dungeon_exit_pending:
		return
	var previous_life: int = int(player_state.get("current_life", 0))
	var result: Dictionary = CombatRules.attempt_flee(player_state, active_monster_location, next_flee_roll, next_counter_roll, next_player_dodge_roll)
	next_flee_roll = -1.0
	next_counter_roll = -1.0
	next_player_dodge_roll = -1.0
	encounter_feedback.text = _format_flee_feedback(result)
	_update_roll_displays(result)
	_apply_player_stats()

	if _exit_dungeon_if_player_depleted():
		return

	if int(player_state.get("current_life", 0)) < previous_life:
		_show_damage_overlay(tr(String(result.get("message_key", "COMBAT_COUNTERATTACK_HIT"))))

	if bool(result.get("fled", false)):
		active_monster_location = {}
		encounter_feedback.text = ""
		_show_dungeon_explore_view()
		return

	_update_monster_encounter()

func _format_combat_feedback(result: Dictionary) -> String:
	if bool(result.get("insufficient_resources", false)):
		return tr(String(result.get("message_key", "COMBAT_INSUFFICIENT_RESOURCES")))
	var parts: Array[String] = []
	if bool(result.get("critical", false)):
		parts.append("Your attack was a critical hit.")
	elif bool(result.get("hit", false)):
		parts.append("Your attack hit.")
	elif bool(result.get("dodged", false)):
		parts.append("Your attack was dodged.")
	elif bool(result.get("miss", false)):
		parts.append("Your attack was protected.")
	else:
		parts.append("Your attack missed.")

	var monster_attack_name := String(result.get("monster_attack_name", ""))
	if monster_attack_name != "":
		parts.append(_format_monster_attack_feedback(monster_attack_name, result))
	return " ".join(parts)

func _format_flee_feedback(result: Dictionary) -> String:
	if bool(result.get("fled", false)):
		return tr("ENCOUNTER_FLEE_SUCCESS")
	var parts: Array[String] = [tr("ENCOUNTER_FLEE_FAILED")]
	var monster_attack_name := String(result.get("monster_attack_name", ""))
	if monster_attack_name != "":
		parts.append(_format_monster_attack_feedback(monster_attack_name, result))
	return " ".join(parts)

func _format_monster_attack_feedback(attack_name: String, result: Dictionary) -> String:
	if bool(result.get("counterattack_critical", false)):
		return "%s was a critical hit." % attack_name
	if bool(result.get("counterattack_hit", false)):
		return "%s hit you." % attack_name
	if bool(result.get("counterattack_dodged", false)):
		return "%s was dodged." % attack_name
	if bool(result.get("counterattack_miss", false)):
		return "%s was protected." % attack_name
	return "%s missed." % attack_name

func _update_monster_info_button() -> void:
	if not is_instance_valid(monster_info_button):
		return
	monster_info_button.visible = not active_monster_location.is_empty()

func _show_monster_info() -> void:
	if active_monster_location.is_empty() or not is_instance_valid(monster_info_modal):
		return
	var monster := active_monster_location.get("content", {}) as Dictionary
	var attacks: Array = monster.get("attacks", [])
	var lines: Array[String] = []
	for attack_variant: Variant in attacks:
		if not attack_variant is Dictionary:
			continue
		var attack := attack_variant as Dictionary
		var effects: Array = attack.get("effects", [])
		var effect_ids := PackedStringArray()
		for effect_variant: Variant in effects:
			effect_ids.append(String(effect_variant))
		var effect_text := "none" if effect_ids.is_empty() else ", ".join(effect_ids)
		lines.append(tr(MONSTER_ATTACK_LINE_KEY) % [
			String(attack.get("name", "Attack")),
			str(int(attack.get("damage", 0))),
			str(int(attack.get("mana_cost", attack.get("energy_cost", 0)))),
			str(int(attack.get("unlock_level", 1))),
			effect_text,
		])
	if lines.is_empty():
		lines.append("No attacks")
	monster_info_text.text = "\n".join(lines)
	monster_info_modal.visible = true

func _hide_monster_info() -> void:
	if is_instance_valid(monster_info_modal):
		monster_info_modal.visible = false
