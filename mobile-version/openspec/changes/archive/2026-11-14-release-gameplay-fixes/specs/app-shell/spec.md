## ADDED Requirements

### Requirement: Android back navigates within the game
The mobile game SHALL handle the system back action as in-game navigation instead of closing the app immediately.

#### Scenario: Modal is open
- **WHEN** a confirmation, monster information or result modal is open and the player presses back
- **THEN** the modal is closed as if cancelled or dismissed

#### Scenario: Secondary screen is shown
- **WHEN** settings or level-up is shown and the player presses back
- **THEN** the previous screen (main menu or hub) is shown

#### Scenario: Hub or main menu is shown
- **WHEN** the hub is shown and the player presses back
- **THEN** the leave-to-menu confirmation is shown
- **WHEN** the main menu is shown and the player presses back
- **THEN** a quit confirmation is shown and the app closes only if confirmed

#### Scenario: Gameplay screen is shown
- **WHEN** exploration is shown and the player presses back
- **THEN** an abandon-expedition confirmation is shown
- **WHEN** a monster encounter is shown and the player presses back
- **THEN** nothing happens

### Requirement: Progress is saved when the app is backgrounded
The mobile game SHALL persist the player, including any active run, when the app is paused or closed.

#### Scenario: App goes to background
- **WHEN** the operating system pauses or closes the app
- **THEN** the current player state and active run are saved
