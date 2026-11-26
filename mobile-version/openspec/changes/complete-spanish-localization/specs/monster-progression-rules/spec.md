## MODIFIED Requirements

### Requirement: Monster names show level
The monster encounter view SHALL display each monster's level beside its name, with a level label in the active language.

#### Scenario: Monster level is visible
- **WHEN** the player is in an active monster encounter
- **THEN** the monster name is displayed with `Lv. N` in English and `Nv. N` in Spanish
- **THEN** `N` is the monster's current level
