## ADDED Requirements

### Requirement: Manage equipment opens progression allocation
The new game view SHALL provide access to the level-up point allocation flow from the manage equipment action.

#### Scenario: Manage equipment opens allocation when points are pending
- **WHEN** the player has pending level-up improvement points
- **AND** the user selects the manage equipment action
- **THEN** the app displays the level-up allocation view

#### Scenario: Manage equipment remains available without pending points
- **WHEN** the player has no pending level-up improvement points
- **AND** the user selects the manage equipment action
- **THEN** the app does not allocate any stat points
- **THEN** the app may show the existing manage-equipment placeholder or an empty progression view

#### Scenario: Manage equipment label can be updated
- **WHEN** the new game view displays the action list
- **THEN** the manage equipment action label may be updated to a progression-oriented name
- **THEN** the action remains in the same lower action list position
