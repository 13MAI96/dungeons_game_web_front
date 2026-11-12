# d20-roll-visualization Specification

## Purpose
Describe how D20 rolls are shown to the player during combat.

## Requirements

### Requirement: Combat rolls are displayed near actor stats
The monster encounter view SHALL NOT show raw D20 roll values below actor statistics during combat; player-facing combat feedback SHALL summarize outcomes in readable text instead.

#### Scenario: Player attack roll is displayed
- **WHEN** the player performs an attack
- **THEN** the encounter view does not show the player's raw D20 attack roll below the player statistics
- **THEN** the encounter feedback explains the player attack outcome

#### Scenario: Monster dodge roll is displayed
- **WHEN** the monster rolls to dodge a player attack
- **THEN** the encounter view does not show the monster's raw D20 dodge roll below the monster statistics
- **THEN** the encounter feedback explains when the player attack was dodged

#### Scenario: Monster attack roll is displayed
- **WHEN** the monster performs an attack
- **THEN** the encounter view does not show the monster's raw D20 attack roll below the monster statistics
- **THEN** the encounter feedback identifies the monster attack and outcome

#### Scenario: Player dodge roll is displayed
- **WHEN** the player rolls to dodge a monster attack
- **THEN** the encounter view does not show the player's raw D20 dodge roll below the player statistics
- **THEN** the encounter feedback explains when the monster attack was dodged

### Requirement: D20 visual shows rolled value on main face
The mobile game SHALL use a D20 visual asset that can present the rolled value on its main face.

#### Scenario: D20 asset displays current roll
- **WHEN** a D20 roll value is shown in combat
- **THEN** the value is displayed on the primary visible face of the D20 visual
- **THEN** other face numbers are not shown as competing values
