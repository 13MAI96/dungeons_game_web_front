## ADDED Requirements

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
