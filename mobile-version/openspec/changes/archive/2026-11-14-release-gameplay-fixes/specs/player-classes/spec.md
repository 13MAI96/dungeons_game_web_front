## ADDED Requirements

### Requirement: Class growth values are whole numbers
The mobile game SHALL define every class stat growth and automatic increment as a positive whole number so each assigned point has a visible effect.

#### Scenario: Class data is loaded
- **WHEN** the player classes are read
- **THEN** every stat growth value is an integer of at least 1
