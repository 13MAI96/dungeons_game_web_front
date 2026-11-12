# player-abilities Specification

## Purpose
TBD - created by archiving change leveling-player. Update Purpose after archive.
## Requirements
### Requirement: Player abilities are data driven
The mobile game SHALL load player ability definitions from a local JSON file.

#### Scenario: Ability JSON defines required fields
- **WHEN** player abilities are loaded
- **THEN** each ability defines id, name, unlock level, type, active flag, energy cost, mana cost, class requirements, simple-skill group, and effect ids

#### Scenario: Active ability defines costs
- **WHEN** an ability is active
- **THEN** it defines energy cost
- **THEN** it defines mana cost
- **THEN** either cost can be 0

#### Scenario: Passive ability remains active
- **WHEN** an unlocked ability is passive
- **THEN** the ability is considered active at all times while its conditions remain satisfied

### Requirement: Ability unlock conditions are enforced
The mobile game SHALL expose player abilities only when their unlock conditions are satisfied.

#### Scenario: Level unlock is satisfied
- **WHEN** the player level is greater than or equal to an ability unlock level
- **THEN** the ability is eligible for unlock

#### Scenario: Class requirement is not satisfied
- **WHEN** an ability requires a class
- **AND** the player has not selected that class
- **THEN** the ability is not available

#### Scenario: Simple skills are exclusive per unlock level
- **WHEN** multiple simple abilities unlock at the same level
- **THEN** the player can keep no more than one of those simple abilities

#### Scenario: Class requirement is satisfied
- **WHEN** an ability requires a class
- **AND** the player has selected that class
- **AND** the player meets the ability unlock level
- **THEN** the ability is available

