## MODIFIED Requirements

### Requirement: Encounter actions include attacks and flee
The monster encounter view SHALL show the web-rule fight action and a flee action in the lower portion of the screen while the monster is alive.

#### Scenario: Combat actions are visible
- **WHEN** the player is in an active monster encounter and the monster is alive
- **THEN** the lower action area shows a fight action
- **THEN** the lower action area shows a flee action

### Requirement: Attacking can defeat monster
The monster encounter view SHALL use combat rules to reduce monster life, damage the player when applicable, grant experience, and mark the monster defeated when life reaches zero.

#### Scenario: Monster defeated by attack
- **WHEN** the user selects the fight action and combat reduces monster life to zero or less
- **THEN** the monster is marked defeated
- **THEN** the player gains the monster experience value
- **THEN** the app returns to dungeon exploration for the current location

#### Scenario: Attack does not defeat monster
- **WHEN** the user selects the fight action and the monster remains alive
- **AND** the player still has current life and current energy
- **THEN** the monster encounter remains visible
- **THEN** the monster and player displayed stats reflect the combat result

#### Scenario: Attack depletes player during encounter
- **WHEN** the user selects the fight action and combat reduces player current life or current energy to zero or less
- **THEN** the app exits the dungeon run
- **THEN** the active monster encounter closes
- **THEN** the player loses current experience gained during the dungeon run

#### Scenario: Defeated monster does not reopen encounter
- **WHEN** the player returns to a monster location after that monster was defeated
- **THEN** the app does not display the monster encounter view for that defeated monster
