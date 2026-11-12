## ADDED Requirements

### Requirement: Experience threshold unlocks player level-up
The mobile game SHALL treat the experience threshold as the required amount for level-up eligibility, not as a maximum cap.

#### Scenario: Experience can exceed threshold
- **WHEN** the player gains experience that places current experience above the required level threshold
- **THEN** current experience remains above the threshold
- **THEN** current experience is not clamped to the threshold value

#### Scenario: Reaching threshold grants level-up points
- **WHEN** current experience is greater than or equal to the required threshold for the player's current level
- **THEN** the player becomes eligible to level up
- **THEN** the player gains 3 pending improvement points for allocation
- **THEN** the player level increases by 1 after the level-up is accepted
- **THEN** the next experience threshold is recalculated for the new level

#### Scenario: Level-up clears death life sequel
- **WHEN** the player levels up while a dungeon death life sequel is active
- **THEN** the player recovers the maximum life points lost to the death sequel
- **THEN** the sequel penalty no longer reduces the player's maximum life
- **THEN** current life can be restored to the player's updated maximum life outside a dungeon

### Requirement: Reputation level-up is automatic
The mobile game SHALL automatically progress reputation level when current reputation reaches the required reputation threshold.

#### Scenario: Reputation reaches threshold
- **WHEN** current reputation is greater than or equal to the required reputation threshold
- **THEN** reputation level increases automatically
- **THEN** the next reputation threshold is recalculated for the new reputation level
- **THEN** no additional gameplay effect is applied by reputation level-up for now
