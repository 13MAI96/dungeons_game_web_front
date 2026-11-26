extends RefCounted
## Turns a combat result from CombatRules into plain-language feedback (DNG-13).
##
## A fight round has up to two attacks: the player's attack on the monster and the monster's
## counterattack (also used when a flee attempt fails). Each attack becomes one *entry*:
##
##   {"outcome": "hit", "target": "monster", "damage": 3, "text": "You hit Kobold for 3"}
##
## - `outcome` is one of the outcomes CombatRules really produces (see below).
## - `target` is who received the attack: "monster" or "player". The UI floats the damage
##   number (or the outcome word) over that actor's portrait.
## - `damage` is the life the target lost (0 when the attack did no damage).
## - `text` is the translated sentence shown in the fight log.
##
## Outcomes and how they map to CombatRules.resolve_attack():
##   critical - the attack roll reached the attack's critical threshold (always hits, extra damage)
##   hit      - the roll beat the defender's armor and the defender failed to dodge
##   dodged   - the roll beat the armor but the defender's dodge roll succeeded
##   blocked  - the roll did not beat the defender's armor (the rules call this "miss"; armor is
##              the only thing that makes an attack fail this way, so the player sees "Blocked")
## There is no separate "miss" outcome in the rules, so none is shown.
##
## Every function is static and reads translations through TranslationServer, so it works
## without a scene and in tests.

const LocalizedNames := preload("res://scripts/localized_names.gd")

const OUTCOME_HIT := "hit"
const OUTCOME_CRITICAL := "critical"
const OUTCOME_DODGED := "dodged"
const OUTCOME_BLOCKED := "blocked"
## Not an attack outcome: the log line for a flee attempt that failed (before the counterattack).
const OUTCOME_FLEE_FAILED := "flee_failed"

const TARGET_MONSTER := "monster"
const TARGET_PLAYER := "player"

## Short outcome label of each outcome (fight log tag and floating text when there is no damage).
const OUTCOME_LABEL_KEYS := {
	OUTCOME_HIT: "COMBAT_OUTCOME_HIT",
	OUTCOME_CRITICAL: "COMBAT_OUTCOME_CRITICAL",
	OUTCOME_DODGED: "COMBAT_OUTCOME_DODGED",
	OUTCOME_BLOCKED: "COMBAT_OUTCOME_BLOCKED",
	OUTCOME_FLEE_FAILED: "COMBAT_OUTCOME_FLEE_FAILED",
}
## Fight log sentence for each outcome of the player's attack. Placeholders: {monster},
## {attack} and {damage} (named, so each language can order them freely).
const PLAYER_ATTACK_TEXT_KEYS := {
	OUTCOME_HIT: "COMBAT_LOG_PLAYER_HIT",
	OUTCOME_CRITICAL: "COMBAT_LOG_PLAYER_CRITICAL",
	OUTCOME_DODGED: "COMBAT_LOG_PLAYER_DODGED",
	OUTCOME_BLOCKED: "COMBAT_LOG_PLAYER_BLOCKED",
}
## Fight log sentence for each outcome of the monster's attack (same placeholders).
const MONSTER_ATTACK_TEXT_KEYS := {
	OUTCOME_HIT: "COMBAT_LOG_MONSTER_HIT",
	OUTCOME_CRITICAL: "COMBAT_LOG_MONSTER_CRITICAL",
	OUTCOME_DODGED: "COMBAT_LOG_MONSTER_DODGED",
	OUTCOME_BLOCKED: "COMBAT_LOG_MONSTER_BLOCKED",
}
const FLEE_FAILED_TEXT_KEY := "COMBAT_LOG_FLEE_FAILED"

## Outcome of the player's attack in an attack_monster() result.
static func player_attack_outcome(result: Dictionary) -> String:
	return _outcome_from_flags(
		bool(result.get("critical", false)),
		bool(result.get("hit", false)),
		bool(result.get("dodged", false)))

## Outcome of the monster's attack in an attack_monster() or attempt_flee() result, or "" when
## the monster did not attack (it was defeated, or the player escaped).
static func monster_attack_outcome(result: Dictionary) -> String:
	if String(result.get("monster_attack_name", "")) == "":
		return ""
	return _outcome_from_flags(
		bool(result.get("counterattack_critical", false)),
		bool(result.get("counterattack_hit", false)),
		bool(result.get("counterattack_dodged", false)))

