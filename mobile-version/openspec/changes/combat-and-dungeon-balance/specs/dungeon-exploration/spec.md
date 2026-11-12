## MODIFIED Requirements

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
