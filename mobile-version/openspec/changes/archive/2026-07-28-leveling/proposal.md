## Why

The mobile prototype already tracks experience, reputation, player level, and monster levels, but those values do not yet drive level-up decisions, stat growth, or monster scaling. This change defines the next progression layer so dungeon rewards can feed durable character growth and generated encounters can scale with the player.

## What Changes

- Add player level-up eligibility when current experience reaches or exceeds the required threshold; experience may exceed the threshold and is not capped by the bar maximum.
- Grant 3 permanent improvement points when the player reaches a level-up threshold.
- Add an allocation flow from the manage equipment action, with an updated name if needed, where level-up points can be assigned once and cannot be reassigned.
- Apply stat point rules: life +5, energy +5, mana +4, armor +1, speed +1, and strength +1.
- Make reputation level-up automatic while keeping it behavior-neutral for now.
- Generate monster levels based on the current player level.
- Scale generated monsters by assigning 2 random stat points for every monster level above 1 using the same stat-growth rules as the player.
- Add monster attack unlock levels so only attacks available at the generated monster level are included.
- Defer player attack and ability unlock rules to a future change.

## Capabilities

### New Capabilities
- `level-up-allocation`: Covers level-up eligibility, pending improvement points, irreversible stat allocation, and the manage-equipment allocation flow.

### Modified Capabilities
- `player-progression-rules`: Experience overflow, level-up points, stat-growth values, and automatic reputation level progression.
- `monster-progression-rules`: Monster level ranges, per-level stat scaling, and monster attack unlock levels.
- `dungeon-exploration`: Dungeon generation must pass player level into monster generation and produce monsters in the allowed level range.
- `new-game-view`: The manage equipment action must expose the level-up allocation flow and may be renamed to better fit that role.

## Impact

- GDScript progression logic in `scripts/combat_rules.gd`, `scripts/dungeon_generator.gd`, and `scripts/main.gd`.
- Monster data in `data/monsters.json` to include attack unlock levels.
- New or updated UI state for pending level-up point assignment from the new-game action menu.
- Headless Godot tests for progression thresholds, point allocation, monster level generation, and attack availability.
