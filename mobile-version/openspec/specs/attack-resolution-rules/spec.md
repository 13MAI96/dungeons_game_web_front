# attack-resolution-rules Specification

## Purpose
Define how a single attack is resolved: D20 accuracy against armor and Strength, critical thresholds, dodge, and damage taken from attack definitions.

## Requirements

### Requirement: Critical attacks bypass armor and dodge
The mobile combat system SHALL treat an attack roll greater than or equal to the selected attack's critical threshold as a critical hit.

#### Scenario: Attack reaches configured critical threshold
- **WHEN** an attacker uses an attack with critical threshold 19
- **AND** the attacker rolls 19 on the D20
- **THEN** the attack is a critical hit
- **THEN** defender armor does not prevent the hit
- **THEN** defender dodge does not prevent the hit

#### Scenario: Natural twenty is critical
- **WHEN** an attacker uses an attack with the default critical threshold 20
- **AND** the attacker rolls exactly 20 on the D20
- **THEN** the attack is a critical hit
- **THEN** defender armor does not prevent the hit
- **THEN** defender dodge does not prevent the hit

#### Scenario: Attack below configured critical threshold is not critical
- **WHEN** an attacker uses an attack with critical threshold 19
- **AND** the attacker rolls 18 on the D20
- **THEN** the attack is not a critical hit
- **THEN** normal armor and dodge rules apply

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

### Requirement: Attack accuracy uses bounded half-scaled Strength and armor
The mobile combat system SHALL make half-scaled Strength improve attack accuracy while half-scaled armor and a fixed difficulty oppose the attack, with hit chance bounded between 10 and 90 percent.

#### Scenario: Attack misses
- **WHEN** an attacker rolls a non-critical D20 attack
- **AND** the D20 is below `clamp(10 + floor(defender armor / 2) - floor(attacker strength / 2), 3, 19)`
- **THEN** the attack misses
- **AND** the defender loses no life

#### Scenario: Attack can hit
- **WHEN** an attacker rolls a non-critical D20 attack
- **AND** the D20 meets or exceeds `clamp(10 + floor(defender armor / 2) - floor(attacker strength / 2), 3, 19)`
- **AND** the defender does not dodge
- **THEN** the attack hits for the selected attack damage

### Requirement: Dodge uses bounded half-scaled opposed Speed
The mobile combat system SHALL resolve dodge using half-scaled opposed Speed with dodge chance bounded between 5 and 35 percent.

#### Scenario: Defender dodges
- **WHEN** a non-critical attack passes its accuracy check
- **AND** the D20 meets or exceeds `clamp(20 + floor(attacker speed / 2) - floor(defender speed / 2), 14, 20)`
- **THEN** the defender dodges and loses no life

#### Scenario: Defender fails to dodge
- **WHEN** the D20 is below the bounded required dodge roll
- **THEN** the attack is not dodged
