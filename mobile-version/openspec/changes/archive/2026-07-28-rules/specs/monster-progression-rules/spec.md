## ADDED Requirements

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
- **THEN** each monster attack defines damage, mana cost, and an array of effect ids

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
