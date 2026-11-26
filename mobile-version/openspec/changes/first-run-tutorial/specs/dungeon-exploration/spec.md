## ADDED Requirements

### Requirement: First dungeon entry shows a how-to-play tutorial
The mobile game SHALL show a short, paged how-to-play tutorial the first time the player enters a dungeon on a device, explaining the core rules with the real rule values.

#### Scenario: First dungeon entry opens the tutorial
- **WHEN** the player enters a dungeon
- **AND** the how-to-play tutorial has not been skipped or finished on this device
- **THEN** the app shows the tutorial on its first page over the dungeon exploration view
- **THEN** the first page offers Next and Skip

#### Scenario: Tutorial explains the core rules
- **WHEN** the player pages through the tutorial
- **THEN** the pages explain the map grid and the arrow buttons
- **THEN** the pages state the energy cost per step, per fight round, per flee attempt and per treasure, taken from the combat rules
- **THEN** the pages explain that dungeon experience is provisional: kept on dungeon completion or Retreat, lost when energy or life run out
- **THEN** the pages explain that Retreat only works on the green entrance
- **THEN** the pages state the Rest mana cost and the energy and life it restores
- **THEN** the pages explain sanctuaries and treasures with their rule values

#### Scenario: Last page offers Done
- **WHEN** the tutorial shows its last page
- **THEN** the page offers Done instead of Next and Skip
- **THEN** Done closes the tutorial and marks it as seen

#### Scenario: Player skips the tutorial
- **WHEN** the player selects Skip or presses back while the tutorial is open
- **THEN** the tutorial closes and the player stays in the dungeon
- **THEN** the tutorial is marked as seen

#### Scenario: Tutorial is shown on first run only
- **WHEN** the tutorial was already skipped or finished on this device
- **AND** the player enters a dungeon again, in this or a new game
- **THEN** the tutorial does not open automatically

#### Scenario: Tutorial fits portrait phones
- **WHEN** the tutorial is shown on a 1440x3088 or 1080x2220 portrait screen, in English or Spanish
- **THEN** the tutorial card and its buttons are fully on screen and touch-sized
