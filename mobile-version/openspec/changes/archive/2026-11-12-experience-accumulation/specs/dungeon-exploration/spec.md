## ADDED Requirements

### Requirement: Dungeon experience has an active-run lifecycle
The dungeon exploration view SHALL distinguish provisional experience earned during the active run from permanent accumulated experience.

#### Scenario: Dungeon starts
- **WHEN** the player begins dungeon exploration
- **THEN** provisional dungeon experience starts at zero
- **AND** permanent accumulated experience remains unchanged

#### Scenario: Experience is displayed during exploration
- **WHEN** the player is exploring a dungeon
- **THEN** permanent accumulated experience and provisional dungeon experience are shown in separate labeled bars
- **AND** gaining dungeon experience changes only the provisional bar

#### Scenario: Dungeon completes or player retreats
- **WHEN** the player completes the dungeon or retreats through the entrance
- **THEN** provisional dungeon experience is added to permanent accumulated experience
- **AND** provisional dungeon experience is reset to zero

#### Scenario: Dungeon ends through depletion
- **WHEN** life or energy reaches zero
- **THEN** provisional dungeon experience is reset to zero
- **AND** permanent accumulated experience remains unchanged
