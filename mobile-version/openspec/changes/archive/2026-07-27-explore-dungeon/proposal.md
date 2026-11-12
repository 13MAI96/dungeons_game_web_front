## Why

The new game view currently exposes "Explore Dungeon" but it does not lead to gameplay. This change introduces the first dungeon exploration loop: map navigation, movement choices, resting/retreat actions, and monster encounters.

## What Changes

- Make the new game view's explore-dungeon action open a dungeon exploration view.
- Generate a square or rectangular dungeon map using the same rules as `dungeons_back`:
  - Random dimensions derived from `dungeon_type`.
  - Locations for each row/column coordinate.
  - Entrance selected from map edge locations.
  - Location content chosen from monster, quest, block, and sanctuary options with progressive option additions based on monster count.
- Show the dungeon map in the upper portion of the screen and player actions in the lower portion.
- Provide four always-visible directional movement buttons with arrow controls.
- Disable movement buttons when the target direction is blocked by map bounds or a block location.
- Allow the player to move back to the previous location.
- Include lower exploration actions for Rest and Retreat.
- When entering a location containing a living monster, switch to an encounter view.
- In encounter view, show monster image/details and player characteristics in the upper portion.
- In encounter view, show available attacks and a flee action in the lower portion.
- Keep defeated monsters from reappearing as encounters.

## Capabilities

### New Capabilities
- `dungeon-exploration`: Defines dungeon map generation, map display, movement constraints, rest, and retreat during exploration.
- `monster-encounter`: Defines the monster encounter view, monster/player presentation, attack actions, and flee action.

### Modified Capabilities
- `new-game-view`: The explore-dungeon option now opens the dungeon exploration view.

## Impact

- Godot scene structure under `res://scenes`.
- GDScript dungeon generation, location model, movement state, and encounter state under `res://scripts`.
- Localization resources for exploration, movement, rest, retreat, attack, and flee labels.
- Tests for dungeon generation shape/rules, movement constraints, and encounter transitions.
