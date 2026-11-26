## ADDED Requirements

### Requirement: Hub shows a progression hint
The new game view SHALL show a short progression hint under the player level until the player chooses a class.

#### Scenario: Starting points are pointed out
- **WHEN** the player is level 1, has reserved progression points and has not selected a class
- **THEN** the hint says the player starts with 5 points to spend in Progression

#### Scenario: Class unlock level is announced
- **WHEN** the player level is less than 10, the player has not selected a class
- **AND** the player is above level 1 or has no reserved points
- **THEN** the hint says that at level 10 the player chooses a class

#### Scenario: Class choice is waiting
- **WHEN** the player level is 10 or greater and the player has not selected a class
- **THEN** the hint says to choose a class in Progression

#### Scenario: Hint is hidden with a class
- **WHEN** the player has selected a class
- **THEN** no progression hint is shown under the level

#### Scenario: Hub hint is localized
- **WHEN** the application language is Spanish, or is switched to Spanish
- **THEN** the hub progression hint is shown in Spanish
