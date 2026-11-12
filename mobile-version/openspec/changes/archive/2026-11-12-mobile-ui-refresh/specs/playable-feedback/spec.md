## ADDED Requirements

### Requirement: Confirmations fit the screen
The mobile game SHALL show confirmation prompts as in-game modals whose title, message and both actions are fully visible on narrow screens.

#### Scenario: Long confirmation message is shown
- **WHEN** a confirmation prompt is shown on a 360 logical pixel wide screen
- **THEN** the message wraps inside the modal
- **AND** the confirm and cancel actions are fully on screen
- **AND** tapping cancel closes the modal without performing the action
