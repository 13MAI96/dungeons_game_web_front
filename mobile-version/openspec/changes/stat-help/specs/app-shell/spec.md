## ADDED Requirements

### Requirement: Stat bars explain their stat on tap
The mobile game SHALL show a stat's name and a short description when the player taps its stat bar or icon, using one shared stat help popup on every screen that shows stat bars.

#### Scenario: Player taps a stat bar
- **WHEN** the player taps a stat icon or bar on the hub, the exploration view, the Level Up screen or the monster encounter view
- **THEN** a popup shows that stat's localized name and a short description of what it does
- **THEN** descriptions that mention rule values use the values from the combat rules

#### Scenario: Every stat has help
- **WHEN** a stat bar for life, energy, mana, armor, strength, speed, reputation, total experience or dungeon experience is tapped
- **THEN** its help is shown, for player and monster stat bars alike

#### Scenario: A tap anywhere closes the help
- **WHEN** the stat help popup is open and the player taps anywhere on the screen
- **THEN** the popup closes
- **THEN** the tap does not activate the control underneath

#### Scenario: Back or a screen change closes the help
- **WHEN** the stat help popup is open and the player presses back or the screen changes
- **THEN** the popup closes and the current screen stays as it was

#### Scenario: Dragging does not open the help
- **WHEN** the player drags across a stat bar to scroll
- **THEN** the stat help popup does not open
