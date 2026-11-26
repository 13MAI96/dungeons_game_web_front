## Why

An automated play-through of the real game (cautious player, 4–6 games × 80–150 runs) showed progression was effectively blocked: 0% of dungeons completed, 66% of runs ended out of energy, ~140 runs to reach level 2, and from level 10 dungeons averaged 68 monsters (up to 213) while experience thresholds grew 120% per level, a permanent wall.

## What Changes

- Basic attack: 3 damage, 1 energy (was 2 and 2).
- Strength adds damage for every attacker: `+max(0, floor((strength - 3) / 2))`, so damage keeps pace with monster growth.
- Level-1 monster armor lowered to 1–5 (was up to 9); Golem, Wolf and Giant Scorpion life slightly lower.
- Monster experience = template experience × 4 (was × 1).
- Monster count uses one formula at every level (`5 + floor((level - 1) / 3)` plus 0–2); from level 10 the map grows with the level (max 25×25) instead of jumping to 25×25 with 25–35% monsters.
- Monster level range: up to 2 below the player before level 10; 3 below to 1 above from level 10 (was ±5).
- Post-level-10 thresholds grow by `(10 + level / 10)` percent (experience) and `(25 + level / 10)` percent (reputation) per level (was 110–135% per level).
- Saved attacks are refreshed from the ability data on load, so these changes reach existing saves.
- New `tools/playtest.gd` + `tools/playtest_bot.gd` and `tests/verify_balance.gd` regression guard.

## Measured result (6 games × 80 runs, same bot)

| Metric | Before | After |
|---|---|---|
| Dungeons completed | 0% | 56% |
| Ran out of energy | 66% | 6% |
| Died | 5% | 4.8% |
| Runs to level 2 / 10 / 20 | ~140 / never / never | 5 / 25 / 54 |
| Level 10+ dungeons completed | 0% | 51% |

## Capabilities

### Modified Capabilities
- `attack-resolution-rules`: strength damage bonus.
- `dungeon-exploration`: monster count and map size from level 10.
- `player-progression-rules`: post-10 threshold growth.
- `monster-progression-rules`: experience reward, level ranges.
- `save-game-persistence`: saved attacks follow current definitions.

## Impact

`data/monsters.json`, `data/player_abilities.json`, `scripts/combat_rules.gd`, `scripts/dungeon_generator.gd`, `scripts/main.gd`, tests, tools. Existing saves keep levels and experience; their attacks update on load.
