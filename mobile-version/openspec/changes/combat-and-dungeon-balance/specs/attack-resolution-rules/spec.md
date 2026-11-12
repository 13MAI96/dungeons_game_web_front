## MODIFIED Requirements

### Requirement: Attacks resolve with D20 armor strength formula
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

### Requirement: Defenders can dodge non-critical attacks
The mobile combat system SHALL resolve dodge using half-scaled opposed Speed with dodge chance bounded between 5 and 35 percent.

#### Scenario: Defender dodges
- **WHEN** a non-critical attack passes its accuracy check
- **AND** the D20 meets or exceeds `clamp(20 + floor(attacker speed / 2) - floor(defender speed / 2), 14, 20)`
- **THEN** the defender dodges and loses no life

#### Scenario: Defender fails to dodge
- **WHEN** the D20 is below the bounded required dodge roll
- **THEN** the attack is not dodged
