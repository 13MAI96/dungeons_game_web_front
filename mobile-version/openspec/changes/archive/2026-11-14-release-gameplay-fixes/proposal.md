## Why

A release-readiness review and a 150-run automated play-through found rule exploits and data-loss risks that block a 1.0 release: infinite sanctuary healing, runs lost (or deaths dodged) by closing the app, a non-atomic save, the Android back gesture quitting from any screen, a winning blow forfeiting the run, a dead Fight button, invisible level-ups, a Mage stat that never grows and unreadable saves overwritten without warning.

## What Changes

- Sanctuaries restore once per dungeon run.
- Monster defeat and dungeon completion resolve before the energy/life depletion check.
- Saves are replaced atomically and recovered from the temporary file if the app died mid-write.
- The active dungeon run (map, position, encounter, provisional experience) is persisted at every action and when the app is paused; Load Game resumes it. **BREAKING** for the spec rule that loaded saves never contain an active run.
- Android back navigates within the game (close modal, previous screen, confirm leaving); the app saves on pause/close.
- Exploration offers abandoning the expedition via back, losing provisional experience.
- Fight is disabled with an explanation when the attack cannot be paid.
- The pending-progression indicator also shows when experience already allows a level-up.
- Class stat growth values are positive integers (Mage armor 0.5 → 1).
- Start Game asks for confirmation whenever a save file exists, even an unreadable one.

## Capabilities

### New Capabilities
- (none)

### Modified Capabilities
- `combat-rules`: sanctuary single use.
- `save-game-persistence`: atomic save, active-run persistence and resume.
- `playable-feedback`: overwrite protection covers unreadable saves.
- `new-game-view`: indicator covers convertible level-ups.
- `monster-encounter`: unaffordable attack disabled; defeat resolved before depletion.
- `app-shell`: Android back navigation and save on pause.
- `dungeon-exploration`: abandon expedition.
- `player-classes`: integer growth.

## Impact

`scripts/main.gd`, `scripts/save_game.gd`, `scripts/combat_rules.gd`, `data/player_classes.json`, `project.godot`, localization files, tests. Save format version 1 → 2 (version 1 saves still load).
