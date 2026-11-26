## ADDED Requirements

### Requirement: Leaving with staged points asks for confirmation
The level-up allocation view SHALL ask the player to confirm before discarding staged (unconfirmed) points when the player leaves it with the Back button or the system back action.

#### Scenario: Back without staged points
- **WHEN** no points are staged and the player presses Back or system back
- **THEN** the hub is shown immediately without a confirmation

#### Scenario: Back with staged points asks to discard
- **WHEN** one or more points are staged and the player presses Back or system back
- **THEN** a "Discard changes?" confirmation is shown with a Discard and a Cancel button
- **THEN** the allocation view stays visible behind it

#### Scenario: Discard is confirmed
- **WHEN** the discard confirmation is shown and the player presses Discard
- **THEN** the staged points are dropped and remain in the player's reserve
- **THEN** no permanent statistic changes
- **THEN** the hub is shown

#### Scenario: Discard is cancelled
- **WHEN** the discard confirmation is shown and the player presses Cancel or system back
- **THEN** the confirmation closes and the allocation view stays visible
- **THEN** the staged points are unchanged

#### Scenario: Discard confirmation is localized
- **WHEN** the application language is Spanish and the discard confirmation is shown
- **THEN** its title, message and buttons are shown in Spanish
