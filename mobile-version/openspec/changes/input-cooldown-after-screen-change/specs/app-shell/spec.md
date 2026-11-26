## ADDED Requirements

### Requirement: Taps right after a screen change are ignored
The mobile game SHALL ignore taps that arrive within 300 milliseconds of a screen, modal or overlay being shown or hidden, so a fast second tap meant for the previous screen does not trigger an action on the new one.

#### Scenario: Fast tap after a won fight
- **WHEN** the player wins a fight and the victory result appears
- **AND** the player taps again within the cooldown
- **THEN** the tap does not press any button on the victory result
- **WHEN** the player dismisses the victory result and taps a move arrow within the cooldown
- **THEN** the hero does not move

#### Scenario: Double tap on Level Up confirm
- **WHEN** the player double taps Confirm on the level-up screen
- **AND** the second tap lands on Exit on the hub that replaces it
- **THEN** the leave-to-menu confirmation is not shown

#### Scenario: Tap after the cooldown works
- **WHEN** the cooldown after a screen change has passed
- **AND** the player taps a button
- **THEN** the button acts normally

#### Scenario: Programmatic actions are not delayed
- **WHEN** game code calls an action directly during the cooldown
- **THEN** the action runs without waiting
