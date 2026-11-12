## ADDED Requirements

### Requirement: Monster level range follows player level
The mobile game SHALL generate monster levels from the current player level using rule-defined ranges.

#### Scenario: Monster level before player level ten
- **WHEN** a dungeon generates a monster and the player level is less than 10
- **THEN** the monster level is always greater than 0
- **THEN** the monster level is not greater than the player level
- **THEN** the monster level is not more than 5 levels below the player level

#### Scenario: Monster level from player level ten onward
- **WHEN** a dungeon generates a monster and the player level is 10 or greater
- **THEN** the monster level can be up to 5 levels below the player level
- **THEN** the monster level can be up to 5 levels above the player level
- **THEN** the monster level is always greater than 0

### Requirement: Monster stats scale by random level points
The mobile game SHALL scale generated monster stats by assigning random stat points for each monster level above 1.

#### Scenario: Level one monster uses base template stats
- **WHEN** a generated monster level is 1
- **THEN** the monster uses the base stats from its JSON template
- **THEN** no level scaling points are assigned

#### Scenario: Higher level monster receives scaling points
- **WHEN** a generated monster level is greater than 1
- **THEN** the generator assigns 2 random stat points for every level above 1
- **THEN** each random point targets life, mana, armor, speed, or strength
- **THEN** the selected stat increases using the same growth values as player stat allocation

### Requirement: Monster attacks unlock by level
The mobile game SHALL include only monster attacks whose unlock level is available for the generated monster level.

#### Scenario: Monster attack unlock level is available
- **WHEN** a monster is generated from its JSON template
- **AND** an attack has an unlock level less than or equal to the generated monster level
- **THEN** the generated monster includes that attack

#### Scenario: Monster attack unlock level is unavailable
- **WHEN** a monster is generated from its JSON template
- **AND** an attack has an unlock level greater than the generated monster level
- **THEN** the generated monster does not include that attack

#### Scenario: Missing attack unlock level defaults to level one
- **WHEN** a monster attack definition omits unlock level
- **THEN** the generator treats that attack as unlock level 1
