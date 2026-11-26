## ADDED Requirements

### Requirement: Level Up explains where points come from
The level-up allocation view SHALL explain, until the player chooses a class, how many progression points a new player starts with and how many each new level gives, using the rule values.

#### Scenario: Level 1 explains the starting points
- **WHEN** the player is level 1 without a class and opens the allocation view
- **THEN** a hint says the player starts with 5 points to spend and that each new level gives 3 more

#### Scenario: Later levels explain the points per level
- **WHEN** the player is level 2 or higher without a class and opens the allocation view
- **THEN** a hint says each new level gives 3 points to spend
- **THEN** the starting-points text is not shown

#### Scenario: Points hint is hidden with a class
- **WHEN** the player has selected a class
- **THEN** the allocation view shows no points hint

### Requirement: Level Up announces the class unlock level
The level-up allocation view SHALL tell the player, before the class choice level, at which level a class is chosen.

#### Scenario: Class unlock hint before level ten
- **WHEN** the player level is less than 10 and the allocation view is shown
- **THEN** a hint says that at level 10 the player chooses a class

#### Scenario: Class unlock hint is replaced by the choice
- **WHEN** the player level is 10 or greater and the player has not selected a class
- **THEN** the class unlock hint is not shown
- **THEN** the class choices are shown

#### Scenario: Class unlock hint is hidden after choosing
- **WHEN** the player selects a class
- **THEN** the class unlock hint is not shown

#### Scenario: Progression hints are localized
- **WHEN** the application language is Spanish, or is switched to Spanish
- **THEN** the progression hints are shown in Spanish with the same numbers
