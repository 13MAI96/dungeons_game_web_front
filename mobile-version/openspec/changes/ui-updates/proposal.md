## Why

The current mobile UI does not clearly surface pending progression work, combat outcomes, or forced dungeon exits. This change improves feedback at key decision points so the player understands what happened before the view changes.

## What Changes

- Add a visible pending-progression indicator to the progression/manage action when the player has reserved progression points.
- Replace raw D20 roll text under actor stats with readable combat outcome messages.
- Report what happened with the player's attack, which attack the monster used, and whether the monster hit, was blocked/protected, missed, or was dodged.
- Treat retreat from the entrance as a successful alive exit even when it spends the player's last current energy point.
- Keep the dungeon entrance displayed in green at all times, including when it is visited or selected.
- Show a notification before returning to the new game view when the player is removed from a dungeon because energy is depleted.
- Show a notification before returning to the new game view when the player is removed from a dungeon because life is depleted.
- Add an information button over or near the monster image during encounters.
- Show the monster's available attacks in a tooltip or modal when the information button is used.
- Make critical hit threshold and critical damage percent configurable per player ability and monster attack.

## Capabilities

### New Capabilities

### Modified Capabilities
- `new-game-view`: Show a pending-progression indicator when the player has reserved progression points.
- `monster-encounter`: Add combat outcome summaries and monster attack information access.
- `dungeon-exploration`: Clarify entrance map color, dungeon exit behavior, and pre-exit notifications for depleted life or energy.
- `d20-roll-visualization`: Stop showing raw roll values below actor stats and rely on combat summaries instead.
- `attack-resolution-rules`: Resolve critical hits from the selected attack configuration and apply its critical damage percent.
- `player-abilities`: Require critical threshold and critical damage percent in ability JSON.
- `monster-progression-rules`: Require critical threshold and critical damage percent in monster attack JSON.

## Impact

- `scripts/main.gd` for progression indicator UI, combat feedback text, depletion notification timing, and monster info modal/tooltip.
- `scripts/combat_rules.gd` for retreat/depletion result semantics if needed.
- `scripts/combat_rules.gd` for configurable critical threshold and critical damage calculation.
- `scripts/dungeon_generator.gd` and attack JSON files for player and monster critical metadata.
- `scenes/main.tscn` only if static scene nodes are preferable to runtime-created controls.
- Localization strings for progression indicator accessibility/tooltip, combat summaries, depleted energy/life notifications, and monster attack info.
- Headless Godot tests covering progression indicator, combat summaries, successful last-energy retreat, depleted-exit notifications, and monster info display.