## Fight log entries for one attack_monster() result, in the order they happened: the player's
## attack, then the monster's counterattack when there was one.
## `monster_data_name` and `player_attack_data_name` are the English data names; they are
## translated here through LocalizedNames.
static func entries_for_attack(result: Dictionary, monster_data_name: String, player_attack_data_name: String) -> Array[Dictionary]:
	var entries: Array[Dictionary] = []
	if bool(result.get("insufficient_resources", false)):
		return entries  # No attack happened; the encounter shows a hint instead.
	var monster_name := _monster_display_name(monster_data_name)
	var player_outcome := player_attack_outcome(result)
	var damage_dealt := int(result.get("player_attack_damage", 0)) if _deals_damage(player_outcome) else 0
	entries.append(_make_entry(player_outcome, TARGET_MONSTER, damage_dealt,
		_format(PLAYER_ATTACK_TEXT_KEYS[player_outcome], monster_name, LocalizedNames.ability(player_attack_data_name), damage_dealt)))
	var counter_entry := _monster_attack_entry(result, monster_name)
	if not counter_entry.is_empty():
		entries.append(counter_entry)
	return entries

## Fight log entries for one attempt_flee() result. A successful escape leaves the encounter, so
## it has no entries; a failed one logs the failure and then the monster's attack.
static func entries_for_flee(result: Dictionary, monster_data_name: String) -> Array[Dictionary]:
	var entries: Array[Dictionary] = []
	if not bool(result.get("failed", false)):
		return entries
	var monster_name := _monster_display_name(monster_data_name)
	entries.append(_make_entry(OUTCOME_FLEE_FAILED, TARGET_PLAYER, 0,
		TranslationServer.translate(FLEE_FAILED_TEXT_KEY).format({"monster": monster_name})))
	var counter_entry := _monster_attack_entry(result, monster_name)
	if not counter_entry.is_empty():
		entries.append(counter_entry)
	return entries

## Translated short label of an outcome ("Hit", "Critical!", "Dodged", "Blocked").
static func outcome_label(outcome: String) -> String:
	return TranslationServer.translate(String(OUTCOME_LABEL_KEYS.get(outcome, "")))

## Text that floats over the target: "-3" for damage, "Critical! -6" for a critical, and the
## outcome word ("Dodged", "Blocked") when the attack did no damage. "" for entries that have
## no float (the flee failure line).
static func float_text(entry: Dictionary) -> String:
	var outcome := String(entry.get("outcome", ""))
	if outcome == OUTCOME_FLEE_FAILED:
		return ""
	if not _deals_damage(outcome):
		return outcome_label(outcome)
	var damage_text := "-%d" % int(entry.get("damage", 0))
	if outcome == OUTCOME_CRITICAL:
		return "%s %s" % [outcome_label(outcome), damage_text]
	return damage_text

## True for the outcomes in which the attack lands and takes life.
static func _deals_damage(outcome: String) -> bool:
	return outcome == OUTCOME_HIT or outcome == OUTCOME_CRITICAL

## Maps the CombatRules flags of one attack to an outcome. resolve_attack() sets exactly one
## of hit (critical implies hit), dodged or miss; miss is reported as "blocked" (see header).
static func _outcome_from_flags(critical: bool, hit: bool, dodged: bool) -> String:
	if critical:
		return OUTCOME_CRITICAL
	if hit:
		return OUTCOME_HIT
	if dodged:
		return OUTCOME_DODGED
	return OUTCOME_BLOCKED

## Entry for the monster's attack in a result, or {} when the monster did not attack.
static func _monster_attack_entry(result: Dictionary, monster_name: String) -> Dictionary:
	var outcome := monster_attack_outcome(result)
	if outcome == "":
		return {}
	var damage_taken := int(result.get("counterattack_damage", 0)) if _deals_damage(outcome) else 0
	var attack_name := LocalizedNames.ability(String(result.get("monster_attack_name", "")))
	return _make_entry(outcome, TARGET_PLAYER, damage_taken,
		_format(MONSTER_ATTACK_TEXT_KEYS[outcome], monster_name, attack_name, damage_taken))

static func _make_entry(outcome: String, target: String, damage: int, text: String) -> Dictionary:
	return {"outcome": outcome, "target": target, "damage": damage, "text": text}

## Translates `key` and fills its {monster}, {attack} and {damage} placeholders.
static func _format(key: String, monster_name: String, attack_name: String, damage: int) -> String:
	return TranslationServer.translate(key).format({
		"monster": monster_name,
		"attack": attack_name,
		"damage": str(damage),
	})

## Translated monster name; the generic "Monster" when the data has no name.
static func _monster_display_name(monster_data_name: String) -> String:
	if monster_data_name.is_empty():
		return TranslationServer.translate("ENCOUNTER_MONSTER")
	return LocalizedNames.monster(monster_data_name)
