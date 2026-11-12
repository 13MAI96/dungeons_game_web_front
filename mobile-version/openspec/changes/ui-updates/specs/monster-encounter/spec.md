## MODIFIED Requirements

### Requirement: Attacking can defeat monster
The monster encounter view SHALL use combat rules to reduce monster life, damage the player when applicable, grant experience, show damage feedback when the player is damaged, explain combat outcomes, and mark the monster defeated when life reaches zero.

#### Scenario: Monster defeated by attack
- **WHEN** the user selects an attack and combat reduces monster life to zero or less
- **THEN** the monster is marked defeated
- **THEN** the player gains the monster experience value as current dungeon experience
- **THEN** the app shows an experience feedback overlay using the underhand asset and the gained experience amount
- **THEN** no stale exploration feedback text remains for the next encounter
- **THEN** the app returns to dungeon exploration for the current location unless the dungeon is complete

#### Scenario: Attack does not defeat monster
- **WHEN** the user selects an attack and the monster remains alive
- **AND** the player still has current life and current energy
- **THEN** the monster encounter remains visible
- **THEN** the monster and player displayed stats reflect the combat result
- **THEN** the monster life bar keeps showing the original maximum life as the total

#### Scenario: Attack damages player
- **WHEN** monster combat reduces player current life
- **THEN** the app shows the damage feedback overlay

#### Scenario: Attack depletes player during encounter
- **WHEN** combat reduces player current life or current energy to zero or less
- **THEN** the app shows a depletion notification before leaving the encounter
- **THEN** the app exits the dungeon run after the notification
- **THEN** the active monster encounter closes
- **THEN** the player loses current experience gained during the dungeon run

#### Scenario: Defeated monster does not reopen encounter
- **WHEN** the player returns to a monster location after that monster was defeated
- **THEN** the app does not display the monster encounter view for that defeated monster

## ADDED Requirements

### Requirement: Combat feedback explains outcomes
The monster encounter view SHALL show readable combat feedback instead of raw D20 roll readouts below actor statistics.

#### Scenario: Player attack result is explained
- **WHEN** the player performs an attack
- **THEN** the encounter feedback identifies the player attack outcome as hit, critical hit, protected or blocked, missed, or dodged

#### Scenario: Monster attack result is explained
- **WHEN** the monster performs a counterattack
- **THEN** the encounter feedback identifies the monster attack name
- **THEN** the encounter feedback identifies whether the monster attack hit, was protected or blocked, missed, or was dodged

#### Scenario: Raw dice values are not shown under stats
- **WHEN** combat resolves player or monster rolls
- **THEN** the encounter view does not show raw D20 roll values below the player statistics
- **THEN** the encounter view does not show raw D20 roll values below the monster statistics

### Requirement: Monster attack information is available
The monster encounter view SHALL provide an information control for inspecting the active monster's attacks.

#### Scenario: Monster info control is visible
- **WHEN** the player is in an active monster encounter
- **THEN** an information button is visible over or near the monster image

#### Scenario: Monster attacks are shown
- **WHEN** the player uses the monster information button
- **THEN** the app shows the monster's available attacks in a tooltip or modal
- **THEN** each listed attack includes the attack name
- **THEN** each listed attack includes available cost and effect information when present

#### Scenario: Monster attack information can be dismissed
- **WHEN** the monster attack tooltip or modal is visible
- **THEN** the player can dismiss it and remain in the active encounter
