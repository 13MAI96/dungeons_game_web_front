## MODIFIED Requirements

### Requirement: Exploration actions include rest and retreat
The dungeon exploration view SHALL show Rest and Retreat actions below the movement controls. The Rest action SHALL show its mana cost and SHALL be disabled, with the reason shown, when it cannot be used.

#### Scenario: Rest and retreat are visible
- **WHEN** the dungeon exploration view is displayed and the player is not in an active monster encounter
- **THEN** the lower action area shows "Rest · 5 mana" ("Descansar · 5 maná" in Spanish) and "Retreat" actions

#### Scenario: Retreat is enabled only at entrance
- **WHEN** the player is not at the dungeon entrance
- **THEN** the retreat action is disabled or unavailable

#### Scenario: Retreat costs energy at entrance
- **WHEN** the player is at the dungeon entrance and selects retreat
- **THEN** the system subtracts 1 from current energy
- **THEN** the app exits the dungeon alive even if that spent point was the player's last current energy point

#### Scenario: Rest is disabled without enough mana
- **WHEN** the player has less than 5 current mana during dungeon exploration
- **THEN** the Rest action is disabled
- **THEN** the exploration feedback says that resting needs 5 mana

#### Scenario: Rest is disabled at full life and energy
- **WHEN** the player has at least 5 current mana and current life and energy are both at their maximum
- **THEN** the Rest action is disabled
- **THEN** the exploration feedback says that life and energy are full

#### Scenario: Rest is unavailable during an encounter
- **WHEN** a monster encounter is active
- **THEN** the Rest action cannot be used and resting changes nothing

### Requirement: Exploration resolves special location effects
The dungeon exploration view SHALL apply rule-derived location effects when the player enters or uses actions in special dungeon locations.

#### Scenario: Entering sanctuary restores player status
- **WHEN** the player moves into a `SANCTUARY` location
- **THEN** the system restores between 50 and 100 percent of maximum life
- **THEN** the system restores between 50 and 100 percent of maximum energy
- **THEN** the system restores between 50 and 100 percent of maximum mana
- **THEN** the sanctuary location remains unvisited so the effect can trigger on future visits

#### Scenario: Quest location exposes collect action
- **WHEN** the player moves into an unresolved `QUEST` location
- **THEN** the lower action area shows a collect-treasure action
- **THEN** the quest is not resolved until the user selects the collect-treasure action

#### Scenario: Resolving quest location consumes energy and marks visited
- **WHEN** the player resolves a `QUEST` location
- **THEN** the system subtracts 1 from the player's current energy
- **THEN** the system grants experience when the D20 roll is between 10 and 20 inclusive
- **THEN** the system applies trap damage when the D20 roll is below 10
- **THEN** the quest location is marked visited

#### Scenario: Rest action uses recovery rule
- **WHEN** the player selects Rest during dungeon exploration
- **AND** the player has at least 5 current mana
- **AND** current life or current energy is below its maximum
- **THEN** the system restores 20 percent of maximum energy, rounded, up to maximum energy
- **THEN** the system restores 30 percent of maximum life, rounded, up to maximum life
- **THEN** the system does not restore mana
- **THEN** the system subtracts 5 current mana
- **THEN** the exploration feedback shows the real result, for example "+3 life, +5 energy, −5 mana" ("+3 de vida, +5 de energía, −5 de maná" in Spanish)

#### Scenario: Rest remains available between dungeon runs
- **WHEN** a previous dungeon disabled actions while exiting
- **AND** the player begins or continues a new active dungeon on an empty location
- **AND** current life or current energy is below its maximum
- **THEN** Rest is enabled
- **AND** full current mana does not prevent using Rest

#### Scenario: Rest action requires mana
- **WHEN** the player selects Rest during dungeon exploration
- **AND** the player has less than 5 current mana
- **THEN** life, energy, and mana remain unchanged

#### Scenario: Location effect depletes player
- **WHEN** a dungeon location effect reduces player current life or current energy to zero or less
- **THEN** the app exits the dungeon run
- **THEN** the player loses current experience gained during the dungeon run

## ADDED Requirements

### Requirement: Exploration messages clear on the next move
The dungeon exploration view SHALL show the message of an exploration action (rest result, sanctuary, treasure, retreat refusal) only until the player moves again.

#### Scenario: Rest result disappears after moving
- **WHEN** the player rests and then moves to another location
- **THEN** the rest result is no longer shown
- **THEN** only the message of the new location (for example a sanctuary) or the reason Rest is disabled remains, if any
