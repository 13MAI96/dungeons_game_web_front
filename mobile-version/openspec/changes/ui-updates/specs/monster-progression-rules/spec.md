## MODIFIED Requirements

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
