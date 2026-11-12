## MODIFIED Requirements

### Requirement: Critical attacks bypass armor and dodge
The mobile combat system SHALL treat an attack roll greater than or equal to the selected attack's critical threshold as a critical hit.

#### Scenario: Attack reaches configured critical threshold
- **WHEN** an attacker uses an attack with critical threshold 19
- **AND** the attacker rolls 19 on the D20
- **THEN** the attack is a critical hit
- **THEN** defender armor does not prevent the hit
- **THEN** defender dodge does not prevent the hit

#### Scenario: Attack below configured critical threshold is not critical
- **WHEN** an attacker uses an attack with critical threshold 19
- **AND** the attacker rolls 18 on the D20
- **THEN** the attack is not a critical hit
- **THEN** normal armor and dodge rules apply

### Requirement: Attack definitions own damage
The mobile combat system SHALL use attack definitions to determine base damage and critical damage instead of a persistent player damage statistic.

#### Scenario: Attack damage is selected from attack definition
- **WHEN** an actor performs an attack
- **THEN** the selected attack definition provides the life damage amount
- **THEN** the actor's persistent stats do not include a standalone damage stat

#### Scenario: Critical damage uses selected attack percent
- **WHEN** an actor lands a critical hit
- **THEN** the selected attack definition provides the critical damage percent
- **THEN** the final damage is the selected attack damage plus the configured critical extra damage

#### Scenario: Decimal critical damage is rounded down
- **WHEN** critical damage calculation produces a decimal value
- **THEN** the final damage is rounded down to the lower integer
