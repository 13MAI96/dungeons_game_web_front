## MODIFIED Requirements

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
