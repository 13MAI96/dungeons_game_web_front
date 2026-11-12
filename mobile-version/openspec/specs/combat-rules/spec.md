# combat-rules Specification

## Purpose
Define the turn-level combat loop between the player and a monster, including resource costs, counterattacks, fleeing, recovery, and death.

## Requirements

### Requirement: Combat attack follows web damage rules
The mobile combat system SHALL resolve player and monster attacks using the new D20 attack-resolution rules.

#### Scenario: Attack consumes player energy
- **WHEN** the player attacks a monster
- **THEN** the system subtracts the selected attack energy cost from the player's current energy

#### Scenario: Critical hit damages monster
- **WHEN** the attacker attack roll is exactly 20
- **THEN** the attack is a critical hit
- **THEN** armor and dodge do not prevent the hit
- **THEN** the system subtracts damage from the defender according to the selected attack definition

#### Scenario: Successful hit damages monster
- **WHEN** the attacker roll minus defender armor minus attacker strength is greater than 0
- **AND** the defender does not dodge
- **THEN** the system subtracts damage from the defender according to the selected attack definition

#### Scenario: Failed low roll damages player
- **WHEN** the attacker roll minus defender armor minus attacker strength is less than or equal to 0
- **THEN** the attack misses
- **THEN** the defender loses no life from the attack

### Requirement: Monster counterattack follows web damage rules
The mobile combat system SHALL resolve monster attacks using the same D20 attack-resolution rules as player attacks.

#### Scenario: Monster randomly selects an affordable attack
- **WHEN** a living monster performs an attack
- **THEN** the system selects one available monster attack at random
- **AND** the selected attack mana cost does not exceed the monster's current mana
- **AND** the system subtracts the selected attack mana cost from the monster's current mana

#### Scenario: Monster attack exposes side effect ids
- **WHEN** a monster attack hits the player
- **AND** the selected attack defines effect ids
- **THEN** the combat result exposes those effect ids for later effect resolution

#### Scenario: Counterattack hits player
- **WHEN** a living monster performs an attack
- **AND** the attack is a critical hit or the player does not dodge a positive resolved attack
- **THEN** the system subtracts monster attack damage from the player's current life

#### Scenario: Counterattack misses player
- **WHEN** a living monster performs an attack
- **AND** the attack is not critical
- **AND** the attack resolved value is less than or equal to 0 or the player dodges
- **THEN** the player's current life does not change from that monster attack

### Requirement: Defeating monsters grants experience
The mobile combat system SHALL mark defeated monsters cleared and grant their experience to the player.

#### Scenario: Monster defeated by combat
- **WHEN** combat reduces monster life to zero or less
- **THEN** the monster life is set to zero
- **THEN** the monster location is marked visited
- **THEN** the player gains the monster experience value as current dungeon experience

### Requirement: Recovery follows web player rules
The mobile combat system SHALL apply the new recovery rules for rest, sanctuary, and alive dungeon exits.

#### Scenario: Rest restores status with mana
- **WHEN** the player rests during dungeon exploration
- **AND** the player has at least 5 current mana
- **THEN** the system restores between 5 and 25 percent of maximum energy
- **THEN** the system restores between 10 and 40 percent of maximum life
- **THEN** the system does not restore mana
- **THEN** the system subtracts 5 current mana

#### Scenario: Rest does nothing without enough mana
- **WHEN** the player rests during dungeon exploration
- **AND** the player has less than 5 current mana
- **THEN** the system does not restore energy
- **THEN** the system does not restore life
- **THEN** current mana remains unchanged

#### Scenario: Sanctuary restores status
- **WHEN** the player enters a sanctuary location
- **THEN** the system restores between 50 and 100 percent of maximum life
- **THEN** the system restores between 50 and 100 percent of maximum energy
- **THEN** the system restores between 50 and 100 percent of maximum mana
- **THEN** the sanctuary location remains unvisited

#### Scenario: Dungeon exit restores status
- **WHEN** the player exits the dungeon without dying
- **THEN** the system restores current energy to maximum energy
- **THEN** the system restores current life to maximum life
- **THEN** the system restores current mana to maximum mana

### Requirement: Quest location outcome follows web treasure rules
The mobile combat system SHALL apply treasure rules when resolving quest locations.

#### Scenario: Quest success grants experience
- **WHEN** the player resolves a quest location and the random roll succeeds
- **AND** the D20 roll is between 10 and 20 inclusive
- **THEN** the player gains quest experience as current dungeon experience
- **THEN** the location is marked visited

#### Scenario: Quest failure damages player
- **WHEN** the player resolves a quest location and the random roll fails
- **AND** the D20 roll is below 10
- **THEN** the player loses current life according to the quest trap rule
- **THEN** the location is marked visited

#### Scenario: Quest action consumes energy
- **WHEN** the player opens a treasure or resolves a quest location
- **THEN** the system subtracts 1 from the player's current energy

### Requirement: Depleted player exits dungeon
The mobile combat system SHALL end the active dungeon run when the player's current life or current energy reaches zero or less.

#### Scenario: Player loses all life
- **WHEN** combat or a location effect reduces the player's current life to zero or less
- **THEN** the app exits the dungeon run
- **THEN** the player loses all current experience gained during the dungeon run
- **THEN** the player receives the dungeon death sequel
- **THEN** current energy and current mana are restored to their maximum values

#### Scenario: Player loses all energy
- **WHEN** combat or a location effect reduces the player's current energy to zero or less
- **THEN** the app exits the dungeon run
- **THEN** the player loses all current experience gained during the dungeon run
- **THEN** current life, current energy, and current mana are restored to their maximum values

### Requirement: Player attacks require full resources
The mobile combat system SHALL reject a player attack unless its complete energy and mana costs can be paid.

#### Scenario: Attack has sufficient resources
- **WHEN** current energy and mana meet or exceed the selected attack costs
- **THEN** both costs are consumed
- **AND** the attack resolves normally

#### Scenario: Attack lacks energy or mana
- **WHEN** either current resource is below its selected attack cost
- **THEN** the attack is rejected with readable feedback
- **AND** no resource is consumed
- **AND** no monster counterattack occurs
