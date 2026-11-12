## MODIFIED Requirements

### Requirement: Exploration view shows map in upper area
The dungeon exploration view SHALL display the generated map as a square or rectangular grid in the upper portion of the screen.

#### Scenario: Map is visible during exploration
- **WHEN** the dungeon exploration view is displayed
- **THEN** the upper portion of the screen shows the generated map grid
- **THEN** the player's current location is visually distinguishable
- **THEN** the map cells scale to use the available upper screen area when the generated map is small enough

#### Scenario: Visited map locations are grey
- **WHEN** a location was visited during exploration or a monster location was cleared by defeating its monster
- **THEN** the map displays that location in grey when it is visible and not the current location

#### Scenario: Special locations show map icons
- **WHEN** a visible dungeon location has type `MONSTER`, `QUEST`, or `SANCTUARY`
- **THEN** the map cell shows the corresponding monster, quest, or sanctuary icon from the web-front reference

#### Scenario: Large map is windowed around player
- **WHEN** the generated map is larger than 5 columns or 7 rows
- **THEN** the exploration view displays no more than 5 columns and 7 rows
- **THEN** the displayed window follows the player movement
- **THEN** the displayed window keeps the player centered when surrounding map space exists
- **THEN** the displayed window keeps the player at the nearest edge when the player is near a map boundary

### Requirement: Exploration resolves special location effects
The dungeon exploration view SHALL apply web-derived location effects when the player enters or uses actions in special dungeon locations.

#### Scenario: Entering sanctuary restores player status
- **WHEN** the player moves into a `SANCTUARY` location
- **THEN** the system restores 50 percent of maximum energy
- **THEN** the system restores 50 percent of maximum life
- **THEN** the sanctuary location is marked visited

#### Scenario: Quest location exposes collect action
- **WHEN** the player moves into an unresolved `QUEST` location
- **THEN** the lower action area shows a collect-treasure action
- **THEN** the quest is not resolved until the user selects the collect-treasure action

#### Scenario: Resolving quest location consumes energy and marks visited
- **WHEN** the player resolves a `QUEST` location
- **THEN** the system subtracts 1 from the player's current energy
- **THEN** the system applies the quest success or failure outcome
- **THEN** the quest location is marked visited

#### Scenario: Rest action uses recovery rule
- **WHEN** the player selects Rest during dungeon exploration
- **THEN** the system applies the web rest recovery rule to current mana, current energy, and current life

#### Scenario: Location effect depletes player
- **WHEN** a dungeon location effect reduces player current life or current energy to zero or less
- **THEN** the app exits the dungeon run
- **THEN** the player loses current experience gained during the dungeon run

## ADDED Requirements

### Requirement: Exploration shows player survival stats
The dungeon exploration view SHALL show the player's life, energy, and mana while exploring.

#### Scenario: Survival stats are visible during exploration
- **WHEN** the dungeon exploration view is displayed
- **THEN** the user can see icon stat bars for current life, current energy, and current mana
- **THEN** each bar shows the current and maximum value
