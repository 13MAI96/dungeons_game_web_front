extends Control

const SaveGame := preload("res://scripts/save_game.gd")
const SettingsStore := preload("res://scripts/settings_store.gd")
const UiTheme := preload("res://scripts/ui_theme.gd")
const AdSlotConfig := preload("res://scripts/ad_slot_config.gd")
const LocalizedNames := preload("res://scripts/localized_names.gd")
const StatHelp := preload("res://scripts/stat_help.gd")
const Tutorial := preload("res://scripts/tutorial.gd")

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
## Line added to a depletion result stating how much provisional dungeon experience was lost.
const DUNGEON_EXPERIENCE_LOST_KEY := "DUNGEON_EXPERIENCE_LOST"
## One-time low-energy warning shown during a run (title, and message with energy / dungeon XP).
const LOW_ENERGY_TITLE_KEY := "LOW_ENERGY_TITLE"
const LOW_ENERGY_MESSAGE_KEY := "LOW_ENERGY_MESSAGE"
## Variant used when the run has not earned dungeon experience yet (nothing to lose but the run).
const LOW_ENERGY_MESSAGE_NO_EXPERIENCE_KEY := "LOW_ENERGY_MESSAGE_NO_EXPERIENCE"
## Delay before the warning when a short feedback overlay (0.8 s) is still visible.
const LOW_ENERGY_WARNING_DELAY_SECONDS := 0.85
## The warning fires when current energy drops to this percentage of maximum energy or below.
const LOW_ENERGY_WARNING_PERCENT := 25
## Flag stored in the dungeon dictionary (saved with the run) so the warning shows once per run.
const LOW_ENERGY_WARNED_FLAG := "low_energy_warned"
## Taps that arrive this soon after a screen, modal or overlay change are ignored, so a fast
## second tap meant for the previous screen cannot trigger a button on the new one (DNG-9).
const SCREEN_CHANGE_INPUT_COOLDOWN_MSEC := 300
const FIGHT_VICTORY_TITLE_KEY := "FIGHT_VICTORY_TITLE"
const FIGHT_VICTORY_DEFEATED_KEY := "FIGHT_VICTORY_DEFEATED"
const FIGHT_VICTORY_EXPERIENCE_KEY := "FIGHT_VICTORY_EXPERIENCE"
const FIGHT_VICTORY_RUN_TOTAL_KEY := "FIGHT_VICTORY_RUN_TOTAL"
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
const HUB_LEVEL_KEY := "HUB_LEVEL"
const AD_PLACEHOLDER_KEY := "AD_PLACEHOLDER"
const MONSTER_INFO_CLOSE_KEY := "ENCOUNTER_MONSTER_INFO_CLOSE"
const CONFIRM_QUIT_TITLE_KEY := "CONFIRM_QUIT_TITLE"
const CONFIRM_QUIT_MESSAGE_KEY := "CONFIRM_QUIT_MESSAGE"
const CONFIRM_ABANDON_TITLE_KEY := "CONFIRM_ABANDON_TITLE"
const CONFIRM_ABANDON_MESSAGE_KEY := "CONFIRM_ABANDON_MESSAGE"
const RESULT_ABANDONED_MESSAGE_KEY := "RESULT_ABANDONED_MESSAGE"
const CANNOT_AFFORD_ATTACK_KEY := "ENCOUNTER_CANNOT_AFFORD_ATTACK"
## Main menu branding: translated game title and the logo drawn above the menu buttons.
const GAME_TITLE_KEY := "GAME_TITLE"
const GAME_LOGO_ASSET := "res://assets/ui/logo.svg"
## Encounter header "<monster> Lv. <level>" and the name used when a monster has none.
const MONSTER_NAME_LEVEL_KEY := "ENCOUNTER_MONSTER_NAME_LEVEL"
const FALLBACK_MONSTER_NAME_KEY := "ENCOUNTER_MONSTER"
## Tooltips of the D-pad arrow buttons (visible on hover with a mouse).
const DIRECTION_TOOLTIP_KEYS := {
	"left": "DIRECTION_LEFT",
	"right": "DIRECTION_RIGHT",
	"up": "DIRECTION_UP",
	"down": "DIRECTION_DOWN",
}
## Settings button that reopens the "how to play" tutorial.
const SETTINGS_HOW_TO_PLAY_KEY := "SETTINGS_HOW_TO_PLAY"
## Level Up stat guide: card title and the "+N per point" growth line of each stat.
const ALLOCATION_GUIDE_TITLE_KEY := "LEVEL_ALLOCATION_GUIDE_TITLE"
const ALLOCATION_GUIDE_GROWTH_KEY := "LEVEL_ALLOCATION_GUIDE_GROWTH"
## Stats that take level-up points, in the order of the allocation rows and the stat guide.
const ALLOCATABLE_STATS := ["life", "energy", "mana", "armor", "speed", "strength"]
const DIRECTION_ICON_PATHS := {
	"left": "res://assets/icons/arrow_left.svg",
	"right": "res://assets/icons/arrow_right.svg",
	"up": "res://assets/icons/arrow_up.svg",
	"down": "res://assets/icons/arrow_down.svg",
}
const MAP_CELL_MIN := 24
const MAP_CELL_MAX := 64
const MAP_FRAME_PADDING := 8
const LOCATION_COLOR_UNSEEN := Color(0.043, 0.031, 0.024, 1.0)
const LOCATION_COLOR_ENTRANCE := Color(0.2, 0.7, 0.38, 1.0)
const LOCATION_COLOR_VISITED := Color(0.38, 0.38, 0.38, 1.0)
const LOCATION_COLOR_MONSTER := Color(0.65, 0.16, 0.16, 1.0)
const LOCATION_COLOR_BLOCK := Color(0.17, 0.155, 0.14, 1.0)
const LOCATION_COLOR_SANCTUARY := Color(0.16, 0.5, 0.62, 1.0)
const LOCATION_COLOR_QUEST := Color(0.45, 0.32, 0.72, 1.0)
const LOCATION_COLOR_FLOOR := Color(0.3, 0.24, 0.18, 1.0)

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
	"dungeon_experience": "res://assets/icons/dungeon_experience.svg",
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
var action_confirmation: Control
var confirmation_title: Label
var confirmation_message: Label
var confirmation_accept_button: Button
var confirmation_cancel_button: Button
var pending_confirmation_action: Callable
var ad_slot: Panel
var ad_slot_label: Label
var current_screen: String = AdSlotConfig.SCREEN_MENU
var safe_insets: Dictionary = {"left": 0.0, "top": 0.0, "right": 0.0, "bottom": 0.0}
var explore_hud: MarginContainer
var hub_level_label: Label
var map_player_marker: Panel
## True while a game (new or loaded) is in progress; controls saving when the app is backgrounded.
var session_active: bool = false
var save_failure_reported: bool = false
## Optional seeded generator for dungeon layouts (tests and tools/playtest.gd); null = random.
var dungeon_rng: RandomNumberGenerator = null
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
## Static texts of runtime-built screens, kept so a language change can re-translate them.
var allocation_title_label: Label
var allocation_back_button: Button
var monster_info_title: Label
var monster_info_close_button: Button
var dungeon_exit_pending: bool = false
var staged_allocation: Dictionary = {}
var save_path: String = SaveGame.DEFAULT_SAVE_PATH
var settings_path: String = SettingsStore.DEFAULT_SETTINGS_PATH
var pending_game_result_title: String = ""
var pending_game_result_message: String = ""
## Shared popup that explains a stat when its bar is tapped (every screen uses this one).
var stat_help_popup: StatHelp
## "How to play" overlay: shown on the first dungeon entry and from Settings.
var tutorial_overlay: Tutorial
var settings_tutorial_button: Button
## Level Up card that lists what each allocatable stat does and its growth per point.
var allocation_stat_guide: VBoxContainer
## Engine time (Time.get_ticks_msec) until which real taps are swallowed; see _start_input_cooldown().
var input_cooldown_until_msec: int = 0
var fight_victory_modal: ColorRect
var fight_victory_title: Label
var fight_victory_message: Label
var fight_victory_continue_button: Button
## Low-energy warning raised while the fight victory screen was open; shown when it is dismissed.
var low_energy_warning_after_victory: String = ""

@onready var main_menu_view: Control = $MainMenuView
@onready var new_game_view: Control = $NewGameView
@onready var dungeon_explore_view: Control = $DungeonExploreView
@onready var monster_encounter_view: Control = $MonsterEncounterView
@onready var start_game_button: Button = $MainMenuView/MenuArea/MenuButtons/StartGameButton
@onready var load_game_button: Button = $MainMenuView/MenuArea/MenuButtons/LoadGameButton
@onready var settings_button: Button = $MainMenuView/MenuArea/MenuButtons/SettingsButton
@onready var game_logo: TextureRect = $MainMenuView/Branding/BrandingStack/LogoFrame/Logo
@onready var game_title_label: Label = $MainMenuView/Branding/BrandingStack/GameTitle
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
	theme = UiTheme.build()
	$Background.color = UiTheme.BACKGROUND
	_build_runtime_ui()
	_load_game_logo()
	_apply_menu_text()
	_apply_player_stats()
	_connect_navigation_signals()
	_update_load_game_button()
	get_viewport().size_changed.connect(Callable(self, "_on_viewport_size_changed"))
	_watch_screen_changes_for_input_cooldown()
	_show_main_menu_view()

