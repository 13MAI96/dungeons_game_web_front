## ADDED Requirements

### Requirement: Stats keep one order on every screen
The mobile game SHALL list stats in one canonical order on every screen: life, energy, mana, armor, strength, speed, reputation, total experience, dungeon experience. A screen that does not show some stats SHALL keep the relative order of the others.

#### Scenario: Strength and speed keep their places
- **WHEN** the player looks at the hub, the Level Up rows, the Level Up stat guide or either side of the monster encounter view
- **THEN** armor comes before strength and strength comes before speed

#### Scenario: Screens with fewer stats keep the order
- **WHEN** a screen shows only some of the stats, such as the exploration view or the monster side of the encounter
- **THEN** the stats it shows appear in the same relative order as on every other screen
