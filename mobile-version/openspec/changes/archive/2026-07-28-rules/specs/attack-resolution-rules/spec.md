## ADDED Requirements

### Requirement: Attacks resolve with D20 armor strength formula
The mobile combat system SHALL resolve attacks with a D20 roll, defender armor, attacker strength, and selected attack damage.

#### Scenario: Attack misses when resolved value is not positive
- **WHEN** an attacker rolls a D20 for an attack
- **AND** `roll - defender armor - attacker strength` is less than or equal to 0
- **THEN** the attack misses
- **THEN** the defender loses no life from that attack

#### Scenario: Attack can hit when resolved value is positive
- **WHEN** an attacker rolls a D20 for an attack
- **AND** `roll - defender armor - attacker strength` is greater than 0
- **AND** the defender does not dodge the attack
- **THEN** the attack hits
- **THEN** the defender loses life according to the selected attack definition

### Requirement: Critical attacks bypass armor and dodge
The mobile combat system SHALL treat a natural D20 roll of 20 as a critical hit.

#### Scenario: Natural twenty is critical
- **WHEN** an attacker rolls exactly 20 on the D20
- **THEN** the attack is a critical hit
- **THEN** defender armor does not prevent the hit
- **THEN** defender dodge does not prevent the hit

### Requirement: Defenders can dodge non-critical attacks
The mobile combat system SHALL allow a defender to dodge a non-critical attack using the defender speed formula.

#### Scenario: Defender dodges attack
- **WHEN** an attack has a positive resolved value
- **AND** the attack is not a critical hit
- **AND** the defender rolls a D20 for dodge
- **AND** `dodge roll * defender speed / 100` is greater than the attack resolved value
- **THEN** the attack is dodged
- **THEN** the defender loses no life from that attack

#### Scenario: Defender fails to dodge attack
- **WHEN** an attack has a positive resolved value
- **AND** the attack is not a critical hit
- **AND** the dodge formula result is less than or equal to the attack resolved value
- **THEN** the attack is not dodged

### Requirement: Attack definitions own damage
The mobile combat system SHALL use attack definitions to determine damage instead of a persistent player damage statistic.

#### Scenario: Attack damage is selected from attack definition
- **WHEN** an actor performs an attack
- **THEN** the selected attack definition provides the life damage amount
- **THEN** the actor's persistent stats do not include a standalone damage stat
