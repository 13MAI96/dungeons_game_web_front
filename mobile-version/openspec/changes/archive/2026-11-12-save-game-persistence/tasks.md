## 1. Save Storage

- [x] 1.1 Add a versioned local save format under `user://`.
- [x] 1.2 Write saves through a temporary file before replacing the active file.
- [x] 1.3 Validate loaded payloads and merge known fields into current player defaults.
- [x] 1.4 Add save deletion support.

## 2. Game Integration

- [x] 2.1 Make Start Game create a fresh persisted player.
- [x] 2.2 Enable Load Game only for a valid save and restore the player when selected.
- [x] 2.3 Persist progression allocation and class selection.
- [x] 2.4 Persist stable retreat, completion, energy-depletion, and death checkpoints.
- [x] 2.5 Remove an invalidated save and return to the main menu.
- [x] 2.6 Keep active dungeon and combat state outside the save.

## 3. Verification

- [x] 3.1 Add headless tests for save/load round trips.
- [x] 3.2 Add headless tests for main-menu save integration.
- [x] 3.3 Add headless tests for invalidated-save deletion.
- [x] 3.4 Run Godot headless project load and all verification scripts.
- [x] 3.5 Run `openspec validate "save-game-persistence"`.
