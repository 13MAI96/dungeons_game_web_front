## ADDED Requirements

### Requirement: Stat bar numbers are readable at any fill level
The mobile game SHALL draw the current and maximum value of every stat bar beside the bar, on the plain row background, so the number has the same contrast whatever the fill level. This applies to every screen that shows stat bars.

#### Scenario: Low bar keeps a readable number
- **WHEN** a stat bar is nearly empty, half full or full on the hub, the exploration view, the Level Up screen or the monster encounter view
- **THEN** the "current/max" number is shown to the right of the bar, not over the coloured fill or the empty track
- **THEN** the number uses light text with at least 4.5:1 contrast against the screen and card backgrounds

#### Scenario: Numbers line up
- **WHEN** several stat bars are stacked on a screen
- **THEN** their numbers are right-aligned in a column wide enough for "999/999", so they share one right edge
- **THEN** a longer number widens its row instead of being clipped

#### Scenario: Stat bars fit small and large phones
- **WHEN** the hub, the exploration view, the Level Up screen or the monster encounter view is shown on a 1080x2220 or a 1440x3088 screen with large stat values
- **THEN** every stat bar, its number and the Level Up plus and minus buttons stay within the screen width

#### Scenario: The number is part of the tap target
- **WHEN** the player taps the number of a stat bar
- **THEN** the stat help for that stat opens, as for a tap on the icon or the bar