func _get_supported_locale() -> String:
	return LOCALE_SPANISH if OS.get_locale_language() == LOCALE_SPANISH else LOCALE_ENGLISH

## Loads the main menu logo. The art is optional: when the file is missing or fails to load
## the logo stays empty (hidden) and the title alone brands the menu, instead of crashing.
func _load_game_logo() -> void:
	var logo_texture: Texture2D = null
	if ResourceLoader.exists(GAME_LOGO_ASSET):
		logo_texture = load(GAME_LOGO_ASSET) as Texture2D
	game_logo.texture = logo_texture
	game_logo.visible = logo_texture != null

## Sets every static UI text from the translation files. Called on start and again after a
## language change, so it must cover every text that is not rebuilt when a screen opens.
# --- Input cooldown after screen changes (DNG-9) -----------------------------------------

## Every screen, modal and overlay that can appear or disappear. Showing or hiding any of them
## counts as a screen change for the input cooldown.
func _screen_change_watched_nodes() -> Array[Control]:
	return [
		main_menu_view, new_game_view, dungeon_explore_view, monster_encounter_view, settings_view,
		level_allocation_view, monster_info_modal, action_confirmation, game_result_modal,
		fight_victory_modal, damage_overlay, tutorial_overlay,
	]

## Starts the input cooldown whenever a watched screen, modal or overlay changes visibility.
## Hooking visibility_changed keeps the rule central: every current and future code path that
## switches screens or opens/closes a modal gets the cooldown without touching each button.
func _watch_screen_changes_for_input_cooldown() -> void:
	var start_cooldown := Callable(self, "_start_input_cooldown")
	for node: Control in _screen_change_watched_nodes():
		if is_instance_valid(node) and not node.visibility_changed.is_connected(start_cooldown):
			node.visibility_changed.connect(start_cooldown)

## Ignores real taps for SCREEN_CHANGE_INPUT_COOLDOWN_MSEC from now.
func _start_input_cooldown() -> void:
	input_cooldown_until_msec = Time.get_ticks_msec() + SCREEN_CHANGE_INPUT_COOLDOWN_MSEC

## True while taps are still being ignored after the last screen change.
func is_input_cooldown_active() -> bool:
	return Time.get_ticks_msec() < input_cooldown_until_msec

## True for the events a tap or click produces (press and release). On Android a touch also
## arrives as an emulated mouse button event, so both kinds are gated.
func _is_tap_event(event: InputEvent) -> bool:
	return event is InputEventScreenTouch or event is InputEventMouseButton

## Swallows taps during the cooldown. _input runs before the GUI receives the event, so marking
## it handled keeps it away from every button. Only real input events are affected: code (and
## the playtest bot) calling the action methods directly is never blocked.
func _input(event: InputEvent) -> void:
	if _is_tap_event(event) and is_input_cooldown_active():
		get_viewport().set_input_as_handled()

func _apply_menu_text() -> void:
	game_title_label.text = tr(GAME_TITLE_KEY)
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
	if is_instance_valid(settings_tutorial_button):
		settings_tutorial_button.text = tr(SETTINGS_HOW_TO_PLAY_KEY)
	if is_instance_valid(tutorial_overlay):
		tutorial_overlay.refresh_texts()
	if is_instance_valid(confirmation_accept_button):
		confirmation_accept_button.text = tr(CONFIRM_ACCEPT_KEY)
		confirmation_cancel_button.text = tr(CONFIRM_CANCEL_KEY)
	if is_instance_valid(game_result_continue_button):
		game_result_continue_button.text = tr(RESULT_CONTINUE_KEY)
	if is_instance_valid(ad_slot_label):
		ad_slot_label.text = tr(AD_PLACEHOLDER_KEY)
	if is_instance_valid(allocation_title_label):
		allocation_title_label.text = tr(ALLOCATION_TITLE_KEY)
		allocation_back_button.text = tr(ALLOCATION_BACK_KEY)
	if is_instance_valid(monster_info_title):
		monster_info_title.text = tr(MONSTER_ATTACKS_TITLE_KEY)
		monster_info_close_button.text = tr(MONSTER_INFO_CLOSE_KEY)
	manage_equipment_button.tooltip_text = tr(PROGRESSION_PENDING_KEY)
	_apply_direction_tooltips()
	_update_hub_header()

func _apply_player_stats() -> void:
	_populate_stat_bars(stats_column, PLAYER_STATS, player_state, true)
	if is_instance_valid(exploration_stats_container):
		_populate_stat_bars(exploration_stats_container, EXPLORATION_STATS, player_state, true)
	_update_progression_indicator()
	_update_hub_header()

func _update_hub_header() -> void:
	if is_instance_valid(hub_level_label):
		hub_level_label.text = tr(HUB_LEVEL_KEY) % str(int(player_state.get("level", 1)))

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
	dungeon = {}
	session_active = true
	_persist_player_state()
	_apply_player_stats()
	_show_new_game_view()

func _request_new_game() -> void:
	# Any existing file, even one that cannot be loaded, needs confirmation before it is replaced.
	if SaveGame.has_save(save_path):
		_show_confirmation(tr(CONFIRM_NEW_GAME_TITLE_KEY), tr(CONFIRM_NEW_GAME_MESSAGE_KEY), Callable(self, "_start_new_game"))
		return
	_start_new_game()

func _request_exit_to_menu() -> void:
	_show_confirmation(tr(CONFIRM_EXIT_TITLE_KEY), tr(CONFIRM_EXIT_MESSAGE_KEY), Callable(self, "_show_main_menu_view"))

func _show_confirmation(title: String, message: String, action: Callable) -> void:
	pending_confirmation_action = action
	confirmation_title.text = title
	confirmation_message.text = message
	action_confirmation.visible = true
	confirmation_cancel_button.grab_focus.call_deferred()

func _confirm_pending_action() -> void:
	action_confirmation.visible = false
	var action := pending_confirmation_action
	pending_confirmation_action = Callable()
	if action.is_valid():
		action.call()

func _cancel_pending_action() -> void:
	action_confirmation.visible = false
	pending_confirmation_action = Callable()

func _load_game() -> void:
	var result := SaveGame.load_player(CombatRules.create_default_player(), save_path)
	if not bool(result.get("success", false)):
		_update_load_game_button()
		return
	player_state = (result["player"] as Dictionary).duplicate(true)
	CombatRules.refresh_player_attacks(player_state)
	session_active = true
	_apply_player_stats()
	var run := result.get("run", {}) as Dictionary
	if not run.is_empty() and _resume_run(run):
		return
	if bool(player_state.get("in_dungeon", false)):
		# The run could not be restored: settle it like an alive exit without its experience.
		CombatRules.discard_dungeon_experience(player_state)
		CombatRules.restore_status_after_alive_exit(player_state)
		_persist_player_state()
		_apply_player_stats()
	_show_new_game_view()

func _persist_player_state() -> bool:
	if bool(player_state.get("save_deleted", false)):
		var deleted := SaveGame.delete_save(save_path)
		_update_load_game_button()
		return deleted
	var run := _build_run_snapshot()
	var saved := SaveGame.save_player(player_state, save_path, run)
	if not saved and not save_failure_reported:
		save_failure_reported = true
		push_warning("Saving the game failed (storage full or not writable): %s" % save_path)
	# Refreshing the Load button re-reads and parses the whole save, so skip it for in-dungeon
	# checkpoints (every action); the main menu refreshes it when shown.
	if run.is_empty():
		_update_load_game_button()
	return saved

## Active dungeon run for the save, or {} outside a run. Locations are stored as coordinates
## because current/previous/active locations are references into dungeon["locations"].
func _build_run_snapshot() -> Dictionary:
	if dungeon.is_empty() or dungeon_exit_pending or not bool(player_state.get("in_dungeon", false)):
		return {}
	return {
		"dungeon": dungeon,
		"current": _location_coordinates(current_location),
		"previous": _location_coordinates(previous_location),
		"monster": _location_coordinates(active_monster_location),
	}

func _location_coordinates(location: Dictionary) -> Array:
	if location.is_empty():
		return []
	return [int(location["column"]), int(location["row"])]

func _location_from_coordinates(coordinates: Variant) -> Dictionary:
	if not coordinates is Array or (coordinates as Array).size() != 2:
		return {}
	return DungeonGenerator.get_location(dungeon, int(coordinates[0]), int(coordinates[1]))

## Restores a saved run. Returns false (leaving no run active) if the snapshot is unusable.
func _resume_run(run: Dictionary) -> bool:
	if not run.get("dungeon") is Dictionary or not (run["dungeon"] as Dictionary).get("locations") is Array:
		return false
	dungeon = run["dungeon"] as Dictionary
	current_location = _location_from_coordinates(run.get("current"))
	if current_location.is_empty():
		dungeon = {}
		return false
	previous_location = _location_from_coordinates(run.get("previous"))
	var monster_location := _location_from_coordinates(run.get("monster"))
	active_monster_location = monster_location if not monster_location.is_empty() and DungeonGenerator.is_monster_alive(monster_location) else {}
	player_state["in_dungeon"] = true
	dungeon_exit_pending = false
	_clear_feedback()
	_mark_visible_locations()
	_render_map()
	_update_direction_buttons()
	_update_exploration_actions()
	_apply_player_stats()
	_show_dungeon_explore_view()
	if not active_monster_location.is_empty():
		_show_monster_encounter(active_monster_location)
	return true

