## MODIFIED Requirements

### Requirement: Player abilities are data driven
The mobile game SHALL load player ability definitions from a local JSON file.

#### Scenario: Ability JSON defines required fields
- **WHEN** player abilities are loaded
- **THEN** each ability defines id, name, unlock level, type, active flag, damage, critical threshold, critical damage percent, energy cost, mana cost, class requirements, simple-skill group, and effect ids

#### Scenario: Active ability defines costs
- **WHEN** an ability is active
- **THEN** it defines energy cost
- **THEN** it defines mana cost
- **THEN** either cost can be 0

#### Scenario: Passive ability remains active
- **WHEN** an unlocked ability is passive
- **THEN** the ability is considered active at all times while its conditions remain satisfied

#### Scenario: Non-damage active ability defines critical fields
- **WHEN** an active self-effect ability such as rest is loaded
- **THEN** it still defines critical threshold and critical damage percent
