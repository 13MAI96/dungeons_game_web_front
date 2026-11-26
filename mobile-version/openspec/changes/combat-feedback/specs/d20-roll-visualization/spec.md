## MODIFIED Requirements

### Requirement: Combat rolls are displayed near actor stats
The monster encounter view SHALL NOT show raw D20 roll values below actor statistics during combat; player-facing combat feedback SHALL summarize outcomes in readable text instead, through the fight log and the floating damage numbers.

#### Scenario: Player attack roll is displayed
- **WHEN** the player performs an attack
- **THEN** the encounter view does not show the player's raw D20 attack roll below the player statistics
- **THEN** the fight log explains the player attack outcome and the damage dealt

#### Scenario: Monster dodge roll is displayed
- **WHEN** the monster rolls to dodge a player attack
- **THEN** the encounter view does not show the monster's raw D20 dodge roll below the monster statistics
- **THEN** the fight log and a floating "Dodged" over the monster explain when the player attack was dodged

#### Scenario: Monster attack roll is displayed
- **WHEN** the monster performs an attack
- **THEN** the encounter view does not show the monster's raw D20 attack roll below the monster statistics
- **THEN** the fight log identifies the monster attack, its outcome and the damage taken

#### Scenario: Player dodge roll is displayed
- **WHEN** the player rolls to dodge a monster attack
- **THEN** the encounter view does not show the player's raw D20 dodge roll below the player statistics
- **THEN** the fight log and a floating "Dodged" over the player explain when the monster attack was dodged