## Saves the player and the active run after a dungeon action.
func _persist_run_checkpoint() -> void:
	if not dungeon.is_empty() and not dungeon_exit_pending:
		_persist_player_state()

# --- Android lifecycle and back navigation ------------------------------------------------

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_APPLICATION_PAUSED, NOTIFICATION_WM_CLOSE_REQUEST:
			if session_active:
				_persist_player_state()
		NOTIFICATION_WM_GO_BACK_REQUEST:
			_handle_back()

## System back as in-game navigation: close the top modal, otherwise step back one screen.
func handle_back() -> void:
	_handle_back()

func _handle_back() -> void:
	if not is_node_ready():
		return
	if is_instance_valid(stat_help_popup) and stat_help_popup.is_open():
		stat_help_popup.close()
		return
	if is_instance_valid(tutorial_overlay) and tutorial_overlay.is_open():
		tutorial_overlay.skip()
		return
	if is_instance_valid(action_confirmation) and action_confirmation.visible:
		_cancel_pending_action()
		return
	if is_instance_valid(damage_overlay) and damage_overlay.visible:
		return
	if dungeon_exit_pending:
		return
	if is_instance_valid(game_result_modal) and game_result_modal.visible:
		_hide_game_result()
		return
	if is_instance_valid(fight_victory_modal) and fight_victory_modal.visible:
		_hide_fight_victory()  # Back acts like Continue: the victory is only a summary.
		return
	if is_instance_valid(monster_info_modal) and monster_info_modal.visible:
		_hide_monster_info()
		return
	match current_screen:
		AdSlotConfig.SCREEN_SETTINGS:
			_show_main_menu_view()
		AdSlotConfig.SCREEN_LEVEL_UP:
			_show_new_game_view()
		AdSlotConfig.SCREEN_HUB:
			_request_exit_to_menu()
		AdSlotConfig.SCREEN_MENU:
			_show_confirmation(tr(CONFIRM_QUIT_TITLE_KEY), tr(CONFIRM_QUIT_MESSAGE_KEY), Callable(get_tree(), "quit"))
		AdSlotConfig.SCREEN_EXPLORE:
			_request_abandon_expedition()
		AdSlotConfig.SCREEN_ENCOUNTER:
			pass  # Fight or flee; leaving an encounter must not dodge its outcome.

func _request_abandon_expedition() -> void:
	if dungeon.is_empty() or dungeon_exit_pending or not active_monster_location.is_empty():
		return
	_show_confirmation(tr(CONFIRM_ABANDON_TITLE_KEY), tr(CONFIRM_ABANDON_MESSAGE_KEY), Callable(self, "_abandon_expedition"))

## Leaves the dungeon from any cell: the run's experience is lost, status restored as an alive exit.
func _abandon_expedition() -> void:
	if dungeon.is_empty() or dungeon_exit_pending:
		return
	CombatRules.discard_dungeon_experience(player_state)
	CombatRules.restore_status_after_alive_exit(player_state)
	dungeon = {}
	current_location = {}
	previous_location = {}
	active_monster_location = {}
	_clear_feedback()
	_persist_player_state()
	_apply_player_stats()
	_show_new_game_view()
	_show_game_result(tr(RESULT_ENDED_TITLE_KEY), tr(RESULT_ABANDONED_MESSAGE_KEY))

func _update_load_game_button() -> void:
	if is_instance_valid(load_game_button):
		var result := SaveGame.load_player(CombatRules.create_default_player(), save_path)
		load_game_button.disabled = not bool(result.get("success", false))

## Shows exactly one screen: hides every other view and modal screen, then updates the
## ad slot and safe-area insets for the new screen.
func _activate_screen(view: Control, screen: String) -> void:
	for other: Control in [main_menu_view, new_game_view, dungeon_explore_view, monster_encounter_view, settings_view, level_allocation_view, monster_info_modal]:
		if is_instance_valid(other):
			other.visible = false
	if is_instance_valid(action_confirmation):
		action_confirmation.visible = false
	# Overlays that belong to the previous screen close with it.
	if is_instance_valid(stat_help_popup):
		stat_help_popup.close()
	if is_instance_valid(tutorial_overlay):
		tutorial_overlay.dismiss_silently()
	view.visible = true
	current_screen = screen
	_apply_layout_insets()

func _show_new_game_view() -> void:
	dungeon_exit_pending = false
	_activate_screen(new_game_view, AdSlotConfig.SCREEN_HUB)
	_update_progression_indicator()
	_update_hub_header()

func _show_main_menu_view() -> void:
	dungeon_exit_pending = false
	session_active = false
	_activate_screen(main_menu_view, AdSlotConfig.SCREEN_MENU)
	_update_load_game_button()

func _show_settings_view() -> void:
	_activate_screen(settings_view, AdSlotConfig.SCREEN_SETTINGS)
	_update_settings_view()

func _select_locale(locale: String) -> void:
	if not SettingsStore.save_locale(locale, settings_path):
		return
	TranslationServer.set_locale(locale)
	_apply_menu_text()
	# Stat bars carry translated labels ("Total XP"); rebuild them in the new language too.
	_apply_player_stats()
	_update_settings_view()

func _update_settings_view() -> void:
	if not is_instance_valid(settings_english_button) or not is_instance_valid(settings_spanish_button):
		return
	var locale := TranslationServer.get_locale()
	settings_english_button.disabled = locale == LOCALE_ENGLISH
	# Both use the SelectedButton variation: the active (disabled) language is highlighted, not dimmed.
	settings_spanish_button.disabled = locale == LOCALE_SPANISH

func start_dungeon_exploration(dungeon_type: int = 1) -> void:
	dungeon_exit_pending = false
	CombatRules.begin_dungeon_experience(player_state)
	dungeon = DungeonGenerator.create_dungeon(dungeon_type, dungeon_rng, int(player_state.get("level", 1)))
	current_location = DungeonGenerator.get_entrance(dungeon)
	previous_location = {}
	active_monster_location = {}
	_clear_feedback()
	_mark_visible_locations()
	_render_map()
	_update_direction_buttons()
	_update_exploration_actions()
	_show_dungeon_explore_view()
	_persist_run_checkpoint()
	_show_first_run_tutorial_if_needed()

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
	_warn_if_energy_low()
	_persist_run_checkpoint()

func _show_dungeon_explore_view() -> void:
	_activate_screen(dungeon_explore_view, AdSlotConfig.SCREEN_EXPLORE)
	_update_exploration_actions()
	if not dungeon.is_empty():
		_render_map()

func _show_monster_encounter(location: Dictionary) -> void:
	active_monster_location = location
	_ensure_active_monster_max_stats()
	_update_monster_encounter()
	explore_feedback.text = ""
	encounter_feedback.text = ""
	_clear_roll_displays()
	_update_monster_info_button()
	_activate_screen(monster_encounter_view, AdSlotConfig.SCREEN_ENCOUNTER)
	_update_fight_availability()

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
	map_player_marker = null

	for row in range(int(window["start_row"]), int(window["end_row"]) + 1):
		for column in range(int(window["start_column"]), int(window["end_column"]) + 1):
			var location: Dictionary = DungeonGenerator.get_location(dungeon, column, row)
			var cell := Control.new()
			cell.custom_minimum_size = Vector2(cell_size, cell_size)
			cell.mouse_filter = Control.MOUSE_FILTER_IGNORE
			var background := ColorRect.new()
			background.color = _get_location_color(location)
			background.set_anchors_preset(Control.PRESET_FULL_RECT)
			background.mouse_filter = Control.MOUSE_FILTER_IGNORE
			cell.add_child(background)
			var icon_path := _get_location_icon_path(location)
			if icon_path != "":
				var icon := TextureRect.new()
				icon.name = "LocationIcon"
				icon.texture = load(icon_path)
				icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
				icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
				icon.set_anchors_preset(Control.PRESET_FULL_RECT)
				var inset := maxi(4, int(cell_size * 0.16))
				icon.offset_left = inset
				icon.offset_top = inset
				icon.offset_right = -inset
				icon.offset_bottom = -inset
				icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
				cell.add_child(icon)
			if _is_current_location(location):
				map_player_marker = _create_player_marker()
				cell.add_child(map_player_marker)
			map_grid.add_child(cell)
			map_cells.append(cell)

func _is_current_location(location: Dictionary) -> bool:
	if location.is_empty() or current_location.is_empty():
		return false
	return int(location["column"]) == int(current_location["column"]) and int(location["row"]) == int(current_location["row"])

## A gold ring drawn over the player's cell; visible on every tile colour, including the entrance.
func _create_player_marker() -> Panel:
	var marker := Panel.new()
	marker.name = "PlayerMarker"
	marker.mouse_filter = Control.MOUSE_FILTER_IGNORE
	marker.set_anchors_preset(Control.PRESET_FULL_RECT)
	var ring := StyleBoxFlat.new()
	ring.bg_color = Color.TRANSPARENT
	ring.border_color = UiTheme.ACCENT_BRIGHT
	ring.set_border_width_all(4)
	ring.set_corner_radius_all(6)
	marker.add_theme_stylebox_override("panel", ring)
	return marker

