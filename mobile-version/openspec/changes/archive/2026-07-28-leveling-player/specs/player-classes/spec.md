## ADDED Requirements

### Requirement: Player classes are data driven
The mobile game SHALL load player class definitions from a local JSON file.

#### Scenario: Class JSON defines progression
- **WHEN** player classes are loaded
- **THEN** each class defines id, name, progression point conversion, automatic increment cadence, and automatic stat increments

### Requirement: Player chooses class at level ten
The mobile game SHALL allow the player to choose one class when the player reaches level 10.

#### Scenario: Class choice unavailable before level ten
- **WHEN** the player level is less than 10
- **THEN** class selection is not available

#### Scenario: Class choice available at level ten
- **WHEN** the player level is 10 or greater
- **AND** the player has not selected a class
- **THEN** the progression view shows class choices loaded from JSON

#### Scenario: Class choice is stored
- **WHEN** the player selects a class
- **THEN** that class id is stored on the player
- **THEN** class-gated abilities use the selected class for eligibility

### Requirement: Class progression changes stat growth
The mobile game SHALL always convert each gained level into 3 assignable points and use the selected class progression object to decide how much each assigned point increases each statistic.

#### Scenario: Class converts levels into points
- **WHEN** the player has selected a class
- **AND** progression converts available level-ups into assignable points
- **THEN** each converted level grants 3 assignable points

#### Scenario: Class changes stat growth per point
- **WHEN** the player has selected a class
- **AND** the player assigns progression points to statistics
- **THEN** the selected class stat growth values determine how much each statistic increases per assigned point

#### Scenario: Class grants automatic increments
- **WHEN** the player has selected a class
- **AND** a gained level matches the class automatic increment cadence
- **THEN** the class automatic stat increments are applied without spending assignable points
