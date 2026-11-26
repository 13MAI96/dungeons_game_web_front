# save-game-persistence Specification

## Purpose
Define how the local save game is created, loaded, autosaved, and invalidated.

## Requirements

### Requirement: New games create local saves
The mobile game SHALL create a versioned local player save when a new game starts.

#### Scenario: Player starts a new game
- **WHEN** the player selects Start Game
- **THEN** the app resets the player to current defaults
- **AND** persists the new player before opening the game hub

### Requirement: Valid saves can be loaded
The mobile game SHALL enable Load Game only when a supported, valid player save exists.

#### Scenario: Player loads an existing game
- **WHEN** a valid local save exists
- **AND** the player selects Load Game
- **THEN** permanent statistics, progression, class choices, abilities, reputation, and death sequels are restored
- **AND** the game hub is displayed

#### Scenario: Save is missing or invalid
- **WHEN** no supported valid local save exists
- **THEN** Load Game is disabled

### Requirement: Stable progression is saved automatically
The mobile game SHALL save player state after stable progression, after every dungeon action and at dungeon-exit checkpoints.

#### Scenario: Permanent progression changes
- **WHEN** the player confirms stat allocation or selects a class
- **THEN** the updated player is persisted

#### Scenario: Dungeon reaches a stable exit
- **WHEN** the player retreats, completes a dungeon, runs out of energy, abandons the expedition, or survives defeat
- **THEN** the resolved post-dungeon player state is persisted
- **AND** no active run remains in the save

### Requirement: Invalidated saves are removed
The mobile game SHALL remove the local save when death rules invalidate the character.

#### Scenario: Terminal death invalidates the character
- **WHEN** the death sequel reduces effective maximum life to zero
- **THEN** the local save is deleted
- **AND** Load Game becomes disabled
- **AND** the app returns to the main menu after displaying death feedback

### Requirement: Interrupted dungeon runs resume
The mobile game SHALL persist the active dungeon run and restore it when the save is loaded.

#### Scenario: Run state is saved during play
- **WHEN** the player moves, fights, flees, rests or collects treasure in a dungeon, or the app is paused or closed during a run
- **THEN** the dungeon map, player position, active encounter, current status and provisional experience are persisted

#### Scenario: Save with an active run is loaded
- **WHEN** a valid save containing an active run is loaded
- **THEN** the player returns to the same dungeon, position and encounter
- **AND** provisional dungeon experience and current life, energy and mana are restored

#### Scenario: Save without an active run is loaded
- **WHEN** a valid save without an active run is loaded
- **THEN** provisional dungeon experience is zero
- **AND** the game hub is displayed

### Requirement: Saves survive interrupted writes
The mobile game SHALL never leave the player without a loadable save because a write was interrupted.

#### Scenario: App is killed while saving
- **WHEN** the app stops after the new save was written to its temporary file but before it replaced the main file
- **THEN** the next load recovers the progress from the temporary file

#### Scenario: Save cannot be written
- **WHEN** writing the new save fails
- **THEN** the previous save file is left unchanged

### Requirement: Saved attacks follow current definitions
The mobile game SHALL refresh the player's saved attacks from the current ability definitions when a save is loaded, so balance changes reach existing players.

#### Scenario: Attack definition changed after the save was written
- **WHEN** a save is loaded whose attacks have ids present in the ability data
- **THEN** each attack uses the current damage, costs and critical values from the ability data

#### Scenario: Saved attack id no longer exists
- **WHEN** a saved attack id is not present in the ability data
- **THEN** the saved attack is kept unchanged
