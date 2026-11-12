## ADDED Requirements

### Requirement: Encounter view shows monster and player details
The monster encounter view SHALL show the living monster and the player characteristics in the upper portion of the screen.

#### Scenario: Living monster details are visible
- **WHEN** the player is in an active monster encounter
- **THEN** the upper portion shows the monster image
- **THEN** the upper portion shows monster life, armor, mana, and damage
- **THEN** the upper portion shows player characteristics relevant to combat

### Requirement: Encounter actions include attacks and flee
The monster encounter view SHALL show available attack actions and a flee action in the lower portion of the screen while the monster is alive.

#### Scenario: Combat actions are visible
- **WHEN** the player is in an active monster encounter and the monster is alive
- **THEN** the lower action area shows available attack buttons
- **THEN** the lower action area shows a flee action

### Requirement: Attacking can defeat monster
The monster encounter view SHALL allow attacks to reduce monster life and mark the monster defeated when life reaches zero.

#### Scenario: Monster defeated by attack
- **WHEN** the user selects an available attack and the attack reduces monster life to zero or less
- **THEN** the monster is marked defeated
- **THEN** the app returns to dungeon exploration for the current location

#### Scenario: Defeated monster does not reopen encounter
- **WHEN** the player returns to a monster location after that monster was defeated
- **THEN** the app does not display the monster encounter view for that defeated monster

### Requirement: Flee returns to exploration
The monster encounter view SHALL allow the player to flee from a monster encounter.

#### Scenario: Player flees encounter
- **WHEN** the user selects flee during an active monster encounter
- **THEN** the app returns to dungeon exploration
- **THEN** the monster remains alive unless it was defeated before fleeing

#### Scenario: Fleeing preserves living monster encounter
- **WHEN** the player flees from a living monster location
- **THEN** the monster location remains unvisited
- **THEN** returning to that location starts the monster encounter again
