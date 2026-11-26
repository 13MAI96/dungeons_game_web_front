## MODIFIED Requirements

### Requirement: Encounter view shows monster and player details
The monster encounter view SHALL show the living monster and the player characteristics in the upper portion of the screen using image assets and icon stat bars.

#### Scenario: Living monster details are visible
- **WHEN** the player is in an active monster encounter
- **THEN** the upper portion shows the monster image asset on the right
- **THEN** the upper portion shows monster life, mana, armor, speed, and strength as icon stat bars on the left
- **THEN** the monster life bar shows remaining life over the monster's original maximum life
- **THEN** the monster name is shown in the active language and includes its level (`Lv. N` in English, `Nv. N` in Spanish)
- **THEN** the lower portion of the encounter details shows the player image asset on the left
- **THEN** the lower portion of the encounter details shows player life, energy, mana, armor, strength, speed, reputation, and experience as icon stat bars on the right
- **THEN** player stat lists keep the same ordering pattern as the main player statistics, starting with life

### Requirement: Combat feedback is localized
The monster encounter view SHALL show combat outcome text, including monster attack and effect names, in the selected application language.

#### Scenario: Spanish is selected
- **WHEN** the application language is Spanish and an attack resolves
- **THEN** the combat feedback text is shown in Spanish
- **THEN** the name of the monster attack in the feedback is shown in Spanish
- **THEN** the monster attack information lists attack and effect names in Spanish
