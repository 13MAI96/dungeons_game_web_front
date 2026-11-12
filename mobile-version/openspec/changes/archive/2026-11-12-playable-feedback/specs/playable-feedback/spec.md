## ADDED Requirements

### Requirement: Existing saves are protected from replacement
The mobile game SHALL request confirmation before Start Game replaces a valid existing save.

#### Scenario: Existing save replacement is canceled
- **WHEN** a valid save exists
- **AND** the player selects Start Game and then Cancel
- **THEN** the existing player and save remain unchanged

#### Scenario: Existing save replacement is confirmed
- **WHEN** a valid save exists
- **AND** the player selects Start Game and then Confirm
- **THEN** a fresh default player replaces the existing save

#### Scenario: No existing save exists
- **WHEN** no valid save exists
- **AND** the player selects Start Game
- **THEN** a new game starts without an overwrite confirmation

### Requirement: Leaving the game hub is confirmed
The mobile game SHALL request confirmation before returning from the game hub to the main menu.

#### Scenario: Exit is canceled
- **WHEN** the player selects Exit and then Cancel
- **THEN** the game hub remains visible

#### Scenario: Exit is confirmed
- **WHEN** the player selects Exit and then Confirm
- **THEN** the main menu is displayed

### Requirement: Expedition outcomes remain visible
The mobile game SHALL show a final result when an expedition reaches a stable end.

#### Scenario: Expedition ends
- **WHEN** the player completes a dungeon, retreats, runs out of energy, is defeated, or reaches terminal game over
- **THEN** a localized result title and summary are displayed
- **AND** the result remains visible until the player selects Continue
