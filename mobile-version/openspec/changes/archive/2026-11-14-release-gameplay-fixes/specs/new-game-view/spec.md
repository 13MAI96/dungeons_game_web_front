## MODIFIED Requirements

### Requirement: Pending progression is visually indicated
The new game view SHALL visually indicate when the player has reserved progression points available to assign or enough experience to level up.

#### Scenario: Progression indicator is visible with reserved points
- **WHEN** the new game view displays the progression or manage-equipment action
- **AND** the player has one or more reserved progression points
- **THEN** the action shows a small visible pending indicator such as a red dot or equivalent badge

#### Scenario: Progression indicator is visible with a convertible level-up
- **WHEN** the new game view displays the progression action
- **AND** current experience meets the threshold for at least one level-up
- **THEN** the pending indicator is shown

#### Scenario: Progression indicator is hidden without reserved points
- **WHEN** the new game view displays the progression or manage-equipment action
- **AND** the player has no reserved progression points
- **AND** current experience does not meet the next level-up threshold
- **THEN** the pending indicator is not shown

#### Scenario: Progression indicator updates after allocation
- **WHEN** the player assigns all reserved progression points
- **AND** the app returns to the new game view
- **THEN** the pending indicator is no longer shown
