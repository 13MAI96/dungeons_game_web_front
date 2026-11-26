## ADDED Requirements

### Requirement: Monster experience reward is data driven
The mobile game SHALL compute the experience a monster grants from its template experience value with a fixed multiplier, so rewards keep pace with the per-level experience thresholds.

#### Scenario: Monster is generated
- **WHEN** a monster is created from a template
- **THEN** its experience reward is the template experience multiplied by 4

## MODIFIED Requirements

### Requirement: Monster level range follows player level
The mobile game SHALL generate monster levels from the current player level using rule-defined ranges that keep encounters close to the player's strength.

#### Scenario: Monster level before player level ten
- **WHEN** a dungeon generates a monster and the player level is less than 10
- **THEN** the monster level is always greater than 0
- **THEN** the monster level is not greater than the player level
- **THEN** the monster level is not more than 2 levels below the player level

#### Scenario: Monster level from player level ten onward
- **WHEN** a dungeon generates a monster and the player level is 10 or greater
- **THEN** the monster level can be up to 3 levels below the player level
- **THEN** the monster level can be up to 1 level above the player level
- **THEN** the monster level is always greater than 0
