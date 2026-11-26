extends VBoxContainer
## Fight log shown in the monster encounter, above the Fight and Flee buttons (DNG-13).
##
## Keeps the last MAX_ENTRIES attacks of the current encounter as short plain-language lines
## with numbers ("You hit Kobold for 3"). Each line starts with a coloured outcome tag
## ("Hit", "Critical!", "Dodged", "Blocked").
##
## Order: oldest at the top, newest at the bottom (chronological, like a chat). A round reads
## top-down in the order it happened (your attack, then the monster's reply), and the newest
## line is the one next to the Fight button the player just pressed. Older lines are dimmed.
##
## Entries are the dictionaries built by CombatFeedback (outcome, target, damage, text).
## The owner calls clear_entries() when a new encounter starts.

const UiTheme := preload("res://scripts/ui_theme.gd")
const CombatFeedback := preload("res://scripts/combat_feedback.gd")

## How many attacks the log keeps. Two rounds of "player attack + monster reply".
const MAX_ENTRIES := 4
## Space reserved for MAX_ENTRIES one-line entries, so the buttons do not jump as the log fills.
const ROW_HEIGHT := 19
const FONT_SIZE := 14
const TAG_FONT_SIZE := 13
## Opacity of every entry except the newest one.
const OLDER_ENTRY_ALPHA := 0.6

## Tag colours: damage to the monster is good news (gold), damage to the player is bad news
## (red), and an attack that did no damage is neutral (blue-grey).
const COLOR_DAMAGE_TO_MONSTER := UiTheme.ACCENT_BRIGHT
const COLOR_DAMAGE_TO_PLAYER := Color("ff8a70")
const COLOR_NO_DAMAGE := Color("9fc3d6")

## Entries currently kept, oldest first (read by tests).
var entries: Array[Dictionary] = []

func _init() -> void:
	name = "FightLog"
	add_theme_constant_override("separation", 2)
	custom_minimum_size = Vector2(0, ROW_HEIGHT * MAX_ENTRIES)
	mouse_filter = Control.MOUSE_FILTER_IGNORE

## Appends entries (oldest first) and drops the oldest ones beyond MAX_ENTRIES.
func add_entries(new_entries: Array[Dictionary]) -> void:
	for entry: Dictionary in new_entries:
		entries.append(entry)
	while entries.size() > MAX_ENTRIES:
		entries.pop_front()
	_render()

## Empties the log (a new encounter starts).
func clear_entries() -> void:
	entries.clear()
	_render()

## Sentences of the kept entries, oldest first (used by tests and for debugging).
func get_entry_texts() -> Array[String]:
	var texts: Array[String] = []
	for entry: Dictionary in entries:
		texts.append(String(entry.get("text", "")))
	return texts

## Colour of an entry's outcome tag (see the COLOR_* constants).
static func tag_color(entry: Dictionary) -> Color:
	if int(entry.get("damage", 0)) <= 0:
		return COLOR_NO_DAMAGE
	if String(entry.get("target", "")) == CombatFeedback.TARGET_PLAYER:
		return COLOR_DAMAGE_TO_PLAYER
	return COLOR_DAMAGE_TO_MONSTER

## Rebuilds the rows from `entries`. At most MAX_ENTRIES small rows, so rebuilding is cheap.
func _render() -> void:
	for child: Node in get_children():
		remove_child(child)
		child.queue_free()
	for index in entries.size():
		var row := _create_row(entries[index])
		var is_newest := index == entries.size() - 1
		row.modulate.a = 1.0 if is_newest else OLDER_ENTRY_ALPHA
		add_child(row)

## One log line: the outcome tag, then the sentence (wraps to a second line when needed).
func _create_row(entry: Dictionary) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.name = "FightLogEntry"
	row.add_theme_constant_override("separation", 6)
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var tag := Label.new()
	tag.name = "Outcome"
	tag.text = CombatFeedback.outcome_label(String(entry.get("outcome", "")))
	tag.add_theme_font_size_override("font_size", TAG_FONT_SIZE)
	tag.add_theme_color_override("font_color", tag_color(entry))
	tag.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	row.add_child(tag)

	var sentence := Label.new()
	sentence.name = "Text"
	sentence.text = String(entry.get("text", ""))
	sentence.add_theme_font_size_override("font_size", FONT_SIZE)
	sentence.add_theme_color_override("font_color", UiTheme.TEXT)
	sentence.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	sentence.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(sentence)
	return row
