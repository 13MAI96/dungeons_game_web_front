## ADDED Requirements

### Requirement: Combat attack follows web damage rules
The mobile combat system SHALL resolve monster attacks using the damage rules from the existing web game.

#### Scenario: Attack consumes player energy
- **WHEN** the player attacks a monster
- **THEN** the system subtracts 2 from the player's current energy

#### Scenario: Critical hit damages monster
- **WHEN** the player attack roll is exactly 20
- **THEN** the system subtracts twice the player's base damage from the monster's life

#### Scenario: Successful hit damages monster
- **WHEN** the player attack roll plus current damage is greater than the monster armor
- **THEN** the system subtracts the player's base damage from the monster's life

#### Scenario: Failed low roll damages player
- **WHEN** the player attack roll plus current damage is lower than the monster damage
- **THEN** the system subtracts the monster damage from the player's current life

### Requirement: Monster counterattack follows web damage rules
The mobile combat system SHALL resolve monster counterattacks after a non-lethal successful player hit.

#### Scenario: Counterattack hits player
- **WHEN** the monster survives a successful player hit
- **AND** the monster counterattack roll plus monster damage is greater than the player's armor
- **THEN** the system subtracts the monster damage from the player's current life

#### Scenario: Counterattack misses player
- **WHEN** the monster survives a successful player hit
- **AND** the monster counterattack roll plus monster damage is not greater than the player's armor
- **THEN** the player's current life does not change from the counterattack

### Requirement: Defeating monsters grants experience
The mobile combat system SHALL mark defeated monsters cleared and grant their experience to the player.

#### Scenario: Monster defeated by combat
- **WHEN** combat reduces monster life to zero or less
- **THEN** the monster life is set to zero
- **THEN** the monster location is marked visited
- **THEN** the player gains the monster experience value

### Requirement: Recovery follows web player rules
The mobile combat system SHALL apply web recovery rules for rest and sanctuary effects.

#### Scenario: Rest restores status with mana
- **WHEN** the player rests with current mana greater than 9
- **THEN** the system restores 20 percent of maximum energy
- **THEN** the system restores 20 percent of maximum life
- **THEN** the system subtracts 10 current mana

#### Scenario: Rest does nothing without enough mana
- **WHEN** the player rests with current mana less than or equal to 9
- **THEN** the player's current energy, current life, and current mana remain unchanged

#### Scenario: Sanctuary restores status
- **WHEN** the player enters a sanctuary location
- **THEN** the system restores 50 percent of maximum energy
- **THEN** the system restores 50 percent of maximum life

### Requirement: Quest location outcome follows web treasure rules
The mobile combat system SHALL apply the existing web treasure-style rule when resolving quest locations.

#### Scenario: Quest success grants experience
- **WHEN** the player resolves a quest location and the random roll is greater than `20 - (player.vision * 5) / player.level`
- **THEN** the player gains 5 current experience
- **THEN** the location is marked visited

#### Scenario: Quest failure damages player
- **WHEN** the player resolves a quest location and the random roll is not greater than `20 - (player.vision * 5) / player.level`
- **THEN** the player loses 2 current life
- **THEN** the location is marked visited

### Requirement: Depleted player exits dungeon
The mobile combat system SHALL end the active dungeon run when the player's current life or current energy reaches zero or less.

#### Scenario: Player loses all life
- **WHEN** combat or a location effect reduces the player's current life to zero or less
- **THEN** the app exits the dungeon run
- **THEN** the player loses all current experience gained during the dungeon run
- **THEN** the player status is restored for the next run

#### Scenario: Player loses all energy
- **WHEN** combat or a location effect reduces the player's current energy to zero or less
- **THEN** the app exits the dungeon run
- **THEN** the player loses all current experience gained during the dungeon run
- **THEN** the player status is restored for the next run