## Cell size from the space left after the HUD and action area, so the map never clips and
## does not resize when transient content (feedback text, Collect Treasure) appears.
func _get_map_cell_size() -> int:
	var columns: int = mini(int(dungeon["number_of_columns"]), MAP_VIEW_COLUMNS)
	var rows: int = mini(int(dungeon["number_of_rows"]), MAP_VIEW_ROWS)
	var content := _get_content_size(false)
	var map_area := $DungeonExploreView/MapArea as MarginContainer
	var margin_h := map_area.get_theme_constant("margin_left") + map_area.get_theme_constant("margin_right")
	var margin_v := map_area.get_theme_constant("margin_top") + map_area.get_theme_constant("margin_bottom")
	var hud_height := explore_hud.get_combined_minimum_size().y if is_instance_valid(explore_hud) else 0.0
	var actions_height := ($DungeonExploreView/ExploreActions as Control).get_combined_minimum_size().y
	var separation := float(map_grid.get_theme_constant("h_separation"))
	var frame := float(MAP_FRAME_PADDING * 2)
	var available_width: float = content.x - margin_h - frame - separation * (columns - 1)
	var available_height: float = content.y - hud_height - actions_height - margin_v - frame - separation * (rows - 1)
	var width_cell_size: int = floori(available_width / float(columns))
	var height_cell_size: int = floori(available_height / float(rows))
	return clampi(mini(width_cell_size, height_cell_size), MAP_CELL_MIN, MAP_CELL_MAX)

func _get_location_color(location: Dictionary) -> Color:
	if location.is_empty() or not bool(location.get("visible", false)):
		return LOCATION_COLOR_UNSEEN
	if location["type"] == DungeonGenerator.LOCATION_ENTRANCE:
		return LOCATION_COLOR_ENTRANCE
	if location["type"] == DungeonGenerator.LOCATION_BLOCK:
		return LOCATION_COLOR_BLOCK
	if bool(location.get("visited", false)):
		return LOCATION_COLOR_VISITED
	if location["type"] == DungeonGenerator.LOCATION_MONSTER:
		return LOCATION_COLOR_MONSTER
	if location["type"] == DungeonGenerator.LOCATION_SANCTUARY:
		return LOCATION_COLOR_SANCTUARY
	if location["type"] == DungeonGenerator.LOCATION_QUEST:
		return LOCATION_COLOR_QUEST
	return LOCATION_COLOR_FLOOR

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

func _apply_direction_icons() -> void:
	var buttons := {"left": move_left_button, "right": move_right_button, "up": move_up_button, "down": move_down_button}
	for direction: String in buttons:
		var button := buttons[direction] as Button
		button.text = ""
		button.icon = load(String(DIRECTION_ICON_PATHS[direction]))
	_apply_direction_tooltips()

## Translated tooltips for the D-pad arrows (they have icons, not text).
func _apply_direction_tooltips() -> void:
	var buttons := {"left": move_left_button, "right": move_right_button, "up": move_up_button, "down": move_down_button}
	for direction: String in buttons:
		(buttons[direction] as Button).tooltip_text = tr(String(DIRECTION_TOOLTIP_KEYS[direction]))

func _update_monster_encounter() -> void:
	var monster := active_monster_location.get("content", {}) as Dictionary
	monster_image.visible = false
	encounter_player_image.visible = false
	monster_image_asset.texture = load(_get_monster_asset_path(monster))
	var display_name := _get_monster_display_name(monster)
	monster_image.text = display_name
	monster_name.text = tr(MONSTER_NAME_LEVEL_KEY) % [display_name, str(int(monster.get("level", 1)))]
	monster_stats.visible = false
	encounter_player_stats.visible = false
	_populate_stat_bars(monster_stat_bars, MONSTER_STATS, _normalize_monster_stat_source(monster), true)
	var encounter_stats := PLAYER_STATS.duplicate(true)
	encounter_stats.append({"name": "DungeonExperience", "key": "dungeon_experience", "label_key": "STAT_DUNGEON_EXPERIENCE"})
	_populate_stat_bars(encounter_player_stat_bars, encounter_stats, player_state, true)
	_update_monster_info_button()
	_update_fight_availability()

## Translated monster name for the UI; the data keeps the English name (used for its art).
func _get_monster_display_name(monster: Dictionary) -> String:
	var english_name := String(monster.get("name", ""))
	if english_name.is_empty():
		return tr(FALLBACK_MONSTER_NAME_KEY)
	return LocalizedNames.monster(english_name)

## Fight is disabled (with an explanation) when the attack cannot be paid; Flee stays available.
func _update_fight_availability() -> void:
	var can_attack := CombatRules.can_afford_attack(player_state)
	fight_button.disabled = dungeon_exit_pending or not can_attack
	if can_attack or dungeon_exit_pending:
		return
	var hint := tr(CANNOT_AFFORD_ATTACK_KEY)
	if not encounter_feedback.text.contains(hint):
		encounter_feedback.text = ("%s %s" % [encounter_feedback.text, hint]).strip_edges()

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

	# Victory is resolved first: a winning blow that spends the last energy still completes the
	# dungeon (and keeps the defeated monster defeated) before depletion is checked.
	if bool(result.get("monster_defeated", false)):
		var experience_gained := int(result.get("experience_gained", 0))
		var defeated_monster := active_monster_location.get("content", {}) as Dictionary
		active_monster_location = {}
		_render_map()
		_update_direction_buttons()
		# The last kill completes the dungeon: its result modal also names the defeated monster,
		# so the player sees one result instead of a victory screen stacked on the completion.
		if _complete_dungeon_if_ready(experience_gained, _format_victory_lines(defeated_monster, experience_gained, false)):
			return
		# A kill that spent the last energy ends the run; the depletion result explains it.
		if _exit_dungeon_if_player_depleted():
			return
		_show_dungeon_explore_view()
		explore_feedback.text = ""
		_show_fight_victory(defeated_monster, experience_gained)
		_warn_if_energy_low()  # Waits for the victory screen to be dismissed.
		_persist_run_checkpoint()
		return

	if _exit_dungeon_if_player_depleted():
		return

	if int(player_state.get("current_life", 0)) < previous_life:
		_show_damage_overlay(tr(String(result.get("message_key", "COMBAT_COUNTERATTACK_HIT"))))
	_update_monster_encounter()
	_warn_if_energy_low()
	_persist_run_checkpoint()

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
	_persist_run_checkpoint()

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
	_warn_if_energy_low()
	_persist_run_checkpoint()

func _exit_dungeon_if_player_depleted() -> bool:
	if int(player_state.get("current_life", 0)) > 0 and int(player_state.get("current_energy", 0)) > 0:
		return false
	if dungeon_exit_pending:
		return true

	# Captured before the depletion rules reset it, so the result can say what the run cost.
	var experience_lost := int(player_state.get("dungeon_experience", 0))
	var lost_line := _format_experience_lost(experience_lost)

	if int(player_state.get("current_life", 0)) <= 0:
		var death_result := CombatRules.apply_death_sequel(player_state)
		_persist_player_state()
		var death_details := _join_lines([lost_line, tr(String(death_result.get("message_key", "COMBAT_DEATH_SEQUEL")))])
		pending_game_result_title = tr(RESULT_GAME_OVER_TITLE_KEY) if bool(death_result.get("save_deleted", false)) else tr(RESULT_DEFEAT_TITLE_KEY)
		pending_game_result_message = _join_lines([tr(DUNGEON_LIFE_DEPLETED_KEY), death_details])
		_begin_depleted_dungeon_exit(tr(DUNGEON_LIFE_DEPLETED_KEY), death_details)
	else:
		CombatRules.discard_dungeon_experience(player_state)
		CombatRules.restore_status_after_alive_exit(player_state)
		_persist_player_state()
		pending_game_result_title = tr(RESULT_ENDED_TITLE_KEY)
		pending_game_result_message = _join_lines([tr(DUNGEON_ENERGY_DEPLETED_KEY), lost_line])
		_begin_depleted_dungeon_exit(tr(DUNGEON_ENERGY_DEPLETED_KEY), lost_line)
	return true

## Localized "You lost N dungeon experience" line, or "" when the run had earned nothing.
func _format_experience_lost(experience_lost: int) -> String:
	if experience_lost <= 0:
		return ""
	return tr(DUNGEON_EXPERIENCE_LOST_KEY) % str(experience_lost)

## Joins the non-empty lines with newlines (keeps result messages free of blank lines).
func _join_lines(lines: Array) -> String:
	var kept: Array[String] = []
	for line: Variant in lines:
		if String(line) != "":
			kept.append(String(line))
	return "\n".join(kept)

## Shows a one-time warning per run when energy falls to LOW_ENERGY_WARNING_PERCENT or below,
## telling the player that running out ends the run and loses the dungeon experience.
## Call after any in-dungeon action that may spend energy, once depletion has been handled.
func _warn_if_energy_low() -> void:
	if dungeon.is_empty() or dungeon_exit_pending or bool(dungeon.get(LOW_ENERGY_WARNED_FLAG, false)):
		return
	var current_energy := int(player_state.get("current_energy", 0))
	var maximum_energy := int(player_state.get("energy", 0))
	if maximum_energy <= 0 or current_energy <= 0:
		return
	var threshold := maxi(1, ceili(maximum_energy * LOW_ENERGY_WARNING_PERCENT / 100.0))
	if current_energy > threshold:
		return
	dungeon[LOW_ENERGY_WARNED_FLAG] = true
	var dungeon_experience := int(player_state.get("dungeon_experience", 0))
	var message := tr(LOW_ENERGY_MESSAGE_KEY) % [str(current_energy), str(dungeon_experience)]
	if dungeon_experience <= 0:
		message = tr(LOW_ENERGY_MESSAGE_NO_EXPERIENCE_KEY) % str(current_energy)
	# The fight victory screen of this same action stays first; the warning follows its Continue.
	if is_instance_valid(fight_victory_modal) and fight_victory_modal.visible:
		low_energy_warning_after_victory = message
		return
	# A short feedback overlay (XP gained, damage taken) may be showing for this same action;
	# wait for it to close so the warning does not hide it.
	if is_instance_valid(damage_overlay) and damage_overlay.visible:
		get_tree().create_timer(LOW_ENERGY_WARNING_DELAY_SECONDS).timeout.connect(
			Callable(self, "_show_low_energy_warning").bind(message))
		return
	_show_low_energy_warning(message)

