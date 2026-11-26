## ADDED Requirements

### Requirement: Saved attacks follow current definitions
The mobile game SHALL refresh the player's saved attacks from the current ability definitions when a save is loaded, so balance changes reach existing players.

#### Scenario: Attack definition changed after the save was written
- **WHEN** a save is loaded whose attacks have ids present in the ability data
- **THEN** each attack uses the current damage, costs and critical values from the ability data

#### Scenario: Saved attack id no longer exists
- **WHEN** a saved attack id is not present in the ability data
- **THEN** the saved attack is kept unchanged
