## MODIFIED Requirements

### Requirement: Dungeon map follows level-scaled sparse generation rules
The dungeon exploration view SHALL generate a traversable map with bounded objectives and empty traversal locations based on player level, keeping the monster count completable at every level.

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
- **WHEN** the player is level 10 or higher
- **THEN** each map dimension is selected randomly from 5 through the player level, never above 25
- **AND** the dungeon contains between `5 + floor((level - 1) / 3)` and two more monsters, limited by the free cells
- **AND** map dimensions do not exceed 25 columns by 25 rows
