## MODIFIED Requirements

### Requirement: Encounter view shows monster and player details
The monster encounter view SHALL show the living monster and the player characteristics in the upper portion of the screen using image assets and icon stat bars.

#### Scenario: Living monster details are visible
- **WHEN** the player is in an active monster encounter
- **THEN** the upper portion shows the monster image asset on the right
- **THEN** the upper portion shows monster life, mana, armor, and damage as icon stat bars on the left
- **THEN** the monster life bar shows remaining life over the monster's original maximum life
- **THEN** the lower portion of the encounter details shows the player image asset on the left
- **THEN** the lower portion of the encounter details shows player characteristics as icon stat bars on the right
- **THEN** player stat lists keep the same ordering pattern as the main player statistics, starting with life

### Requirement: Attacking can defeat monster
The monster encounter view SHALL use combat rules to reduce monster life, damage the player when applicable, grant experience, show damage feedback when the player is damaged, and mark the monster defeated when life reaches zero.

#### Scenario: Monster defeated by attack
- **WHEN** the user selects the fight action and combat reduces monster life to zero or less
- **THEN** the monster is marked defeated
- **THEN** the player gains the monster experience value
- **THEN** the app shows an experience feedback overlay using the underhand asset and the gained experience amount
- **THEN** no stale exploration feedback text remains for the next encounter
- **THEN** the app returns to dungeon exploration for the current location

#### Scenario: Attack does not defeat monster
- **WHEN** the user selects the fight action and the monster remains alive
- **AND** the player still has current life and current energy
- **THEN** the monster encounter remains visible
- **THEN** the monster and player displayed stats reflect the combat result
- **THEN** the monster life bar keeps showing the original maximum life as the total

#### Scenario: Attack damages player
- **WHEN** the user selects the fight action and combat reduces player current life
- **THEN** the app shows the damage feedback overlay

#### Scenario: Attack depletes player during encounter
- **WHEN** the user selects the fight action and combat reduces player current life or current energy to zero or less
- **THEN** the app exits the dungeon run
- **THEN** the active monster encounter closes
- **THEN** the player loses current experience gained during the dungeon run

#### Scenario: Defeated monster does not reopen encounter
- **WHEN** the player returns to a monster location after that monster was defeated
- **THEN** the app does not display the monster encounter view for that defeated monster
