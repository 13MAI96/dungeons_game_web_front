## MODIFIED Requirements

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
