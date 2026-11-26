## MODIFIED Requirements

### Requirement: Attack definitions own damage
The mobile combat system SHALL use attack definitions to determine base damage and critical damage instead of a persistent player damage statistic, adding a Strength bonus so damage grows with the attacker.

#### Scenario: Attack damage is selected from attack definition
- **WHEN** an actor performs an attack
- **THEN** the selected attack definition provides the base life damage amount
- **THEN** the damage dealt is that amount plus `max(0, floor((attacker strength - 3) / 2))`
- **THEN** the actor's persistent stats do not include a standalone damage stat

#### Scenario: Critical damage uses selected attack percent
- **WHEN** an actor lands a critical hit
- **THEN** the selected attack definition provides the critical damage percent
- **THEN** the final damage is the strength-adjusted attack damage plus the configured critical extra damage

#### Scenario: Decimal critical damage is rounded down
- **WHEN** critical damage calculation produces a decimal value
- **THEN** the final damage is rounded down to the lower integer
