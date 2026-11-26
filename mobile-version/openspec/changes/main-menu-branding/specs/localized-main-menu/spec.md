## MODIFIED Requirements

### Requirement: Main menu uses mobile-first layout
The main menu SHALL display its primary options as a centered vertical list in the lower portion of the screen, with the game branding in the upper portion.

#### Scenario: Menu options are positioned below reserved logo space
- **WHEN** the main menu is displayed on a mobile viewport
- **THEN** the primary options appear centered horizontally as a vertical list near the bottom of the screen
- **THEN** the upper portion of the screen remains free of menu options
- **THEN** the upper portion shows the game logo and title

## ADDED Requirements

### Requirement: Main menu shows game branding
The main menu SHALL show the game logo and the game title, in the active language, above the primary options.

#### Scenario: English title is visible
- **WHEN** the main menu is displayed and the active language is English
- **THEN** the logo is shown above the title "Dungeons"

#### Scenario: Spanish title is visible
- **WHEN** the main menu is displayed and the active language is Spanish
- **THEN** the logo is shown above the title "Mazmorras"

#### Scenario: Branding fits supported phones
- **WHEN** the main menu is displayed on a 1440x3088 or a 1080x2220 portrait screen
- **THEN** the logo and title do not overlap the primary options or the ad banner slot

#### Scenario: Logo asset is missing
- **WHEN** the logo image cannot be loaded
- **THEN** the main menu still shows the title and the primary options
