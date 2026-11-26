## ADDED Requirements

### Requirement: Each confirmation shows its own texts
The mobile game SHALL set the title, message and both button labels of the shared confirmation dialog every time it is opened, and SHALL drop a confirmation's action when the dialog closes.

#### Scenario: Confirmation follows another confirmation
- **WHEN** a confirmation is opened after any other confirmation was shown
- **THEN** it shows only its own title, message, accept label and cancel label

#### Scenario: Screen change closes a confirmation
- **WHEN** the active screen changes while a confirmation is open
- **THEN** the confirmation closes and its action can no longer run

#### Scenario: Hub exit confirmation
- **WHEN** the player presses Exit on the hub, also after leaving Level Up with staged points
- **THEN** an "Exit game?" confirmation says that progress is saved and can be continued with Load Game, with an Exit and a Cancel button
- **THEN** it does not mention allocation changes
- **THEN** confirming returns to the main menu
- **THEN** in Spanish it is shown in Spanish

## MODIFIED Requirements

### Requirement: Android back navigates within the game
The mobile game SHALL handle the system back action as in-game navigation instead of closing the app immediately.

#### Scenario: Modal is open
- **WHEN** a confirmation, monster information or result modal is open and the player presses back
- **THEN** the modal is closed as if cancelled or dismissed

#### Scenario: Secondary screen is shown
- **WHEN** settings is shown and the player presses back
- **THEN** the main menu is shown
- **WHEN** level-up is shown and the player presses back
- **THEN** the hub is shown, after the discard confirmation when points are staged

#### Scenario: Hub or main menu is shown
- **WHEN** the hub is shown and the player presses back
- **THEN** the hub exit confirmation ("Exit game?") is shown
- **WHEN** the main menu is shown and the player presses back
- **THEN** a quit confirmation is shown and the app closes only if confirmed

#### Scenario: Gameplay screen is shown
- **WHEN** exploration is shown and the player presses back
- **THEN** an abandon-expedition confirmation is shown
- **WHEN** a monster encounter is shown and the player presses back
- **THEN** nothing happens
