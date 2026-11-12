## ADDED Requirements

### Requirement: Player position is marked on the map
The dungeon exploration view SHALL mark the player's current cell with a marker that is visible on every tile type, including the entrance.

#### Scenario: Player stands on the entrance
- **WHEN** the player is on the entrance cell
- **THEN** the entrance stays green
- **AND** the player marker is drawn on that cell

#### Scenario: Player moves
- **WHEN** the player moves to another cell
- **THEN** exactly one cell shows the player marker

### Requirement: Map fits its area without clipping
The dungeon exploration view SHALL size map cells from the space available after the stats and action controls, so every visible map row is fully shown.

#### Scenario: Feedback or treasure action appears
- **WHEN** exploration feedback text or the Collect Treasure action becomes visible
- **THEN** no map row is clipped
- **AND** the map cell size does not change

### Requirement: Map tiles are readable
The dungeon exploration view SHALL draw unseen, blocked, sanctuary and entrance cells in distinguishable colours and draw location icons with sufficient contrast against their tiles.

#### Scenario: Different tile types are visible
- **WHEN** unseen, blocked, sanctuary and entrance cells are on screen
- **THEN** each type uses a different colour
- **AND** monster, quest and sanctuary icons are light-coloured on darker tiles

### Requirement: Direction buttons use arrow icons
The dungeon exploration view SHALL show arrow icons on the direction buttons, each at least 64 logical pixels in its smaller dimension.

#### Scenario: Direction pad is shown
- **WHEN** the exploration view is visible
- **THEN** each direction button shows an arrow icon instead of a text character
