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
- **THEN** the dungeon entrance remains green even when it was visited

#### Scenario: Special locations show map icons
- **WHEN** a visible dungeon location has type `MONSTER`, `QUEST`, or `SANCTUARY`
- **THEN** the map cell shows the corresponding monster, quest, or sanctuary icon from the web-front reference

#### Scenario: Large map is windowed around player
- **WHEN** the generated map is larger than 5 columns or 7 rows
- **THEN** the exploration view displays no more than 5 columns and 7 rows
- **THEN** the displayed window follows the player movement
- **THEN** the displayed window keeps the player centered when surrounding map space exists
- **THEN** the displayed window keeps the player at the nearest edge when the player is near a map boundary

#### Scenario: Entrance location is always green
- **WHEN** the dungeon entrance location is visible on the map
- **THEN** the entrance cell is displayed in green
- **THEN** the entrance cell remains green when it is visited
- **THEN** the entrance cell remains green when it is the player's current location

### Requirement: Exploration actions include rest and retreat
The dungeon exploration view SHALL show Rest and Retreat actions below the movement controls.

#### Scenario: Rest and retreat are visible
- **WHEN** the dungeon exploration view is displayed and the player is not in an active monster encounter
- **THEN** the lower action area shows "Rest" and "Retreat" actions

#### Scenario: Retreat is enabled only at entrance
- **WHEN** the player is not at the dungeon entrance
- **THEN** the retreat action is disabled or unavailable

#### Scenario: Retreat costs energy at entrance
- **WHEN** the player is at the dungeon entrance and selects retreat
- **THEN** the system subtracts 1 from current energy
- **THEN** the app exits the dungeon alive even if that spent point was the player's last current energy point

### Requirement: Dungeon completion exits automatically
The dungeon exploration view SHALL complete the dungeon when every monster in the dungeon has been defeated.

#### Scenario: All monsters defeated completes dungeon
- **WHEN** the player defeats the final living monster in the dungeon
- **THEN** the dungeon is marked complete
- **THEN** the app exits the dungeon automatically
- **THEN** the player keeps current dungeon experience
- **THEN** the player gains reputation equal to the number of monsters defeated in that dungeon
- **THEN** the player gains completion experience equal to the reputation gained for that dungeon
- **THEN** the app reports the total experience and reputation gained

#### Scenario: Incomplete dungeon grants no completion reputation
- **WHEN** the player exits a dungeon before all monsters are defeated
- **THEN** the player gains no dungeon completion reputation
- **THEN** the player gains no completion experience from reputation

## ADDED Requirements

### Requirement: Dungeon depletion exits are explained before menu return
The dungeon exploration view SHALL notify the player before returning to the new game view when the dungeon run ends because life or energy was depleted.

#### Scenario: Energy depletion notification appears
- **WHEN** the player's current energy reaches zero or less during a dungeon run for any reason other than a successful retreat from the entrance
- **THEN** the app shows an energy depleted notification before returning to the new game view
- **THEN** the player loses current experience gained during the dungeon run

#### Scenario: Life depletion notification appears
- **WHEN** the player's current life reaches zero or less during a dungeon run
- **THEN** the app shows a life depleted notification before returning to the new game view
- **THEN** the player loses current experience gained during the dungeon run
- **THEN** the player receives the dungeon death sequel

#### Scenario: Successful last-energy retreat does not show defeat notification
- **WHEN** the player retreats from the dungeon entrance
- **AND** retreat spends the player's last current energy point
- **THEN** the app exits the dungeon alive
- **THEN** the app does not show an energy depleted defeat notification
