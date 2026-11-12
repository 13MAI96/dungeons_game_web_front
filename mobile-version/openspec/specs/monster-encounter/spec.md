# monster-encounter Specification

## Purpose
Describe the encounter view entered from a monster location and the feedback shown while fighting.

## Requirements

### Requirement: Encounter view shows monster and player details
The monster encounter view SHALL show the living monster and the player characteristics in the upper portion of the screen using image assets and icon stat bars.

#### Scenario: Living monster details are visible
- **WHEN** the player is in an active monster encounter
- **THEN** the upper portion shows the monster image asset on the right
- **THEN** the upper portion shows monster life, mana, armor, speed, and strength as icon stat bars on the left
- **THEN** the monster life bar shows remaining life over the monster's original maximum life
- **THEN** the monster name includes `Lv. N`
- **THEN** the lower portion of the encounter details shows the player image asset on the left
- **THEN** the lower portion of the encounter details shows player life, energy, mana, armor, strength, speed, reputation, and experience as icon stat bars on the right
- **THEN** player stat lists keep the same ordering pattern as the main player statistics, starting with life

### Requirement: Encounter actions include attacks and flee
The monster encounter view SHALL show available player attacks and a flee action in the lower portion of the screen while the monster is alive.

#### Scenario: Combat actions are visible
- **WHEN** the player is in an active monster encounter and the monster is alive
- **THEN** the lower action area shows each currently available player attack
- **THEN** the lower action area shows a flee action

#### Scenario: Flee succeeds
- **WHEN** the player selects flee during a monster encounter
- **AND** the D20 roll plus player speed minus monster speed is greater than 0
- **THEN** the system subtracts 1 from the player's current energy
- **THEN** the app closes the encounter and returns to dungeon exploration
- **THEN** the monster location remains unvisited

#### Scenario: Flee fails
- **WHEN** the player selects flee during a monster encounter
- **AND** the D20 roll plus player speed minus monster speed is less than or equal to 0
- **THEN** the system subtracts 1 from the player's current energy
- **THEN** the monster performs a normal attack
- **THEN** the monster encounter remains visible if the player is not depleted
- **THEN** the player can attempt to flee again

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

### Requirement: Combat feedback is localized
The monster encounter view SHALL show combat outcome text in the selected application language.

#### Scenario: Spanish is selected
- **WHEN** the application language is Spanish and an attack resolves
- **THEN** the combat feedback text is shown in Spanish

### Requirement: Feedback overlay blocks input
The monster encounter view SHALL ignore taps on underlying actions while the damage or experience feedback overlay is visible.

#### Scenario: Player taps during feedback
- **WHEN** the feedback overlay is visible and the player taps where an action button is
- **THEN** the underlying action is not triggered
