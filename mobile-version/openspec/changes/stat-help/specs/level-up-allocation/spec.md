## ADDED Requirements

### Requirement: Level Up explains what each stat does
The Level Up screen SHALL show, for each assignable statistic, its name, the gain of one allocated point for the player's class, and the same short description used by the stat help popup.

#### Scenario: Stat guide is shown
- **WHEN** the Level Up screen is displayed
- **THEN** a "What each stat does" section lists life, energy, mana, armor, speed, and strength
- **THEN** each entry shows the gain of one point, such as "+5 per point" for life
- **THEN** each entry shows the stat description

#### Scenario: Stat guide follows the class growth
- **WHEN** the player's class changes how much a point adds to a statistic
- **THEN** the stat guide shows the class growth value for that statistic
