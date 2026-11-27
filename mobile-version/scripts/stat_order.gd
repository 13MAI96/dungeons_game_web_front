extends RefCounted
## Canonical stat order shared by every screen that lists stats (DNG-19).
##
## The hub, the exploration HUD, the Level Up rows and stat guide, and both sides of the fight
## panel show different subsets of the stats, but always in this one order, so a stat never
## changes place between screens. Screens declare which stats they show; `select()` returns
## them in the canonical order, keeping the relative order when some stats are left out.

## Every stat key a screen can show, in display order: the resources first (life, energy,
## mana), then the combat stats (armor, strength, speed), then the progression counters.
const CANONICAL := [
	"life",
	"energy",
	"mana",
	"armor",
	"strength",
	"speed",
	"reputation",
	"experience",
	"dungeon_experience",
]

## Returns the stats of `stat_keys` in canonical order. Keys missing from CANONICAL are
## dropped, so a typo in a screen list shows up as a missing bar in the tests, not a stray one.
static func select(stat_keys: Array) -> Array:
	var ordered: Array = []
	for stat_key: String in CANONICAL:
		if stat_keys.has(stat_key):
			ordered.append(stat_key)
	return ordered

## True when `stat_keys` lists its stats in canonical order (used by the tests to compare
## what each screen really shows).
static func is_canonical(stat_keys: Array) -> bool:
	return select(stat_keys) == stat_keys
