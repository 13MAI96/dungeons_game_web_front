## ADDED Requirements

### Requirement: Settings can reopen the how-to-play tutorial
The Settings view SHALL offer a How to play action that opens the how-to-play tutorial at any time.

#### Scenario: Player reopens the tutorial
- **WHEN** the player selects How to play in Settings
- **THEN** the tutorial opens on its first page
- **THEN** closing it returns to the Settings view

### Requirement: Tutorial seen state is a persisted setting
The mobile game SHALL store whether the how-to-play tutorial was seen in the device settings, independently from player saves and together with the language preference.

#### Scenario: Tutorial seen state survives new games
- **WHEN** the tutorial was skipped or finished
- **AND** the player starts a new game or the save game is deleted
- **THEN** the tutorial remains marked as seen

#### Scenario: Settings do not overwrite each other
- **WHEN** the language preference or the tutorial seen state is saved
- **THEN** the other stored setting is kept
