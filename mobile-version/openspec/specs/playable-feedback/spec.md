# playable-feedback Specification

## Purpose
Make sure destructive actions are confirmed and expedition outcomes are shown clearly to the player.

## Requirements

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

### Requirement: Confirmations fit the screen
The mobile game SHALL show confirmation prompts as in-game modals whose title, message and both actions are fully visible on narrow screens.

#### Scenario: Long confirmation message is shown
- **WHEN** a confirmation prompt is shown on a 360 logical pixel wide screen
- **THEN** the message wraps inside the modal
- **AND** the confirm and cancel actions are fully on screen
- **AND** tapping cancel closes the modal without performing the action
