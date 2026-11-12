## MODIFIED Requirements

### Requirement: Player statistics mirror web player component stat set
The new game view SHALL display current player statistics for life, energy, mana, armor, strength, speed, reputation, and experience using icon-based stat bars inspired by the web `player-component`.

#### Scenario: Player statistics are visible
- **WHEN** the new game view is displayed
- **THEN** the user can see life, energy, mana, armor, strength, speed, reputation, and experience statistics in that order
- **THEN** damage is not displayed as a standalone player statistic
- **THEN** each statistic is identified by an icon instead of a text label
- **THEN** each statistic displays its value inside the bar
- **THEN** each statistic icon and filled bar use the same stat-specific color from the web `player-component`
- **THEN** stat bars remain within the visible screen bounds on mobile viewports

#### Scenario: Current and maximum values are visible where applicable
- **WHEN** a statistic has current and maximum values
- **THEN** the stat bar shows the current amount and maximum amount
- **THEN** the bar visually distinguishes the current filled amount from the remaining amount using a dark remaining segment
