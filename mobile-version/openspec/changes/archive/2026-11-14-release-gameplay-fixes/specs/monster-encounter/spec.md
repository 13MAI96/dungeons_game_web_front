## ADDED Requirements

### Requirement: Unaffordable attacks are disabled
The monster encounter view SHALL disable the attack action and explain why when the player cannot pay its energy or mana cost.

#### Scenario: Player lacks energy for an attack
- **WHEN** the encounter is shown and current energy or mana is below the attack cost
- **THEN** the Fight action is disabled
- **AND** feedback explains that resources are insufficient
- **AND** Flee remains available

### Requirement: Victory resolves before depletion
The monster encounter view SHALL resolve a monster defeat, and any resulting dungeon completion, before checking whether the player ran out of energy.

#### Scenario: Last monster defeated with the last energy
- **WHEN** the player's attack defeats the last living monster and leaves the player with zero energy
- **THEN** the dungeon is completed with its experience and reputation rewards
- **AND** the run is not treated as an energy depletion

#### Scenario: Monster defeated with the last energy before the dungeon is complete
- **WHEN** the player's attack defeats a monster, other monsters remain, and the player has zero energy
- **THEN** the defeated monster stays defeated
- **AND** the run then ends as an energy depletion
