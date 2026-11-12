## ADDED Requirements

### Requirement: New game view opens from start game
The app SHALL display the new game view after the user selects the start-game option from the main menu.

#### Scenario: Start game opens new game view
- **WHEN** the user selects "Start Game" or "Iniciar Partida" from the main menu
- **THEN** the app displays the new game view

### Requirement: New game view preserves dark background
The new game view SHALL use the same dark background treatment as the main menu.

#### Scenario: New game view background matches current style
- **WHEN** the new game view is displayed
- **THEN** the screen background remains dark and does not introduce a new background image or color theme

### Requirement: Character summary uses two upper columns
The new game view SHALL divide the upper portion of the screen into two columns for character presentation and statistics.

#### Scenario: Upper layout reserves character image and stats areas
- **WHEN** the new game view is displayed
- **THEN** the left upper column is reserved for a future character image
- **THEN** the right upper column displays current player statistics

### Requirement: Player statistics mirror web player component stat set
The new game view SHALL display current player statistics for energy, life, mana, armor, damage, reputation, and experience.

#### Scenario: Player statistics are visible
- **WHEN** the new game view is displayed
- **THEN** the user can see energy, life, mana, armor, damage, reputation, and experience statistics

### Requirement: New game action menu shows five options
The new game view SHALL show exactly five lower action options: explore dungeon, challenge dungeon, manage equipment, shop, and exit.

#### Scenario: English new game actions are visible
- **WHEN** the device language is not Spanish and the new game view is displayed
- **THEN** the lower action list displays "Explore Dungeon", "Challenge Dungeon", "Manage Equipment", "Shop", and "Exit"

#### Scenario: Spanish new game actions are visible
- **WHEN** the device language is Spanish and the new game view is displayed
- **THEN** the lower action list displays "Explorar Mazmorra", "Desafiar Mazmorra", "Ordenar Equipo", "Tienda", and "Salir"

### Requirement: New game actions use lower centered list layout
The new game view SHALL display its five action options as a centered vertical list in the lower portion of the screen.

#### Scenario: Action options are positioned below character summary
- **WHEN** the new game view is displayed on a mobile viewport
- **THEN** the five action options appear centered horizontally as a vertical list below the upper character summary area
