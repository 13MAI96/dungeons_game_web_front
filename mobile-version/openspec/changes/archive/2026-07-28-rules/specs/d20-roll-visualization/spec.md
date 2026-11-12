## ADDED Requirements

### Requirement: Combat rolls are displayed near actor stats
The monster encounter view SHALL show D20 roll values generated during combat below the statistics of the actor who rolled.

#### Scenario: Player attack roll is displayed
- **WHEN** the player performs an attack
- **THEN** the encounter view shows the player's D20 attack roll below the player statistics

#### Scenario: Monster dodge roll is displayed
- **WHEN** the monster rolls to dodge a player attack
- **THEN** the encounter view shows the monster's D20 dodge roll below the monster statistics

#### Scenario: Monster attack roll is displayed
- **WHEN** the monster performs an attack
- **THEN** the encounter view shows the monster's D20 attack roll below the monster statistics

#### Scenario: Player dodge roll is displayed
- **WHEN** the player rolls to dodge a monster attack
- **THEN** the encounter view shows the player's D20 dodge roll below the player statistics

### Requirement: D20 visual shows rolled value on main face
The mobile game SHALL use a D20 visual asset that can present the rolled value on its main face.

#### Scenario: D20 asset displays current roll
- **WHEN** a D20 roll value is shown in combat
- **THEN** the value is displayed on the primary visible face of the D20 visual
- **THEN** other face numbers are not shown as competing values
