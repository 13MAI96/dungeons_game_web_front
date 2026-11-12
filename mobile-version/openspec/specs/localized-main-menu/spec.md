## Purpose

Define the initial mobile main menu experience and its supported English/Spanish localization behavior.

## Requirements

### Requirement: Main menu is the initial app screen
The app SHALL display a functional main menu when launched.

#### Scenario: App launch opens main menu
- **WHEN** the user launches the mobile app
- **THEN** the first visible screen is the main menu

### Requirement: Main menu shows primary options
The main menu SHALL show exactly three primary options: start game, load game, and settings.

#### Scenario: English menu options are visible
- **WHEN** the device language is not Spanish
- **THEN** the menu displays "Start Game", "Load Game", and "Settings"

#### Scenario: Spanish menu options are visible
- **WHEN** the device language is Spanish
- **THEN** the menu displays "Iniciar Partida", "Cargar Partida", and "Ajustes"

#### Scenario: Start game option opens new game view
- **WHEN** the user selects the start-game option
- **THEN** the app displays the new game view

### Requirement: Main menu uses mobile-first layout
The main menu SHALL display its primary options as a centered vertical list in the lower portion of the screen while leaving the upper portion available for a future logo.

#### Scenario: Menu options are positioned below reserved logo space
- **WHEN** the main menu is displayed on a mobile viewport
- **THEN** the primary options appear centered horizontally as a vertical list near the bottom of the screen
- **THEN** the upper portion of the screen remains free of menu options

### Requirement: Main menu uses dark brown-black background
The main menu SHALL use a dark background tone between brown and black.

#### Scenario: Main menu background is visible
- **WHEN** the main menu is displayed
- **THEN** the screen background uses a dark brown-black tone behind the menu options

### Requirement: Unsupported languages fall back to English
The app SHALL use English menu text for every device language other than Spanish.

#### Scenario: Non-Spanish language falls back to English
- **WHEN** the device language is English, Portuguese, French, or any other non-Spanish language
- **THEN** the menu displays "Start Game", "Load Game", and "Settings"
