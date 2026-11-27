## MODIFIED Requirements

### Requirement: Encounter view shows monster and player details
The monster encounter view SHALL show the living monster and the player characteristics in the upper portion of the screen using image assets and icon stat bars.

#### Scenario: Living monster details are visible
- **WHEN** the player is in an active monster encounter
- **THEN** the upper portion shows the monster image asset on the right
- **THEN** the upper portion shows monster life, mana, armor, strength, and speed as icon stat bars on the left, in that order
- **THEN** the monster life bar shows remaining life over the monster's original maximum life
- **THEN** the monster name includes `Lv. N`
- **THEN** the lower portion of the encounter details shows the player image asset on the left
- **THEN** the lower portion of the encounter details shows player life, energy, mana, armor, strength, speed, reputation, and experience as icon stat bars on the right
- **THEN** player stat lists keep the same ordering pattern as the main player statistics, starting with life