## Displays the low-energy warning unless the run ended while it was waiting.
func _show_low_energy_warning(message: String) -> void:
	if dungeon.is_empty() or dungeon_exit_pending:
		return
	# A delayed warning (after a feedback overlay) may come due while a victory result is open;
	# keep it for that result's Continue instead of covering it.
	if is_instance_valid(fight_victory_modal) and fight_victory_modal.visible:
		low_energy_warning_after_victory = message
		return
	_show_game_result(tr(LOW_ENERGY_TITLE_KEY), message)

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

## Ends a depleted run after its notification. Runs once per exit: a second call (e.g. the
## overlay timer firing after the exit was already settled) would wipe a newer run.
func _finish_depleted_dungeon_exit() -> void:
	if not dungeon_exit_pending:
		return
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
	_add_hub_header()
	_add_progression_indicator()
	_add_explore_hud()
	_apply_direction_icons()
	var map_frame_style := UiTheme.box(UiTheme.SURFACE_SUNKEN, UiTheme.BORDER, 1, 10, MAP_FRAME_PADDING, MAP_FRAME_PADDING)
	($DungeonExploreView/MapArea/MapFrame as PanelContainer).add_theme_stylebox_override("panel", map_frame_style)

	collect_treasure_button = Button.new()
	collect_treasure_button.name = "CollectTreasureButton"
	collect_treasure_button.theme_type_variation = &"CompactPrimaryButton"
	collect_treasure_button.custom_minimum_size = Vector2(0, UiTheme.BUTTON_HEIGHT)
	collect_treasure_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	collect_treasure_button.autowrap_mode = TextServer.AUTOWRAP_WORD
	$DungeonExploreView/ExploreActions/ExploreActionStack/ExploreSecondaryActions.add_child(collect_treasure_button)

	monster_image_asset = _add_texture_child(monster_image.get_parent(), "MonsterImageAsset", FALLBACK_MONSTER_ASSET)
	encounter_player_asset = _add_texture_child(encounter_player_image.get_parent(), "EncounterPlayerAsset", CHARACTER_ASSET)
	monster_image.get_parent().move_child(monster_image_asset, monster_image.get_parent().get_child_count() - 1)
	encounter_player_image.get_parent().move_child(encounter_player_asset, 0)
	_add_monster_info_button()
	monster_stat_bars = VBoxContainer.new()
	monster_stat_bars.name = "MonsterStatBars"
	monster_stat_bars.add_theme_constant_override("separation", 5)
	monster_stats.get_parent().add_child(monster_stat_bars)
	monster_roll_display = _create_roll_display("MonsterRollDisplay")
	monster_stats.get_parent().add_child(monster_roll_display)
	encounter_player_stat_bars = VBoxContainer.new()
	encounter_player_stat_bars.name = "EncounterPlayerStatBars"
	encounter_player_stat_bars.add_theme_constant_override("separation", 5)
	encounter_player_stats.get_parent().add_child(encounter_player_stat_bars)
	player_roll_display = _create_roll_display("PlayerRollDisplay")
	encounter_player_stats.get_parent().add_child(player_roll_display)
	_add_damage_overlay()
	_add_monster_info_modal()
	_add_level_allocation_view()
	_add_settings_view()
	_add_action_confirmation()
	_add_game_result_modal()
	_add_tutorial_overlay()
	_add_stat_help_popup()
	_add_fight_victory_modal()
	_add_ad_slot()

# --- App shell: safe area + reserved ad slot -------------------------------------------------

func _on_viewport_size_changed() -> void:
	_apply_layout_insets()
	if dungeon_explore_view.visible and not dungeon.is_empty():
		_render_map()

## Safe-area insets in viewport (logical) pixels. Only meaningful on mobile; desktop
## `get_display_safe_area()` returns the usable desktop rect, not notch insets.
func _compute_safe_insets() -> Dictionary:
	var insets := {"left": 0.0, "top": 0.0, "right": 0.0, "bottom": 0.0}
	if not OS.has_feature("mobile"):
		return insets
	var window_size := Vector2(DisplayServer.window_get_size())
	if window_size.x <= 0.0 or window_size.y <= 0.0:
		return insets
	var safe := DisplayServer.get_display_safe_area()
	var scale := get_viewport().get_visible_rect().size / window_size
	insets["left"] = maxf(0.0, safe.position.x * scale.x)
	insets["top"] = maxf(0.0, safe.position.y * scale.y)
	insets["right"] = maxf(0.0, (window_size.x - safe.end.x) * scale.x)
	insets["bottom"] = maxf(0.0, (window_size.y - safe.end.y) * scale.y)
	return insets

func is_ad_slot_visible() -> bool:
	return is_instance_valid(ad_slot) and ad_slot.visible

## Height reserved at the bottom for the ad slot on the current screen (0 when hidden).
func get_ad_reserved_height() -> float:
	return float(AdSlotConfig.reserved_height()) if AdSlotConfig.allows(current_screen) else 0.0

## Size of the area views may draw into (safe area minus the ad reservation).
func _get_content_size(include_ad: bool = true) -> Vector2:
	var size := get_viewport().get_visible_rect().size
	var insets := _compute_safe_insets()
	var ad_height := get_ad_reserved_height() if include_ad else 0.0
	return Vector2(size.x - insets["left"] - insets["right"], size.y - insets["top"] - insets["bottom"] - ad_height)

func _apply_layout_insets() -> void:
	safe_insets = _compute_safe_insets()
	var ad_height := get_ad_reserved_height()
	var left: float = safe_insets["left"]
	var top: float = safe_insets["top"]
	var right: float = safe_insets["right"]
	var bottom: float = safe_insets["bottom"]
	# Screens: content stays inside the safe area and above the ad slot.
	for view: Control in [main_menu_view, new_game_view, dungeon_explore_view, monster_encounter_view, settings_view, level_allocation_view]:
		if is_instance_valid(view):
			_set_inset_offsets(view, left, top, right, bottom + ad_height)
	# Overlays: dim the whole screen except the banner, so the banner is never covered.
	for overlay: Control in [monster_info_modal, damage_overlay, action_confirmation, game_result_modal, fight_victory_modal, tutorial_overlay, stat_help_popup]:
		if is_instance_valid(overlay):
			_set_inset_offsets(overlay, 0.0, 0.0, 0.0, bottom + ad_height)
	if is_instance_valid(ad_slot):
		ad_slot.visible = ad_height > 0.0
		ad_slot.offset_left = left
		ad_slot.offset_right = -right
		ad_slot.offset_top = -(bottom + AdSlotConfig.height)
		ad_slot.offset_bottom = -bottom

func _set_inset_offsets(control: Control, left: float, top: float, right: float, bottom: float) -> void:
	control.set_anchors_preset(Control.PRESET_FULL_RECT)
	control.offset_left = left
	control.offset_top = top
	control.offset_right = -right
	control.offset_bottom = -bottom

## Bottom banner reservation. No SDK yet: debug builds show a labelled placeholder,
## release builds an empty strip that a banner plugin will draw over.
func _add_ad_slot() -> void:
	ad_slot = Panel.new()
	ad_slot.name = "AdSlot"
	ad_slot.theme_type_variation = &"AdSlotPanel"
	ad_slot.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ad_slot.anchor_left = 0.0
	ad_slot.anchor_right = 1.0
	ad_slot.anchor_top = 1.0
	ad_slot.anchor_bottom = 1.0
	add_child(ad_slot)
	ad_slot_label = Label.new()
	ad_slot_label.name = "Placeholder"
	ad_slot_label.theme_type_variation = &"CaptionLabel"
	ad_slot_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	ad_slot_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	ad_slot_label.set_anchors_preset(Control.PRESET_FULL_RECT)
	ad_slot_label.text = tr(AD_PLACEHOLDER_KEY)
	ad_slot_label.visible = OS.is_debug_build()
	ad_slot_label.add_theme_color_override("font_color", Color(UiTheme.TEXT_DISABLED, 0.8))
	ad_slot.add_child(ad_slot_label)

# --- Modals -------------------------------------------------------------------------------

