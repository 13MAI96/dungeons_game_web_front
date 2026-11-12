## MODIFIED Requirements

### Requirement: Manage equipment opens progression allocation
The new game view SHALL provide access to the progression flow from the manage equipment/progression action.

#### Scenario: Manage equipment opens allocation when points are pending
- **WHEN** the player has reserved progression points
- **AND** the user selects the manage equipment action
- **THEN** the app displays the level-up allocation view

#### Scenario: Manage equipment converts available level-ups
- **WHEN** the player has enough experience for one or more levels
- **AND** the user selects the manage equipment action
- **THEN** the app converts every available level-up into reserved progression points
- **THEN** the app displays the progression allocation view

#### Scenario: Manage equipment remains available without pending points
- **WHEN** the player has no reserved progression points and no convertible level-ups
- **AND** the user selects the manage equipment action
- **THEN** the app does not allocate any stat points
- **THEN** the app may show the existing manage-equipment placeholder or an empty progression view

#### Scenario: Manage equipment label can be updated
- **WHEN** the new game view displays the action list
- **THEN** the manage equipment action label may be updated to a progression-oriented name
- **THEN** the action remains in the same lower action list position

#### Scenario: Class choice appears in progression
- **WHEN** the player is level 10 or greater
- **AND** the player has not selected a class
- **AND** the user opens progression
- **THEN** the progression view shows class choices before class-gated ability unlocks are applied
