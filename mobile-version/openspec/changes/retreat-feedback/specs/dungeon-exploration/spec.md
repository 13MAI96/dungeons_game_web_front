## ADDED Requirements

### Requirement: Disabled Retreat explains how to retreat
The dungeon exploration view SHALL show, next to the Retreat action, why Retreat is disabled when the player is not on the dungeon entrance.

#### Scenario: Player is away from the entrance
- **WHEN** the player is in a dungeon location that is not the entrance
- **THEN** the Retreat action is disabled
- **THEN** a caption under the Retreat action says "Return to the green entrance to retreat" ("Volvé a la entrada verde para retirarte" in Spanish)
- **THEN** the map cell size does not change when the caption appears or disappears

#### Scenario: Player is on the entrance
- **WHEN** the player is on the dungeon entrance
- **THEN** the Retreat action is enabled
- **THEN** no Retreat reason is shown

#### Scenario: Retreat is selected away from the entrance
- **WHEN** the Retreat action is triggered while the player is not on the entrance
- **THEN** the run continues and nothing changes
- **THEN** the Retreat reason stays visible and is not repeated in the exploration feedback

### Requirement: Entrance is easy to find on the map
The dungeon exploration view SHALL highlight the entrance cell and SHALL point toward the entrance when it is outside the visible map window.

#### Scenario: Entrance is in the map window
- **WHEN** the entrance cell is inside the visible map window
- **THEN** the entrance cell is green with a light-green ring inside it
- **THEN** the player marker stays visible above the ring when the player is on the entrance
- **THEN** no direction arrow is shown

#### Scenario: Entrance is outside the map window
- **WHEN** the entrance cell is outside the visible map window
- **THEN** the window cell nearest to the entrance shows a light-green arrow pointing toward the entrance
- **THEN** exactly one such arrow is shown
