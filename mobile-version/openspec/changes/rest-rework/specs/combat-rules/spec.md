## MODIFIED Requirements

### Requirement: Recovery follows web player rules
The mobile combat system SHALL apply the new recovery rules for rest, sanctuary, and alive dungeon exits, with each sanctuary usable once per dungeon run. Rest SHALL restore fixed, predictable amounts and SHALL report the points really gained.

#### Scenario: Rest restores status with mana
- **WHEN** the player rests during dungeon exploration
- **AND** the player has at least 5 current mana
- **AND** current life or current energy is below its maximum
- **THEN** the system restores 20 percent of maximum energy, rounded, without exceeding maximum energy
- **THEN** the system restores 30 percent of maximum life, rounded, without exceeding maximum life
- **THEN** the system does not restore mana
- **THEN** the system subtracts 5 current mana
- **THEN** the result reports the life and energy really restored and the mana spent

#### Scenario: Rest does nothing without enough mana
- **WHEN** the player rests during dungeon exploration
- **AND** the player has less than 5 current mana
- **THEN** the system does not restore energy
- **THEN** the system does not restore life
- **THEN** current mana remains unchanged
- **THEN** the result gives "not enough mana" as the reason

#### Scenario: Rest is refused at full life and energy
- **WHEN** the player rests with at least 5 current mana
- **AND** current life and current energy are both at their maximum
- **THEN** life, energy and mana remain unchanged
- **THEN** the result gives "already full" as the reason

#### Scenario: Sanctuary restores status
- **WHEN** the player enters a sanctuary location that has not been used in this run
- **THEN** the system restores between 50 and 100 percent of maximum life
- **THEN** the system restores between 50 and 100 percent of maximum energy
- **THEN** the system restores between 50 and 100 percent of maximum mana
- **THEN** the sanctuary location becomes visited

#### Scenario: Used sanctuary is entered again
- **WHEN** the player enters a sanctuary location that was already used in this run
- **THEN** no life, energy or mana is restored

#### Scenario: Dungeon exit restores status
- **WHEN** the player exits the dungeon without dying
- **THEN** the system restores current energy to maximum energy
- **THEN** the system restores current life to maximum life
- **THEN** the system restores current mana to maximum mana
