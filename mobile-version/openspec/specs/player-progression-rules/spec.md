# player-progression-rules Specification

## Purpose
Define base player stats, experience and reputation thresholds, and how experience accumulates across dungeon runs.

## Requirements

### Requirement: Player starts with rule-defined base stats
The mobile game SHALL create a new player with the rule-defined base stats needed for exploration, combat, and progression.

#### Scenario: New player base stats are created
- **WHEN** a new player state is created
- **THEN** maximum life is 10
- **THEN** current life is 10
- **THEN** maximum energy is 25
- **THEN** current energy is 25
- **THEN** strength is 3
- **THEN** speed is 3
- **THEN** level is 1
- **THEN** current experience is 0
- **THEN** current reputation is 0

#### Scenario: Player damage stat is removed
- **WHEN** player statistics are displayed
- **THEN** damage is not displayed as a persistent player statistic
- **THEN** attack-specific damage is resolved from the selected attack definition

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

### Requirement: Reputation thresholds scale by shop level
The mobile game SHALL calculate reputation thresholds for shop progression using the game reputation formula.

#### Scenario: Reputation threshold through level ten
- **WHEN** the shop progression level is 1 through 10
- **THEN** required reputation increases by 10 per level
- **THEN** level 1 requires 10 reputation
- **THEN** level 10 requires 100 reputation

#### Scenario: Reputation threshold after level ten
- **WHEN** the shop progression level is greater than 10
- **THEN** the required reputation increases from the previous threshold by `25 percent + level / 10`

### Requirement: Dungeon exit restores player status
The mobile game SHALL restore player life, energy, and mana when the player exits a dungeon, except that death keeps the life sequel penalty until level-up.

#### Scenario: Player exits dungeon without dying
- **WHEN** the player leaves a dungeon while current life is greater than 0 or current energy reaches zero
- **THEN** current life is restored to maximum life
- **THEN** current energy is restored to maximum energy
- **THEN** current mana is restored to maximum mana

### Requirement: Dungeon death applies life sequel
The mobile game SHALL apply a permanent life sequel when the player dies in a dungeon.

#### Scenario: Player dies with remaining maximum life
- **WHEN** the player dies in a dungeon
- **AND** maximum life can remain greater than 0 after the penalty
- **THEN** maximum life is reduced by 10 percent
- **THEN** current life is restored to the reduced maximum life for the next valid run
- **THEN** current energy is restored to maximum energy
- **THEN** current mana is restored to maximum mana
- **THEN** current dungeon experience is lost

#### Scenario: Player dies with no remaining maximum life
- **WHEN** the player dies in a dungeon
- **AND** maximum life would be reduced to 0
- **THEN** the current save is marked deleted or invalid

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

### Requirement: Reputation level-up is automatic
The mobile game SHALL automatically progress reputation level when current reputation reaches the required reputation threshold.

#### Scenario: Reputation reaches threshold
- **WHEN** current reputation is greater than or equal to the required reputation threshold
- **THEN** reputation level increases automatically
- **THEN** the next reputation threshold is recalculated for the new reputation level
- **THEN** no additional gameplay effect is applied by reputation level-up for now

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

### Requirement: Experience accumulates across dungeon runs
The mobile game SHALL maintain permanent experience as a cumulative total across completed or voluntarily exited dungeon runs.

#### Scenario: Consecutive dungeons grant experience
- **WHEN** the player completes or retreats from a dungeon with provisional experience
- **THEN** that experience is added to the permanent total
- **AND** experience committed by earlier dungeon runs remains in the total

#### Scenario: A failed dungeon follows successful runs
- **WHEN** the player loses life or energy after accumulating permanent experience in earlier runs
- **THEN** only experience gained during the failed active run is discarded
- **AND** the earlier permanent experience remains unchanged
