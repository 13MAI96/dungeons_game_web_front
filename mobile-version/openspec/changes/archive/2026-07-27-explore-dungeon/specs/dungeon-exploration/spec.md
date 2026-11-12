## ADDED Requirements

### Requirement: Explore dungeon opens exploration view
The app SHALL display the dungeon exploration view after the user selects the explore-dungeon action from the new game view.

#### Scenario: Explore dungeon starts exploration
- **WHEN** the user selects "Explore Dungeon" or "Explorar Mazmorra"
- **THEN** the app displays the dungeon exploration view

### Requirement: Dungeon map follows backend generation rules
The dungeon exploration view SHALL generate a dungeon map using the same rules as `dungeons_back`.

#### Scenario: Dungeon map is generated
- **WHEN** dungeon exploration starts
- **THEN** the system generates random `number_of_columns` and `number_of_rows` between `5^dungeon_type` and `8^dungeon_type`
- **THEN** the system creates one location for each row and column coordinate
- **THEN** the system selects one entrance location from edge locations
- **THEN** the system assigns non-entrance location content from monster, quest, block, and sanctuary options according to the backend progression rules
- **THEN** `q_locations` equals the number of generated locations

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

### Requirement: Directional movement actions are shown
The dungeon exploration view SHALL always show four directional arrow movement buttons.

#### Scenario: Movement buttons reflect reachable directions
- **WHEN** the player is in a dungeon location
- **THEN** the lower action area shows up, down, left, and right arrow controls
- **THEN** directions blocked by map bounds or block locations are disabled

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

### Requirement: Monster location enters encounter
The dungeon exploration view SHALL transition to a monster encounter when the player moves into a location containing a living monster.

#### Scenario: Moving into living monster starts encounter
- **WHEN** the player moves into a location whose type is `MONSTER` and whose monster is alive
- **THEN** the app displays the monster encounter view
