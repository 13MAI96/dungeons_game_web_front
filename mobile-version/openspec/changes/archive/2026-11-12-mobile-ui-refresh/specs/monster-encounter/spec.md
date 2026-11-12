## ADDED Requirements

### Requirement: Combat feedback is localized
The monster encounter view SHALL show combat outcome text in the selected application language.

#### Scenario: Spanish is selected
- **WHEN** the application language is Spanish and an attack resolves
- **THEN** the combat feedback text is shown in Spanish

### Requirement: Feedback overlay blocks input
The monster encounter view SHALL ignore taps on underlying actions while the damage or experience feedback overlay is visible.

#### Scenario: Player taps during feedback
- **WHEN** the feedback overlay is visible and the player taps where an action button is
- **THEN** the underlying action is not triggered
