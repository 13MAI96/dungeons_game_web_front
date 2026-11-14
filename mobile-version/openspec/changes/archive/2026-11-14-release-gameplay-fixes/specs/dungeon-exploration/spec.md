## ADDED Requirements

### Requirement: Player can abandon an expedition
The dungeon exploration view SHALL let the player abandon the expedition from any cell outside an encounter, at the cost of the run's provisional experience.

#### Scenario: Abandon is confirmed
- **WHEN** the player chooses to abandon the expedition and confirms
- **THEN** provisional dungeon experience is discarded
- **AND** the player's status is restored as for an alive dungeon exit
- **AND** the expedition result is shown over the hub

#### Scenario: Abandon is cancelled
- **WHEN** the player cancels the abandon confirmation
- **THEN** exploration continues unchanged
