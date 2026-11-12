# dungeon-exploration Specification

## Purpose
Describe generation of the dungeon map and how the player explores it, moves, rests, retreats, and exits.

## Requirements

### Requirement: Explore dungeon opens exploration view
The app SHALL display the dungeon exploration view after the user selects the explore-dungeon action from the new game view.

#### Scenario: Explore dungeon starts exploration
- **WHEN** the user selects "Explore Dungeon" or "Explorar Mazmorra"
- **THEN** the app displays the dungeon exploration view

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
- **THEN** the app exits the dungeon alive even if that spent point was the player's last current energy point

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
- **THEN** the player gains completion experience equal to the reputation gained for that dungeon
- **THEN** the app reports the total experience and reputation gained

#### Scenario: Incomplete dungeon grants no completion reputation
- **WHEN** the player exits a dungeon before all monsters are defeated
- **THEN** the player gains no dungeon completion reputation
- **THEN** the player gains no completion experience from reputation

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

### Requirement: Dungeon map follows level-scaled sparse generation rules
The dungeon exploration view SHALL generate a traversable map with bounded objectives and empty traversal locations based on player level.

#### Scenario: Early dungeon is generated
- **WHEN** a level 1 player starts exploration
- **THEN** the dungeon contains between 5 and 7 monsters
- **AND** includes empty traversable cells
- **AND** includes one quest and one sanctuary
- **AND** every required objective is reachable from the entrance

#### Scenario: Early player makes partial progress
- **WHEN** the player cannot afford to complete every encounter
- **THEN** the player can return to the entrance and retreat with experience already earned from defeated monsters
- **AND** receives no completion reputation

#### Scenario: Dungeon scale increases
- **WHEN** the player reaches level 10
- **THEN** each map dimension is selected randomly from 5 through 25
- **AND** between 25 and 35 percent of all cells contain monsters
- **AND** monster density is never lower than 25 percent
- **AND** map dimensions do not exceed 25 columns by 25 rows

### Requirement: Dungeon experience has an active-run lifecycle
The dungeon exploration view SHALL distinguish provisional experience earned during the active run from permanent accumulated experience.

#### Scenario: Dungeon starts
- **WHEN** the player begins dungeon exploration
- **THEN** provisional dungeon experience starts at zero
- **AND** permanent accumulated experience remains unchanged

#### Scenario: Experience is displayed during exploration
- **WHEN** the player is exploring a dungeon
- **THEN** permanent accumulated experience and provisional dungeon experience are shown in separate labeled bars
- **AND** gaining dungeon experience changes only the provisional bar

#### Scenario: Dungeon completes or player retreats
- **WHEN** the player completes the dungeon or retreats through the entrance
- **THEN** provisional dungeon experience is added to permanent accumulated experience
- **AND** provisional dungeon experience is reset to zero

#### Scenario: Dungeon ends through depletion
- **WHEN** life or energy reaches zero
- **THEN** provisional dungeon experience is reset to zero
- **AND** permanent accumulated experience remains unchanged

### Requirement: Player position is marked on the map
The dungeon exploration view SHALL mark the player's current cell with a marker that is visible on every tile type, including the entrance.

#### Scenario: Player stands on the entrance
- **WHEN** the player is on the entrance cell
- **THEN** the entrance stays green
- **AND** the player marker is drawn on that cell

#### Scenario: Player moves
- **WHEN** the player moves to another cell
- **THEN** exactly one cell shows the player marker

### Requirement: Map fits its area without clipping
The dungeon exploration view SHALL size map cells from the space available after the stats and action controls, so every visible map row is fully shown.

#### Scenario: Feedback or treasure action appears
- **WHEN** exploration feedback text or the Collect Treasure action becomes visible
- **THEN** no map row is clipped
- **AND** the map cell size does not change

### Requirement: Map tiles are readable
The dungeon exploration view SHALL draw unseen, blocked, sanctuary and entrance cells in distinguishable colours and draw location icons with sufficient contrast against their tiles.

#### Scenario: Different tile types are visible
- **WHEN** unseen, blocked, sanctuary and entrance cells are on screen
- **THEN** each type uses a different colour
- **AND** monster, quest and sanctuary icons are light-coloured on darker tiles

### Requirement: Direction buttons use arrow icons
The dungeon exploration view SHALL show arrow icons on the direction buttons, each at least 64 logical pixels in its smaller dimension.

#### Scenario: Direction pad is shown
- **WHEN** the exploration view is visible
- **THEN** each direction button shows an arrow icon instead of a text character
