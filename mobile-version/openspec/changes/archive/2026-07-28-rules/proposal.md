## Why

The current mobile prototype uses early placeholder combat and exploration values copied from the web proof of concept, but the intended game loop now needs explicit progression, dungeon completion, recovery, and attack-resolution rules. Defining these rules now prevents UI and combat implementation from drifting as the mobile version adds attacks, monster levels, shop reputation, and larger dungeons.

## What Changes

- **BREAKING**: Replace the current web-derived combat damage formula with the new D20 attack, armor, strength, speed, dodge, and critical-hit rules.
- **BREAKING**: Replace current player base stats with the new starting model: 10 life, 25 energy, mana retained as a tracked resource, armor, strength, speed, experience, and reputation.
- **BREAKING**: Remove player damage as a standalone stat and introduce attack-specific damage for future attack definitions.
- Movement within a dungeon costs 1 energy per location.
- Resting restores a random 5-25 percent of maximum energy and 10-40 percent of maximum life, and costs 5 mana.
- Opening treasure costs 1 energy.
- Retreat costs 1 energy and is available only from the entrance, which is always shown in green.
- Leaving a dungeon alive restores energy, life, and mana.
- Dying in a dungeon applies a permanent life sequel: maximum life is reduced by 10 percent until level-up; if maximum life reaches 0, the save is considered deleted.
- Sanctuary restores between 50 and 100 percent of maximum life, energy, and mana.
- Mana can only be restored by sanctuary, leaving a dungeon alive, or future consumible/potion rules.
- Experience-to-next-level starts at 10 for level 1, increases by 10 through level 10, and then increases by 10 percent plus `level / 10` per level.
- Reputation thresholds match experience through level 10, then increase by 25 percent plus `level / 10` per level.
- Reputation earned from a dungeon equals the number of monsters defeated only when the dungeon is fully completed.
- A dungeon is complete when all monsters in it are defeated; completion exits the dungeon automatically and reports experience and reputation gained.
- Exploration shows the experience bar alongside life, energy, and mana.
- Dungeon visible viewport remains 5 by 7; generated dungeon size remains capped at 5 by 7 until player level 10, then can expand up to 25 by 25 while still rendering a 5 by 7 window.
- Monsters gain level, speed, strength, mana, armor, life bars, and 2-5 future attack definitions.
- Monster names display their level as `Lv. N`.
- Combat surfaces D20 roll values below the stats of the entity that rolled, using an updated `d20.svg` that shows the rolled value on the main face.

## Capabilities

### New Capabilities
- `player-progression-rules`: Covers player base stats, level thresholds, reputation thresholds, life sequels after death, and restoration after leaving a dungeon alive.
- `attack-resolution-rules`: Covers the new D20 attack, armor, strength, speed, dodge, critical-hit, and roll-display behavior.
- `monster-progression-rules`: Covers monster level display, monster stat set, and future attack-count requirements.
- `d20-roll-visualization`: Covers showing dice roll values in combat and updating the D20 visual asset.

### Modified Capabilities
- `combat-rules`: Replace old web-derived damage/recovery/depletion rules with the new game rules where combat behavior overlaps.
- `dungeon-exploration`: Update movement energy cost, rest behavior, retreat restrictions, entrance coloring, dungeon-size limits, automatic completion exit, completion rewards, and exploration stats.
- `monster-encounter`: Update monster stat presentation, monster level display, attack resolution feedback, and player/rival roll displays.
- `new-game-view`: Update player stat presentation to remove damage and include strength and speed.

## Impact

- GDScript rule modules under `res://scripts`, especially combat, dungeon generation, movement, recovery, and player state helpers.
- Godot UI construction in the main scene script for stat bars, exploration actions, encounter layout, completion feedback, and D20 roll display.
- Local visual assets, including adding or updating `d20.svg`.
- Headless Godot tests for player defaults, movement/rest/retreat costs, dungeon completion, combat resolution, level/reputation thresholds, monster stat display, and dice roll presentation.
