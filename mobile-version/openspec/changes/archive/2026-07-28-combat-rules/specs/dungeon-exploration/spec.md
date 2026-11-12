## ADDED Requirements

### Requirement: Exploration resolves special location effects
The dungeon exploration view SHALL apply web-derived location effects when the player enters or uses actions in special dungeon locations.

#### Scenario: Entering sanctuary restores player status
- **WHEN** the player moves into a `SANCTUARY` location
- **THEN** the system restores 50 percent of maximum energy
- **THEN** the system restores 50 percent of maximum life
- **THEN** the sanctuary location is marked visited

#### Scenario: Resolving quest location consumes energy and marks visited
- **WHEN** the player resolves a `QUEST` location
- **THEN** the system subtracts 1 from the player's current energy
- **THEN** the system applies the quest success or failure outcome
- **THEN** the quest location is marked visited

#### Scenario: Rest action uses recovery rule
- **WHEN** the player selects Rest during dungeon exploration
- **THEN** the system applies the web rest recovery rule to current mana, current energy, and current life

#### Scenario: Location effect depletes player
- **WHEN** a dungeon location effect reduces player current life or current energy to zero or less
- **THEN** the app exits the dungeon run
- **THEN** the player loses current experience gained during the dungeon run
