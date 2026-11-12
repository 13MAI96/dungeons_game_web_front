# monster-progression-rules Specification

## Purpose
Define how monsters are selected and scaled by level, including their combat stats and attacks.

## Requirements

### Requirement: Monsters include level and combat stats
The mobile game SHALL represent monsters with level, life, mana, armor, speed, strength, and attacks.

#### Scenario: Monster templates are data driven
- **WHEN** monster templates are loaded
- **THEN** the game reads monster base characteristics from a local JSON file
- **THEN** adjusting monster characteristics does not require editing the dungeon generator script

#### Scenario: Monster effects are data driven
- **WHEN** monster effect definitions are loaded
- **THEN** the game reads effect details from a local JSON file
- **THEN** each effect defines its id, precision, cause, duration, target stat, operation, and amount

#### Scenario: Monster template is expanded for combat
- **WHEN** a monster is generated for a dungeon location
- **THEN** the monster has a level
- **THEN** the monster has maximum and current life
- **THEN** the monster has maximum and current mana
- **THEN** the monster has armor
- **THEN** the monster has speed
- **THEN** the monster has strength
- **THEN** the monster has between 2 and 5 attack definitions
- **THEN** each monster attack defines damage, critical threshold, critical damage percent, mana cost, and an array of effect ids

### Requirement: Monster names show level
The monster encounter view SHALL display each monster's level beside its name.

#### Scenario: Monster level is visible
- **WHEN** the player is in an active monster encounter
- **THEN** the monster name is displayed with `Lv. N`
- **THEN** `N` is the monster's current level

### Requirement: Monster stats use bars
The monster encounter view SHALL show monster combat stats as icon stat bars.

#### Scenario: Monster combat bars are visible
- **WHEN** the player is in an active monster encounter
- **THEN** monster life, mana, armor, speed, and strength are displayed as bars
- **THEN** life and mana bars show current and maximum values
- **THEN** armor, speed, and strength bars show their current values

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
