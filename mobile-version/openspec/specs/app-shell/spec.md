# app-shell Specification

## Purpose
Define the app-wide shell: safe-area insets, the reserved ad banner slot, the shared theme with touch and text size minimums, and single-screen navigation.

## Requirements

### Requirement: Views respect the device safe area
The mobile game SHALL keep interactive controls and text inside the device safe area so notches, status bars and gesture bars never cover them.

#### Scenario: Device reports an obscured edge
- **WHEN** the device safe area excludes part of the top or bottom of the screen
- **THEN** every view and overlay is inset by at least that amount on that edge
- **AND** the screen background still fills the whole display

#### Scenario: Window size changes
- **WHEN** the window or safe area changes size
- **THEN** the insets are recalculated without restarting the game

### Requirement: Screens reserve space for an ad banner
The mobile game SHALL reserve a full-width bottom banner slot on non-gameplay screens without overlapping content or sitting directly against interactive controls.

#### Scenario: Non-gameplay screen is shown
- **WHEN** the main menu, character hub, settings, level-up or a result screen is shown and ads are enabled
- **THEN** a banner slot of at least 50 logical pixels is reserved at the bottom of the safe area
- **AND** a non-interactive gap separates the slot from the nearest control
- **AND** no view or overlay content is drawn inside the slot

#### Scenario: Gameplay screen is shown
- **WHEN** dungeon exploration or a monster encounter is shown
- **THEN** the banner slot is hidden and the screen uses the full safe area

#### Scenario: Ads are disabled
- **WHEN** ads are disabled by configuration
- **THEN** the banner slot takes no space on any screen

### Requirement: UI uses a shared theme with touch-friendly sizes
The mobile game SHALL style its UI from one shared theme that enforces minimum touch and text sizes.

#### Scenario: Controls are displayed
- **WHEN** any screen is shown
- **THEN** every enabled button is at least 48 logical pixels tall
- **AND** primary actions are at least 56 logical pixels tall
- **AND** body text is at least 14 logical pixels and stat text at least 12 logical pixels

#### Scenario: Button cannot be used
- **WHEN** a button is disabled or marked coming soon
- **THEN** its background and text are visibly dimmed compared with enabled buttons

### Requirement: Only one screen is active at a time
The mobile game SHALL hide every other screen and modal view when it switches to a screen.

#### Scenario: Player navigates between screens
- **WHEN** any screen is shown
- **THEN** no other screen, settings view, level-up view or monster information view remains visible

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