## Full-screen scrim with a centred dialog card. Returns the card's content VBox.
func _create_modal(node_name: String, scrim_color: Color = UiTheme.SCRIM) -> Dictionary:
	var scrim := ColorRect.new()
	scrim.name = node_name
	scrim.color = scrim_color
	scrim.visible = false
	scrim.mouse_filter = Control.MOUSE_FILTER_STOP
	scrim.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(scrim)
	var margin := MarginContainer.new()
	margin.name = "Margin"
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	for side: String in ["left", "right"]:
		margin.add_theme_constant_override("margin_%s" % side, UiTheme.SCREEN_GUTTER)
	for side: String in ["top", "bottom"]:
		margin.add_theme_constant_override("margin_%s" % side, 24)
	scrim.add_child(margin)
	var card := PanelContainer.new()
	card.name = "Card"
	card.theme_type_variation = &"DialogPanel"
	card.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	margin.add_child(card)
	var content := VBoxContainer.new()
	content.name = "Content"
	content.add_theme_constant_override("separation", 14)
	card.add_child(content)
	return {"root": scrim, "card": card, "content": content}

func _create_label(node_name: String, variation: StringName = &"", wrap: bool = true) -> Label:
	var label := Label.new()
	label.name = node_name
	label.theme_type_variation = variation
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	if wrap:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return label

func _create_button(node_name: String, variation: StringName = &"", height: int = UiTheme.BUTTON_HEIGHT) -> Button:
	var button := Button.new()
	button.name = node_name
	button.theme_type_variation = variation
	button.custom_minimum_size = Vector2(0, height)
	button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return button

func _add_action_confirmation() -> void:
	var modal := _create_modal("ActionConfirmation")
	action_confirmation = modal["root"]
	var content: VBoxContainer = modal["content"]
	confirmation_title = _create_label("Title", &"HeaderLabel")
	content.add_child(confirmation_title)
	confirmation_message = _create_label("Message")
	content.add_child(confirmation_message)
	var actions := HBoxContainer.new()
	actions.name = "Actions"
	actions.add_theme_constant_override("separation", 10)
	content.add_child(actions)
	# Cancel first and neutral; the accepting action is the emphasised one on the right.
	confirmation_cancel_button = _create_button("CancelButton")
	confirmation_cancel_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	confirmation_cancel_button.pressed.connect(Callable(self, "_cancel_pending_action"))
	actions.add_child(confirmation_cancel_button)
	confirmation_accept_button = _create_button("AcceptButton", &"PrimaryButton")
	confirmation_accept_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	confirmation_accept_button.pressed.connect(Callable(self, "_confirm_pending_action"))
	actions.add_child(confirmation_accept_button)

func _add_game_result_modal() -> void:
	var modal := _create_modal("GameResultModal", Color(UiTheme.BACKGROUND, 0.96))
	game_result_modal = modal["root"]
	var content: VBoxContainer = modal["content"]
	content.name = "ResultPanel"
	content.add_theme_constant_override("separation", 18)
	game_result_title = _create_label("Title", &"TitleLabel")
	content.add_child(game_result_title)
	game_result_message = _create_label("Message")
	game_result_message.add_theme_font_size_override("font_size", 18)
	content.add_child(game_result_message)
	game_result_continue_button = _create_button("ContinueButton", &"PrimaryButton", UiTheme.PRIMARY_HEIGHT)
	game_result_continue_button.pressed.connect(Callable(self, "_hide_game_result"))
	content.add_child(game_result_continue_button)

func _show_game_result(title: String, message: String) -> void:
	game_result_title.text = title
	game_result_message.text = message
	game_result_modal.visible = true
	_apply_layout_insets()

func _hide_game_result() -> void:
	game_result_modal.visible = false

# --- Fight victory result (DNG-10) -------------------------------------------------------

## Builds the "Victory" modal shown after a won fight that does not end the run: the experience
## icon, the defeated monster, the experience gained and a Continue button back to the map.
func _add_fight_victory_modal() -> void:
	var modal := _create_modal("FightVictoryModal", Color(UiTheme.BACKGROUND, 0.96))
	fight_victory_modal = modal["root"]
	var content: VBoxContainer = modal["content"]
	content.name = "VictoryPanel"
	content.add_theme_constant_override("separation", 18)
	var icon := TextureRect.new()
	icon.name = "Icon"
	icon.texture = load(EXPERIENCE_FEEDBACK_ASSET)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.custom_minimum_size = Vector2(96, 96)
	content.add_child(icon)
	fight_victory_title = _create_label("Title", &"TitleLabel")
	content.add_child(fight_victory_title)
	fight_victory_message = _create_label("Message")
	fight_victory_message.add_theme_font_size_override("font_size", 18)
	content.add_child(fight_victory_message)
	fight_victory_continue_button = _create_button("ContinueButton", &"PrimaryButton", UiTheme.PRIMARY_HEIGHT)
	fight_victory_continue_button.pressed.connect(Callable(self, "_hide_fight_victory"))
	content.add_child(fight_victory_continue_button)

## Shows the victory result for `monster` over the exploration map.
func _show_fight_victory(monster: Dictionary, experience_gained: int) -> void:
	low_energy_warning_after_victory = ""
	fight_victory_title.text = tr(FIGHT_VICTORY_TITLE_KEY)
	fight_victory_message.text = _format_victory_lines(monster, experience_gained, true)
	fight_victory_continue_button.text = tr(RESULT_CONTINUE_KEY)
	fight_victory_modal.visible = true
	_apply_layout_insets()

## Closes the victory result (back to the map) and then shows a low-energy warning raised by
## the same fight, so the two never stack.
func _hide_fight_victory() -> void:
	fight_victory_modal.visible = false
	var warning := low_energy_warning_after_victory
	low_energy_warning_after_victory = ""
	if warning != "":
		_show_low_energy_warning(warning)

## Victory text: the defeated monster and the experience gained (omitted when zero). With
## `include_run_total`, adds the provisional dungeon experience and how to keep it, which only
## matters while the run continues (the completion result already reports what was kept).
func _format_victory_lines(monster: Dictionary, experience_gained: int, include_run_total: bool) -> String:
	var lines: Array = [tr(FIGHT_VICTORY_DEFEATED_KEY) % _translated_monster_name(monster)]
	if experience_gained > 0:
		lines.append(tr(FIGHT_VICTORY_EXPERIENCE_KEY) % str(experience_gained))
	if include_run_total:
		lines.append(tr(FIGHT_VICTORY_RUN_TOTAL_KEY) % str(int(player_state.get("dungeon_experience", 0))))
	return _join_lines(lines)

## Localized monster name, delegated to LocalizedNames so every screen uses the same keys.
func _translated_monster_name(monster: Dictionary) -> String:
	return LocalizedNames.monster(String(monster.get("name", "Monster")))

## Full-rect screen with the theme background and a centred, width-limited column.
func _create_screen(node_name: String) -> Dictionary:
	var screen := Control.new()
	screen.name = node_name
	screen.visible = false
	screen.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(screen)
	var background := ColorRect.new()
	background.name = "Background"
	background.color = UiTheme.BACKGROUND
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	screen.add_child(background)
	var margin := MarginContainer.new()
	margin.name = "Margin"
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	for side: String in ["left", "right"]:
		margin.add_theme_constant_override("margin_%s" % side, UiTheme.SCREEN_GUTTER)
	margin.add_theme_constant_override("margin_top", 24)
	margin.add_theme_constant_override("margin_bottom", 16)
	screen.add_child(margin)
	return {"root": screen, "margin": margin}

func _add_settings_view() -> void:
	var screen := _create_screen("SettingsView")
	settings_view = screen["root"]
	var panel := VBoxContainer.new()
	panel.name = "SettingsPanel"
	panel.alignment = BoxContainer.ALIGNMENT_CENTER
	panel.add_theme_constant_override("separation", 14)
	(screen["margin"] as MarginContainer).add_child(panel)

	settings_title = _create_label("Title", &"TitleLabel", false)
	panel.add_child(settings_title)

	var card := PanelContainer.new()
	card.name = "LanguageCard"
	card.theme_type_variation = &"CardPanel"
	panel.add_child(card)
	var card_content := VBoxContainer.new()
	card_content.add_theme_constant_override("separation", 10)
	card.add_child(card_content)

	settings_language_label = _create_label("LanguageLabel", &"CaptionLabel", false)
	settings_language_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	card_content.add_child(settings_language_label)

	settings_english_button = _create_button("EnglishButton", &"SelectedButton")
	settings_english_button.pressed.connect(Callable(self, "_select_locale").bind(LOCALE_ENGLISH))
	card_content.add_child(settings_english_button)

	settings_spanish_button = _create_button("SpanishButton", &"SelectedButton")
	settings_spanish_button.pressed.connect(Callable(self, "_select_locale").bind(LOCALE_SPANISH))
	card_content.add_child(settings_spanish_button)

	settings_tutorial_button = _create_button("HowToPlayButton")
	settings_tutorial_button.pressed.connect(Callable(self, "_open_tutorial"))
	panel.add_child(settings_tutorial_button)

	settings_back_button = _create_button("BackButton")
	settings_back_button.pressed.connect(Callable(self, "_show_main_menu_view"))
	panel.add_child(settings_back_button)
	_update_settings_view()

func _add_hub_header() -> void:
	var header := MarginContainer.new()
	header.name = "HubHeader"
	header.add_theme_constant_override("margin_left", 16)
	header.add_theme_constant_override("margin_right", 16)
	header.add_theme_constant_override("margin_top", 12)
	header.add_theme_constant_override("margin_bottom", 0)
	new_game_view.add_child(header)
	new_game_view.move_child(header, 0)
	hub_level_label = _create_label("LevelLabel", &"TitleLabel", false)
	hub_level_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	header.add_child(hub_level_label)

