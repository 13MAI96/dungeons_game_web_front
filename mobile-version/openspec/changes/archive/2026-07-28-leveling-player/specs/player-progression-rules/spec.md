## MODIFIED Requirements

### Requirement: Experience thresholds scale by level
The mobile game SHALL calculate required experience for each player level using the updated game progression formula.

#### Scenario: Experience threshold through level ten
- **WHEN** the player is level 1 through level 10
- **THEN** required experience increases by 100 per level
- **THEN** level 1 requires 100 experience
- **THEN** level 10 requires 1000 experience

#### Scenario: Experience threshold after level ten
- **WHEN** the player level is greater than 10
- **THEN** the required experience increases from the previous threshold by `10 percent + level / 10`

### Requirement: Experience threshold unlocks player level-up
The mobile game SHALL treat the experience threshold as the required amount for progression conversion, not as a maximum cap.

#### Scenario: Experience can exceed threshold
- **WHEN** the player gains experience that places current experience above the required level threshold
- **THEN** current experience remains above the threshold
- **THEN** current experience is not clamped to the threshold value

#### Scenario: Reaching threshold grants level-up points
- **WHEN** current experience is greater than or equal to the required threshold for one or more player levels
- **THEN** the player has convertible level-ups
- **THEN** those level-ups are converted when the player enters the progression view
- **THEN** the player level increases for every converted level-up
- **THEN** the next experience threshold is recalculated for the new level

#### Scenario: Level-up clears death life sequel
- **WHEN** the player levels up while a dungeon death life sequel is active
- **THEN** the player recovers the maximum life points lost to the death sequel
- **THEN** the sequel penalty no longer reduces the player's maximum life
- **THEN** current life can be restored to the player's updated maximum life outside a dungeon

## ADDED Requirements

### Requirement: New players start with progression points
The mobile game SHALL grant 5 reserved progression points to a newly created player.

#### Scenario: Initial progression points are available
- **WHEN** a new player starts the game
- **THEN** the player has 5 reserved progression points
- **THEN** the progression view can allocate those points before any experience is gained

### Requirement: Progression points can be reserved
The mobile game SHALL allow converted progression points to remain unassigned for later progression sessions.

#### Scenario: Progression converts all available levels
- **WHEN** the player enters the progression view with enough experience for one or more levels
- **THEN** every available level-up is converted into assignable points
- **THEN** converted points are added to the player's reserved progression points

#### Scenario: Player leaves points unassigned
- **WHEN** the player exits the progression view without assigning all reserved progression points
- **THEN** unassigned points remain reserved on the player
- **THEN** those points are available the next time the player enters progression
