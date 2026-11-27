## Why

Strength and speed swap places between screens. The hub lists armor, strength, speed; the Level Up rows and stat guide list armor, speed, strength; the monster side of the fight panel lists armor, speed, strength while the player side lists armor, strength, speed. Each screen had its own hard-coded list, so players looking for a stat had to search again on every screen. Vikunja task DNG-19.

## What Changes

- **One canonical order:** life, energy, mana, armor, strength, speed, reputation, total XP, dungeon XP. Resources first (what you spend while exploring), then the combat stats, then the progression counters. This is the order the hub already used, so the main screen does not change.
- **One shared list:** new `scripts/stat_order.gd` holds `StatOrder.CANONICAL` and `StatOrder.select(keys)`. Each screen only declares which stats it shows; `select()` returns them in the canonical order, keeping the relative order when stats are left out.
- **Every screen derives its order from it:** hub, exploration HUD, Level Up rows, Level Up stat guide, fight panel (player and monster). Level Up and the monster panel now show strength before speed.
- No new texts.

## Capabilities

### New Capabilities
- None.

### Modified Capabilities
- `app-shell`: stats keep one order on every screen.
- `level-up-allocation`: the assignable statistics follow the canonical order.
- `monster-encounter`: the monster stats follow the canonical order.

## Impact

New `scripts/stat_order.gd`. `scripts/main.gd`: `PLAYER_STATS`, `ENCOUNTER_PLAYER_STATS`, `EXPLORATION_STATS`, `MONSTER_STATS` and `ALLOCATABLE_STATS` become lists of stat keys; `_populate_stat_bars()`, `_create_stat_bar()`, the allocation rows and the stat guide go through `StatOrder.select()`; stat rows and guide entries carry their stat key as `stat_key` meta. `tests/verify_stat_help.gd` uses the new orders. New `tests/verify_stat_order.gd`. `tools/playtest_bot.gd` is unchanged: its `ALLOCATION_ORDERS` are spending strategies, not a display order. No rule, save or text change.