## Survival stats as a compact HUD above the map, so the bottom third holds only controls.
func _add_explore_hud() -> void:
	explore_hud = MarginContainer.new()
	explore_hud.name = "ExploreHud"
	explore_hud.add_theme_constant_override("margin_left", 16)
	explore_hud.add_theme_constant_override("margin_right", 16)
	explore_hud.add_theme_constant_override("margin_top", 12)
	explore_hud.add_theme_constant_override("margin_bottom", 0)
	dungeon_explore_view.add_child(explore_hud)
	dungeon_explore_view.move_child(explore_hud, 0)
	var card := PanelContainer.new()
	card.name = "Card"
	card.theme_type_variation = &"CardPanel"
	explore_hud.add_child(card)
	exploration_stats_container = VBoxContainer.new()
	exploration_stats_container.name = "ExplorationStats"
	exploration_stats_container.add_theme_constant_override("separation", 4)
	card.add_child(exploration_stats_container)

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
	var reserved := int(player_state.get("reserved_progression_points", player_state.get("pending_level_points", 0)))
	progression_indicator.visible = reserved > 0 or CombatRules.get_convertible_level_count(player_state) > 0

func _add_texture_child(parent: Node, node_name: String, texture_path: String) -> TextureRect:
	var texture_rect := TextureRect.new()
	texture_rect.name = node_name
	texture_rect.texture = load(texture_path)
	# IGNORE_SIZE: the layout decides the width and the art scales to fit. FIT_WIDTH_PROPORTIONAL
	# derived the minimum width from the slot height, pushing the stats column off narrow screens.
	texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
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
	monster_info_button.theme_type_variation = &"IconButton"
	var size := UiTheme.ICON_BUTTON_SIZE
	monster_info_button.custom_minimum_size = Vector2(size, size)
	monster_info_button.anchor_left = 1.0
	monster_info_button.anchor_right = 1.0
	monster_info_button.anchor_top = 0.0
	monster_info_button.anchor_bottom = 0.0
	monster_info_button.offset_left = -size
	monster_info_button.offset_right = 0
	monster_info_button.offset_top = 0
	monster_info_button.offset_bottom = size
	monster_info_button.visible = false
	monster_info_button.pressed.connect(Callable(self, "_show_monster_info"))
	monster_image_asset.add_child(monster_info_button)

func _add_monster_info_modal() -> void:
	# Opaque scrim: the monster info screen fully replaces the encounter visually.
	var modal := _create_modal("MonsterInfoModal", UiTheme.BACKGROUND)
	monster_info_modal = modal["root"]
	var panel: VBoxContainer = modal["content"]
	panel.name = "Panel"

	monster_info_title = _create_label("Title", &"HeaderLabel")
	monster_info_title.text = tr(MONSTER_ATTACKS_TITLE_KEY)
	panel.add_child(monster_info_title)

	monster_info_text = _create_label("AttackList")
	monster_info_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	panel.add_child(monster_info_text)

	monster_info_close_button = _create_button("CloseButton", &"PrimaryButton")
	monster_info_close_button.text = tr(MONSTER_INFO_CLOSE_KEY)
	monster_info_close_button.pressed.connect(Callable(self, "_hide_monster_info"))
	panel.add_child(monster_info_close_button)

func _add_damage_overlay() -> void:
	damage_overlay = ColorRect.new()
	damage_overlay.name = "DamageOverlay"
	damage_overlay.color = Color(0, 0, 0, 0.72)
	# Blocks taps so a feedback flash cannot trigger the action buttons underneath.
	damage_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
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
	damage_overlay_text.add_theme_font_size_override("font_size", 24)
	damage_overlay_text.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.9))
	damage_overlay_text.add_theme_constant_override("outline_size", 6)
	damage_overlay_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	damage_overlay_text.anchor_left = 0.0
	damage_overlay_text.anchor_top = 0.66
	damage_overlay_text.anchor_right = 1.0
	damage_overlay_text.anchor_bottom = 0.8
	damage_overlay_text.offset_left = 24
	damage_overlay_text.offset_right = -24
	damage_overlay.add_child(damage_overlay_text)

func _add_level_allocation_view() -> void:
	var screen := _create_screen("LevelAllocationView")
	level_allocation_view = screen["root"]
	var layout := VBoxContainer.new()
	layout.name = "Layout"
	layout.add_theme_constant_override("separation", 12)
	(screen["margin"] as MarginContainer).add_child(layout)

	allocation_title_label = _create_label("Title", &"TitleLabel", false)
	allocation_title_label.text = tr(ALLOCATION_TITLE_KEY)
	layout.add_child(allocation_title_label)

	allocation_remaining_label = _create_label("RemainingPoints", &"HeaderLabel")
	allocation_remaining_label.add_theme_color_override("font_color", UiTheme.ACCENT_BRIGHT)
	layout.add_child(allocation_remaining_label)

	# Rows and class choices scroll, so the actions stay reachable on short screens.
	var scroll := ScrollContainer.new()
	scroll.name = "Scroll"
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	layout.add_child(scroll)
	var panel := VBoxContainer.new()
	panel.name = "AllocationPanel"
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.add_theme_constant_override("separation", 10)
	scroll.add_child(panel)

	allocation_buttons_container = VBoxContainer.new()
	allocation_buttons_container.name = "StatButtons"
	allocation_buttons_container.add_theme_constant_override("separation", 8)
	panel.add_child(allocation_buttons_container)

	allocation_stat_guide = _create_allocation_stat_guide(panel)

	class_choice_container = VBoxContainer.new()
	class_choice_container.name = "ClassChoices"
	class_choice_container.add_theme_constant_override("separation", 8)
	panel.add_child(class_choice_container)

	var actions := HBoxContainer.new()
	actions.name = "Actions"
	actions.add_theme_constant_override("separation", 10)
	layout.add_child(actions)

	allocation_back_button = _create_button("BackButton")
	allocation_back_button.text = tr(ALLOCATION_BACK_KEY)
	allocation_back_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	allocation_back_button.pressed.connect(Callable(self, "_show_new_game_view"))
	actions.add_child(allocation_back_button)

	allocation_confirm_button = _create_button("ConfirmAllocationButton", &"PrimaryButton", UiTheme.PRIMARY_HEIGHT)
	allocation_confirm_button.text = tr(ALLOCATION_CONFIRM_KEY)
	allocation_confirm_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	allocation_confirm_button.pressed.connect(Callable(self, "_confirm_level_allocation"))
	actions.add_child(allocation_confirm_button)

# --- First-run tutorial and stat help (DNG-6, DNG-7) ---------------------------------------

## Creates the "how to play" overlay; closing it (Skip, Done or back) marks the tutorial as seen.
func _add_tutorial_overlay() -> void:
	tutorial_overlay = Tutorial.new()
	tutorial_overlay.closed.connect(Callable(self, "_on_tutorial_closed"))
	add_child(tutorial_overlay)

## Creates the single stat help popup that every stat bar is wired to.
func _add_stat_help_popup() -> void:
	stat_help_popup = StatHelp.new()
	add_child(stat_help_popup)

## Shows the tutorial over the current screen (first dungeon entry or the Settings button).
func _open_tutorial() -> void:
	if not is_instance_valid(tutorial_overlay):
		return
	tutorial_overlay.open()
	_apply_layout_insets()

## First run only: opens the tutorial the first time the player enters a dungeon, while the
## settings file has no "tutorial seen" flag. Called at the end of start_dungeon_exploration.
func _show_first_run_tutorial_if_needed() -> void:
	if SettingsStore.load_tutorial_seen(settings_path):
		return
	_open_tutorial()

## Skipping and finishing both count as "seen": the tutorial is not shown automatically again.
func _on_tutorial_closed(_completed: bool) -> void:
	SettingsStore.save_tutorial_seen(true, settings_path)

## Builds the Level Up "what each stat does" card inside `parent` and returns its row container.
func _create_allocation_stat_guide(parent: Container) -> VBoxContainer:
	var card := PanelContainer.new()
	card.name = "StatGuideCard"
	card.theme_type_variation = &"CardPanel"
	parent.add_child(card)
	var guide := VBoxContainer.new()
	guide.name = "StatGuide"
	guide.add_theme_constant_override("separation", 10)
	card.add_child(guide)
	return guide

## Fills the stat guide: per allocatable stat, its name, the gain of one point for this
## player's class, and the shared stat description.
func _rebuild_allocation_stat_guide() -> void:
	if not is_instance_valid(allocation_stat_guide):
		return
	for child: Node in allocation_stat_guide.get_children():
		allocation_stat_guide.remove_child(child)
		child.free()
	var title := _create_label("Title", &"HeaderLabel")
	title.text = tr(ALLOCATION_GUIDE_TITLE_KEY)
	allocation_stat_guide.add_child(title)
	for stat_key: String in ALLOCATABLE_STATS:
		allocation_stat_guide.add_child(_create_stat_guide_entry(stat_key))

