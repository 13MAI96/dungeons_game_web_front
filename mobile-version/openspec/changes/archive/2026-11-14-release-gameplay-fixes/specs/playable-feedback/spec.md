## MODIFIED Requirements

### Requirement: Existing saves are protected from replacement
The mobile game SHALL request confirmation before Start Game replaces any existing save file, including one that cannot be loaded.

#### Scenario: Existing save replacement is canceled
- **WHEN** a valid save exists
- **AND** the player selects Start Game and then Cancel
- **THEN** the existing player and save remain unchanged

#### Scenario: Existing save replacement is confirmed
- **WHEN** a valid save exists
- **AND** the player selects Start Game and then Confirm
- **THEN** a fresh default player replaces the existing save

#### Scenario: Unreadable save exists
- **WHEN** a save file exists but cannot be loaded
- **AND** the player selects Start Game
- **THEN** a confirmation is shown before the file is replaced

#### Scenario: No existing save exists
- **WHEN** no valid save exists
- **AND** no save file exists
- **AND** the player selects Start Game
- **THEN** a new game starts without an overwrite confirmation
