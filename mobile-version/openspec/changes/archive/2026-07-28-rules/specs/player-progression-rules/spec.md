## ADDED Requirements

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
The mobile game SHALL calculate required experience for each player level using the game progression formula.

#### Scenario: Experience threshold through level ten
- **WHEN** the player is level 1 through level 10
- **THEN** required experience increases by 10 per level
- **THEN** level 1 requires 10 experience
- **THEN** level 10 requires 100 experience

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
