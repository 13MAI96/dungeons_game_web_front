extends RefCounted
## Translates data-driven names (monsters, attacks, abilities, classes, effects) for display.
##
## The JSON files in `data/` and the saved game keep the canonical English name or id, because
## other code looks them up (monster art, class selection, saves). Only the text shown on screen
## is translated, through a translation key derived from that name or id:
##
##   monster "Giant Spider"     -> MONSTER_NAME_GIANT_SPIDER
##   attack/ability "Venom Bite" -> ABILITY_NAME_VENOM_BITE  (monster attacks and player abilities)
##   class id "knight"           -> CLASS_NAME_KNIGHT
##   effect id "poison"          -> EFFECT_NAME_POISON
##
## Adding a monster, attack, class or effect to `data/` therefore needs a matching key in both
## `localization/menu.*.po` files; `tests/verify_localization.gd` fails when one is missing.

const MONSTER_PREFIX := "MONSTER_NAME_"
const ABILITY_PREFIX := "ABILITY_NAME_"
const CLASS_PREFIX := "CLASS_NAME_"
const EFFECT_PREFIX := "EFFECT_NAME_"

## Builds the translation key for a data name: prefix + the name in upper case, with every run
## of characters other than letters and digits replaced by one underscore.
static func key_for(prefix: String, data_name: String) -> String:
	var non_alphanumeric := RegEx.create_from_string("[^A-Z0-9]+")
	var normalized := non_alphanumeric.sub(data_name.strip_edges().to_upper(), "_", true)
	return prefix + normalized.trim_prefix("_").trim_suffix("_")

## Returns the translated display name. When no translation exists (e.g. a name added to the
## data without a .po entry) it returns `fallback`, or the original name when no fallback is
## given, so the UI never shows a raw key.
static func translate(prefix: String, data_name: String, fallback: String = "") -> String:
	var untranslated := fallback if fallback != "" else data_name
	if data_name.is_empty():
		return untranslated
	var key := key_for(prefix, data_name)
	var translated := String(TranslationServer.translate(key))
	return untranslated if translated == key else translated

## Display name of a monster, from its English `name`.
static func monster(monster_name: String) -> String:
	return translate(MONSTER_PREFIX, monster_name)

## Display name of a monster attack or a player ability, from its English `name`.
static func ability(ability_name: String) -> String:
	return translate(ABILITY_PREFIX, ability_name)

## Display name of a player class, from its `id` (e.g. "mage"); `fallback_name` is the
## class's data `name`, shown when the id has no translation.
static func player_class(class_id: String, fallback_name: String = "") -> String:
	return translate(CLASS_PREFIX, class_id, fallback_name)

## Display name of a status effect, from its `id` (e.g. "poison").
static func effect(effect_id: String) -> String:
	return translate(EFFECT_PREFIX, effect_id)
