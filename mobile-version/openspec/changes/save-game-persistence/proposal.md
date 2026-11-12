## Why

Player progression currently exists only in memory, so closing the app loses levels, allocated statistics, class choices, reputation, and death sequels. The visible Load Game action also has no behavior.

## What Changes

- Store stable player progression in a versioned local save file.
- Create a fresh save when the player starts a new game.
- Enable Load Game only when a valid save exists and restore it when selected.
- Save after stable progression changes and completed dungeon exits.
- Delete the stored save when death rules invalidate the character.
- Exclude active dungeon and combat state from persistence.

## Capabilities

### New Capabilities
- `save-game-persistence`: Defines local player save creation, loading, automatic checkpoints, validation, and deletion.

### Modified Capabilities
- `localized-main-menu`: Connect the existing Start Game and Load Game actions to persistence behavior.

## Impact

- `scripts/save_game.gd` owns versioned file access and player-state normalization.
- `scripts/main.gd` connects menu actions and stable gameplay checkpoints.
- `scenes/main.tscn` starts a new persisted game from the main menu.
- Headless tests cover round trips, loading, and deletion.