## One stat guide entry: tinted icon, "Name: +N per point" heading and the description below.
func _create_stat_guide_entry(stat_key: String) -> VBoxContainer:
	var entry := VBoxContainer.new()
	entry.name = "%sGuide" % stat_key.capitalize().replace(" ", "")
	entry.add_theme_constant_override("separation", 2)
	var heading_row := HBoxContainer.new()
	heading_row.name = "Heading"
	heading_row.add_theme_constant_override("separation", 6)
	entry.add_child(heading_row)
	var icon := TextureRect.new()
	icon.name = "Icon"
	icon.texture = load(String(STAT_ICON_PATHS[stat_key]))
	icon.modulate = _get_stat_color(stat_key)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.custom_minimum_size = Vector2(20, 20)
	heading_row.add_child(icon)
	var heading := _create_label("Name", &"", false)
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	var growth := CombatRules.get_stat_growth_for_player(player_state, stat_key)
	heading.text = "%s: %s" % [StatHelp.get_stat_name(stat_key), tr(ALLOCATION_GUIDE_GROWTH_KEY) % str(growth)]
	heading.add_theme_color_override("font_color", _get_stat_color(stat_key))
	heading_row.add_child(heading)
	var description := _create_label("Description", &"CaptionLabel")
	description.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	description.text = StatHelp.get_stat_description(stat_key)
	entry.add_child(description)
	return entry

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
	row.custom_minimum_size = Vector2(0, 24)
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_theme_constant_override("separation", 6)
	var icon := TextureRect.new()
	icon.name = "Icon"
	icon.texture = load(String(STAT_ICON_PATHS.get(stat_key, STAT_ICON_PATHS["life"])))
	icon.modulate = stat_color
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon.custom_minimum_size = Vector2(20, 20)
	row.add_child(icon)
	if stat.has("label_key"):
		var stat_label := Label.new()
		stat_label.name = "Label"
		stat_label.text = tr(String(stat["label_key"]))
		stat_label.custom_minimum_size = Vector2(82 if compact else 96, 0)
		stat_label.add_theme_font_size_override("font_size", UiTheme.FONT_STAT)
		stat_label.add_theme_color_override("font_color", UiTheme.TEXT_MUTED)
		stat_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		stat_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		row.add_child(stat_label)
	var bar := ProgressBar.new()
	bar.name = "Bar"
	bar.show_percentage = false
	bar.max_value = maximum
	bar.value = clamped_current
	bar.custom_minimum_size = Vector2(72 if compact else 96, 24)
	bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bar.add_theme_stylebox_override("fill", _create_stat_stylebox(stat_color))
	bar.add_theme_stylebox_override("background", _create_stat_stylebox(UiTheme.SURFACE_SUNKEN))
	var value := Label.new()
	value.name = "Value"
	value.text = "%s/%s" % [str(maxi(0, current)), str(maximum)]
	value.add_theme_font_size_override("font_size", UiTheme.FONT_STAT_VALUE)
	# White text with a dark outline stays readable on pastel fills and on the dark empty segment.
	value.add_theme_color_override("font_color", Color.WHITE)
	value.add_theme_color_override("font_outline_color", Color(0.05, 0.03, 0.02, 0.95))
	value.add_theme_constant_override("outline_size", 5)
	value.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	value.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	value.set_anchors_preset(Control.PRESET_FULL_RECT)
	bar.add_child(value)
	row.add_child(bar)
	# Tapping the bar (icon, label or value) explains the stat in the shared popup.
	if is_instance_valid(stat_help_popup):
		stat_help_popup.attach(row, stat_key, stat_color)
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
	_activate_screen(level_allocation_view, AdSlotConfig.SCREEN_LEVEL_UP)
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
	_rebuild_allocation_stat_guide()
	_rebuild_class_choices()
	allocation_confirm_button.disabled = reserved_points <= 0 or _get_staged_points() <= 0

func _rebuild_allocation_rows(reserved_points: int, remaining: int) -> void:
	for child: Node in allocation_buttons_container.get_children():
		if child is CanvasItem:
			(child as CanvasItem).visible = false
		child.queue_free()
	for stat_key: String in ALLOCATABLE_STATS:
		allocation_buttons_container.add_child(_create_allocation_row(stat_key, reserved_points, remaining))

func _create_allocation_row(stat_key: String, reserved_points: int, remaining: int) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.name = "%sAllocationRow" % stat_key.capitalize()
	row.custom_minimum_size = Vector2(0, UiTheme.TOUCH_MIN)
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
	points_label.custom_minimum_size = Vector2(34, 24)
	points_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	points_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	points_label.add_theme_color_override("font_color", UiTheme.ACCENT_BRIGHT if int(staged_allocation.get(stat_key, 0)) > 0 else UiTheme.TEXT_MUTED)
	row.add_child(points_label)

	var minus_button := Button.new()
	minus_button.name = "MinusButton"
	minus_button.text = "−"
	minus_button.theme_type_variation = &"IconButton"
	minus_button.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	minus_button.custom_minimum_size = Vector2(UiTheme.ICON_BUTTON_SIZE, UiTheme.ICON_BUTTON_SIZE)
	minus_button.disabled = reserved_points <= 0 or int(staged_allocation.get(stat_key, 0)) <= 0
	minus_button.pressed.connect(Callable(self, "_stage_level_point_delta").bind(stat_key, -1), CONNECT_DEFERRED)
	row.add_child(minus_button)

	var plus_button := Button.new()
	plus_button.name = "PlusButton"
	plus_button.text = "+"
	plus_button.theme_type_variation = &"IconButton"
	plus_button.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	plus_button.custom_minimum_size = Vector2(UiTheme.ICON_BUTTON_SIZE, UiTheme.ICON_BUTTON_SIZE)
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
	var title := _create_label("ClassChoiceTitle", &"HeaderLabel")
	title.text = tr(CLASS_CHOICE_TITLE_KEY)
	class_choice_container.add_child(title)
	for player_class: Dictionary in CombatRules.load_player_classes():
		var button := _create_button("%sClassButton" % String(player_class.get("id", "class")).capitalize())
		var class_id := String(player_class.get("id", ""))
		button.text = LocalizedNames.player_class(class_id, String(player_class.get("name", class_id)))
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

## Completes the dungeon when every monster is defeated and shows its result. `victory_summary`
## (the last fight's victory lines) is placed above the rewards so one modal covers both.
func _complete_dungeon_if_ready(_experience_gained: int, victory_summary: String = "") -> bool:
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
	var rewards := tr("DUNGEON_COMPLETED_REWARDS") % [str(experience_gained), str(reputation_gained)]
	_show_game_result(tr(RESULT_COMPLETED_TITLE_KEY), _join_lines([victory_summary, rewards]))
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
		_warn_if_energy_low()
		_persist_run_checkpoint()
		return

	_update_monster_encounter()
	_warn_if_energy_low()
	_persist_run_checkpoint()

func _format_combat_feedback(result: Dictionary) -> String:
	if bool(result.get("insufficient_resources", false)):
		return tr(String(result.get("message_key", "COMBAT_INSUFFICIENT_RESOURCES")))
	var parts: Array[String] = []
	if bool(result.get("critical", false)):
		parts.append(tr("COMBAT_FEEDBACK_PLAYER_CRITICAL"))
	elif bool(result.get("hit", false)):
		parts.append(tr("COMBAT_FEEDBACK_PLAYER_HIT"))
	elif bool(result.get("dodged", false)):
		parts.append(tr("COMBAT_FEEDBACK_PLAYER_DODGED"))
	elif bool(result.get("miss", false)):
		parts.append(tr("COMBAT_FEEDBACK_PLAYER_PROTECTED"))
	else:
		parts.append(tr("COMBAT_FEEDBACK_PLAYER_MISSED"))

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

## Fight-log sentence for the monster's attack. `english_attack_name` is the data name and is
## translated here, so every caller gets the localized attack name.
func _format_monster_attack_feedback(english_attack_name: String, result: Dictionary) -> String:
	var attack_name := LocalizedNames.ability(english_attack_name)
	if bool(result.get("counterattack_critical", false)):
		return tr("COMBAT_FEEDBACK_MONSTER_CRITICAL") % attack_name
	if bool(result.get("counterattack_hit", false)):
		return tr("COMBAT_FEEDBACK_MONSTER_HIT") % attack_name
	if bool(result.get("counterattack_dodged", false)):
		return tr("COMBAT_FEEDBACK_MONSTER_DODGED") % attack_name
	if bool(result.get("counterattack_miss", false)):
		return tr("COMBAT_FEEDBACK_MONSTER_PROTECTED") % attack_name
	return tr("COMBAT_FEEDBACK_MONSTER_MISSED") % attack_name

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
		var effect_names := PackedStringArray()
		for effect_variant: Variant in effects:
			effect_names.append(LocalizedNames.effect(String(effect_variant)))
		var effect_text := tr("ENCOUNTER_MONSTER_NO_EFFECTS") if effect_names.is_empty() else ", ".join(effect_names)
		lines.append(tr(MONSTER_ATTACK_LINE_KEY) % [
			LocalizedNames.ability(String(attack.get("name", "Attack"))),
			# Show the damage the attack really deals, including the monster's Strength bonus.
			str(CombatRules.get_attack_damage(attack, false, int(monster.get("current_strength", monster.get("strength", 0))))),
			str(int(attack.get("mana_cost", attack.get("energy_cost", 0)))),
			str(int(attack.get("unlock_level", 1))),
			effect_text,
		])
	if lines.is_empty():
		lines.append(tr("ENCOUNTER_MONSTER_NO_ATTACKS"))
	monster_info_text.text = "\n".join(lines)
	monster_info_modal.visible = true

func _hide_monster_info() -> void:
	if is_instance_valid(monster_info_modal):
		monster_info_modal.visible = false
