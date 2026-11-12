## ADDED Requirements

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
The mobile game SHALL save permanent player state after stable progression and dungeon-exit checkpoints.

#### Scenario: Permanent progression changes
- **WHEN** the player confirms stat allocation or selects a class
- **THEN** the updated player is persisted

#### Scenario: Dungeon reaches a stable exit
- **WHEN** the player retreats, completes a dungeon, runs out of energy, or survives defeat
- **THEN** the resolved post-dungeon player state is persisted
- **AND** active dungeon and encounter state are not persisted

### Requirement: Invalidated saves are removed
The mobile game SHALL remove the local save when death rules invalidate the character.

#### Scenario: Terminal death invalidates the character
- **WHEN** the death sequel reduces effective maximum life to zero
- **THEN** the local save is deleted
- **AND** Load Game becomes disabled
- **AND** the app returns to the main menu after displaying death feedback
