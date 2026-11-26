## MODIFIED Requirements

### Requirement: Experience thresholds scale by level
The mobile game SHALL calculate required experience for each player level using the game progression formula, growing by a bounded percentage after level ten.

#### Scenario: Experience threshold through level ten
- **WHEN** the player is level 1 through level 10
- **THEN** required experience increases by 100 per level
- **THEN** level 1 requires 100 experience
- **THEN** level 10 requires 1000 experience

#### Scenario: Experience threshold after level ten
- **WHEN** the player level is greater than 10
- **THEN** the required experience increases from the previous threshold by `(10 + level / 10)` percent
- **THEN** level 11 requires 1111 experience

### Requirement: Reputation thresholds scale by shop level
The mobile game SHALL calculate reputation thresholds for shop progression using the game reputation formula, growing by a bounded percentage after level ten.

#### Scenario: Reputation threshold through level ten
- **WHEN** the shop progression level is 1 through 10
- **THEN** required reputation increases by 10 per level
- **THEN** level 1 requires 10 reputation
- **THEN** level 10 requires 100 reputation

#### Scenario: Reputation threshold after level ten
- **WHEN** the shop progression level is greater than 10
- **THEN** the required reputation increases from the previous threshold by `(25 + level / 10)` percent
- **THEN** level 11 requires 126 reputation
