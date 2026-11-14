## MODIFIED Requirements

### Requirement: Stable progression is saved automatically
The mobile game SHALL save player state after stable progression, after every dungeon action and at dungeon-exit checkpoints.

#### Scenario: Permanent progression changes
- **WHEN** the player confirms stat allocation or selects a class
- **THEN** the updated player is persisted

#### Scenario: Dungeon reaches a stable exit
- **WHEN** the player retreats, completes a dungeon, runs out of energy, abandons the expedition, or survives defeat
- **THEN** the resolved post-dungeon player state is persisted
- **AND** no active run remains in the save

## REMOVED Requirements

### Requirement: Saves preserve permanent experience only
**Reason**: Discarding an interrupted run let players dodge the death penalty by closing the app and lost runs interrupted by the system.
**Migration**: See "Interrupted dungeon runs resume".

## ADDED Requirements

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
