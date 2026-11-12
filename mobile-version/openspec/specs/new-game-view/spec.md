## Purpose

Define the post-start-game mobile view where the player sees a character summary and the first set of in-game action options.
## Requirements
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
- **THEN** the left upper column shows the player full-body character portrait asset
- **THEN** the right upper column displays current player statistics using icon stat bars

### Requirement: Player statistics mirror web player component stat set
The new game view SHALL display current player statistics for life, energy, mana, armor, strength, speed, reputation, and experience using icon-based stat bars inspired by the web `player-component`.

#### Scenario: Player statistics are visible
- **WHEN** the new game view is displayed
- **THEN** the user can see life, energy, mana, armor, strength, speed, reputation, and experience statistics in that order
- **THEN** damage is not displayed as a standalone player statistic
- **THEN** each statistic is identified by an icon instead of a text label
- **THEN** each statistic displays its value inside the bar
- **THEN** each statistic icon and filled bar use the same stat-specific color from the web `player-component`
- **THEN** stat bars remain within the visible screen bounds on mobile viewports

#### Scenario: Current and maximum values are visible where applicable
- **WHEN** a statistic has current and maximum values
- **THEN** the stat bar shows the current amount and maximum amount
- **THEN** the bar visually distinguishes the current filled amount from the remaining amount using a dark remaining segment

### Requirement: New game action menu shows five options
The new game view SHALL show exactly five lower action options: explore dungeon, challenge dungeon, manage equipment, shop, and exit.

#### Scenario: English new game actions are visible
- **WHEN** the device language is not Spanish and the new game view is displayed
- **THEN** the lower action list displays "Explore Dungeon", "Challenge Dungeon", "Manage Equipment", "Shop", and "Exit"

#### Scenario: Spanish new game actions are visible
- **WHEN** the device language is Spanish and the new game view is displayed
- **THEN** the lower action list displays "Explorar Mazmorra", "Desafiar Mazmorra", "Ordenar Equipo", "Tienda", and "Salir"

#### Scenario: Explore dungeon opens exploration view
- **WHEN** the user selects the explore-dungeon action
- **THEN** the app displays the dungeon exploration view

### Requirement: New game actions use lower centered list layout
The new game view SHALL display its five action options as a centered vertical list in the lower portion of the screen.

#### Scenario: Action options are positioned below character summary
- **WHEN** the new game view is displayed on a mobile viewport
- **THEN** the five action options appear centered horizontally as a vertical list below the upper character summary area

### Requirement: Manage equipment opens progression allocation
The new game view SHALL provide access to the progression flow from the manage equipment/progression action.

#### Scenario: Manage equipment opens allocation when points are pending
- **WHEN** the player has reserved progression points
- **AND** the user selects the manage equipment action
- **THEN** the app displays the level-up allocation view

#### Scenario: Manage equipment converts available level-ups
- **WHEN** the player has enough experience for one or more levels
- **AND** the user selects the manage equipment action
- **THEN** the app converts every available level-up into reserved progression points
- **THEN** the app displays the progression allocation view

#### Scenario: Manage equipment remains available without pending points
- **WHEN** the player has no reserved progression points and no convertible level-ups
- **AND** the user selects the manage equipment action
- **THEN** the app does not allocate any stat points
- **THEN** the app may show the existing manage-equipment placeholder or an empty progression view

#### Scenario: Manage equipment label can be updated
- **WHEN** the new game view displays the action list
- **THEN** the manage equipment action label may be updated to a progression-oriented name
- **THEN** the action remains in the same lower action list position

#### Scenario: Class choice appears in progression
- **WHEN** the player is level 10 or greater
- **AND** the player has not selected a class
- **AND** the user opens progression
- **THEN** the progression view shows class choices before class-gated ability unlocks are applied

