# dungeon-exploration Specification

## Purpose
TBD - created by archiving change explore-dungeon. Update Purpose after archive.
## Requirements
### Requirement: Explore dungeon opens exploration view
The app SHALL display the dungeon exploration view after the user selects the explore-dungeon action from the new game view.

#### Scenario: Explore dungeon starts exploration
- **WHEN** the user selects "Explore Dungeon" or "Explorar Mazmorra"
- **THEN** the app displays the dungeon exploration view

### Requirement: Dungeon map follows backend generation rules
The dungeon exploration view SHALL generate a dungeon map using backend-derived rules constrained by the player's current level and shall pass that level into monster generation.

#### Scenario: Dungeon map is generated
- **WHEN** dungeon exploration starts and the player level is less than 10
- **THEN** the system generates no more than 5 columns and 7 rows
- **THEN** the system creates one location for each row and column coordinate
- **THEN** the system selects one entrance location from edge locations
- **THEN** the entrance location is always shown in green
- **THEN** the system assigns non-entrance location content from monster, quest, block, and sanctuary options according to the backend progression rules
- **THEN** generated monster levels follow the current player level rules
- **THEN** `q_locations` equals the number of generated locations

#### Scenario: Dungeon map can expand at level ten
- **WHEN** dungeon exploration starts and the player level is 10 or greater
- **THEN** the system can generate up to 25 columns and 25 rows
- **THEN** the system creates one location for each row and column coordinate
- **THEN** the system selects one entrance location from edge locations
- **THEN** generated monster levels follow the current player level rules

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

### Requirement: Directional movement actions are shown
The dungeon exploration view SHALL always show four directional arrow movement buttons.

#### Scenario: Movement buttons reflect reachable directions
- **WHEN** the player is in a dungeon location
- **THEN** the lower action area shows up, down, left, and right arrow controls
- **THEN** directions blocked by map bounds or block locations are disabled

#### Scenario: Movement consumes energy
- **WHEN** the player moves from one dungeon location to another
- **THEN** the system subtracts 1 from the player's current energy

#### Scenario: Direction buttons form rectangular control
- **WHEN** the dungeon exploration view is displayed
- **THEN** the up and down buttons are wide
- **THEN** the left and right buttons are tall
- **THEN** all four direction buttons form a balanced rectangular control

### Requirement: Player can backtrack
The dungeon exploration view SHALL allow the player to return to the immediately previous location when that location is adjacent and not blocked.

#### Scenario: Previous location is selectable
- **WHEN** the player moves from one location to another
- **THEN** the immediately previous location remains available as a valid movement option

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
- **THEN** the app exits the dungeon alive if the player still has current life and energy

### Requirement: Monster location enters encounter
The dungeon exploration view SHALL transition to a monster encounter when the player moves into a location containing a living monster.

#### Scenario: Moving into living monster starts encounter
- **WHEN** the player moves into a location whose type is `MONSTER` and whose monster is alive
- **THEN** the app displays the monster encounter view

### Requirement: Exploration resolves special location effects
The dungeon exploration view SHALL apply rule-derived location effects when the player enters or uses actions in special dungeon locations.

#### Scenario: Entering sanctuary restores player status
- **WHEN** the player moves into a `SANCTUARY` location
- **THEN** the system restores between 50 and 100 percent of maximum life
- **THEN** the system restores between 50 and 100 percent of maximum energy
- **THEN** the system restores between 50 and 100 percent of maximum mana
- **THEN** the sanctuary location remains unvisited so the effect can trigger on future visits

#### Scenario: Quest location exposes collect action
- **WHEN** the player moves into an unresolved `QUEST` location
- **THEN** the lower action area shows a collect-treasure action
- **THEN** the quest is not resolved until the user selects the collect-treasure action

#### Scenario: Resolving quest location consumes energy and marks visited
- **WHEN** the player resolves a `QUEST` location
- **THEN** the system subtracts 1 from the player's current energy
- **THEN** the system grants experience when the D20 roll is between 10 and 20 inclusive
- **THEN** the system applies trap damage when the D20 roll is below 10
- **THEN** the quest location is marked visited

#### Scenario: Rest action uses recovery rule
- **WHEN** the player selects Rest during dungeon exploration
- **AND** the player has at least 5 current mana
- **THEN** the system restores between 5 and 25 percent of maximum energy
- **THEN** the system restores between 10 and 40 percent of maximum life
- **THEN** the system does not restore mana
- **THEN** the system subtracts 5 current mana

#### Scenario: Rest remains available between dungeon runs
- **WHEN** a previous dungeon disabled actions while exiting
- **AND** the player begins or continues a new active dungeon on an empty location
- **THEN** Rest is enabled
- **AND** full current mana does not prevent using Rest

#### Scenario: Rest action requires mana
- **WHEN** the player selects Rest during dungeon exploration
- **AND** the player has less than 5 current mana
- **THEN** life, energy, and mana remain unchanged

#### Scenario: Location effect depletes player
- **WHEN** a dungeon location effect reduces player current life or current energy to zero or less
- **THEN** the app exits the dungeon run
- **THEN** the player loses current experience gained during the dungeon run

### Requirement: Exploration shows player survival stats
The dungeon exploration view SHALL show the player's life, energy, mana, and experience while exploring.

#### Scenario: Survival stats are visible during exploration
- **WHEN** the dungeon exploration view is displayed
- **THEN** the user can see icon stat bars for current life, current energy, current mana, and current experience
- **THEN** each bar shows the current and maximum value

### Requirement: Dungeon completion exits automatically
The dungeon exploration view SHALL complete the dungeon when every monster in the dungeon has been defeated.

#### Scenario: All monsters defeated completes dungeon
- **WHEN** the player defeats the final living monster in the dungeon
- **THEN** the dungeon is marked complete
- **THEN** the app exits the dungeon automatically
- **THEN** the player keeps current dungeon experience
- **THEN** the player gains reputation equal to the number of monsters defeated in that dungeon
- **THEN** the app reports the experience and reputation gained

#### Scenario: Incomplete dungeon grants no completion reputation
- **WHEN** the player exits a dungeon before all monsters are defeated
- **THEN** the player gains no dungeon completion reputation
