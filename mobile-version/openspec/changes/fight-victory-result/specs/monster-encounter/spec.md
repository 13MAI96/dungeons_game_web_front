## ADDED Requirements

### Requirement: Won fights show a victory result
The monster encounter view SHALL show a victory result after the player defeats a monster, naming the defeated monster and the experience gained, unless the run ends with that blow.

#### Scenario: Victory result after a won fight
- **WHEN** the player defeats a monster, other monsters remain and the player still has life and energy
- **THEN** the app shows a victory result over the dungeon exploration view
- **THEN** the result shows the defeated monster's localized name
- **THEN** the result shows the experience gained when it is greater than zero
- **THEN** the result shows the dungeon experience earned in the run and that retreating or completing the dungeon keeps it

#### Scenario: Continue returns to the map
- **WHEN** the victory result is shown and the player presses Continue or system back
- **THEN** the victory result closes and the dungeon exploration view is shown

#### Scenario: Last monster shows only the completion result
- **WHEN** the player defeats the last living monster in the dungeon
- **THEN** the app does not show the victory result
- **THEN** the dungeon completion result names the defeated monster and the experience gained above the completion rewards

#### Scenario: Last-energy kill shows only the depletion result
- **WHEN** the player defeats a monster, other monsters remain, and the player has zero energy
- **THEN** the app does not show the victory result
- **THEN** the run ends with the energy depletion notification

#### Scenario: Low energy warning waits for the victory result
- **WHEN** the winning blow leaves energy at or below the low energy warning threshold
- **THEN** the victory result is shown first without the low energy warning on top
- **THEN** the low energy warning is shown after the player dismisses the victory result

#### Scenario: Victory result is localized
- **WHEN** the application language is Spanish and the player wins a fight
- **THEN** the victory result title, text, monster name and Continue button are shown in Spanish

## MODIFIED Requirements

### Requirement: Attacking can defeat monster
The monster encounter view SHALL use combat rules to reduce monster life, damage the player when applicable, grant experience, show damage feedback when the player is damaged, explain combat outcomes, and mark the monster defeated when life reaches zero.

#### Scenario: Monster defeated by attack
- **WHEN** the user selects an attack and combat reduces monster life to zero or less
- **THEN** the monster is marked defeated
- **THEN** the player gains the monster experience value as current dungeon experience
- **THEN** the app shows the victory result with the underhand experience asset and the gained experience amount, instead of the short experience feedback overlay
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
