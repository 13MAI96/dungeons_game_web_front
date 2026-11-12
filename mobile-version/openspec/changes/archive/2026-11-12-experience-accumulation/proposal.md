## Why

Dungeon rewards currently reuse the permanent experience field, allowing a later dungeon exit to replace or erase experience earned in previous runs.

## What Changes

- Track experience earned during the active dungeon separately from permanent accumulated experience.
- Add provisional experience to the permanent total when the player completes or voluntarily leaves a dungeon.
- Discard only provisional experience after life or energy depletion.
- Persist only the permanent accumulated total.

## Capabilities

### Modified Capabilities
- `player-progression-rules`: Experience remains cumulative across successful dungeon runs.
- `dungeon-exploration`: Dungeon exits commit or discard only the active run's experience as appropriate.
- `save-game-persistence`: Active-run experience is excluded from restored saves.

## Impact

- `scripts/combat_rules.gd` owns the provisional experience lifecycle.
- `scripts/main.gd` starts, commits, and discards dungeon experience at the corresponding transitions.
- `scripts/save_game.gd` normalizes active-run state when loading.
- Headless tests cover consecutive completions, persistence, and failed-run loss.
