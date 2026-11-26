## Why

The main menu's upper half was empty: it was reserved "for a future logo" and nothing told the player which game they had opened (Vikunja task DNG-5).

## What Changes

- The main menu shows a **logo** (`res://assets/ui/logo.svg`) and the **translated game title** (`GAME_TITLE`: "Dungeons" / "Mazmorras") above the menu buttons, in the space previously left empty.
- The title uses a new `GameTitleLabel` theme variation in `scripts/ui_theme.gd` (44 px, bold, bright gold with a dark outline).
- The logo scales with the free space (square, bottom-aligned over the title, at least 96 px tall) so the menu fits both a 1440x3088 and a 1080x2220 phone without overlapping the buttons or the ad banner slot.
- The logo is loaded null-safe: if the file is missing, the logo is hidden and the title alone brands the menu.

## Capabilities

### Modified Capabilities
- `localized-main-menu`: the upper portion of the main menu shows the logo and the translated game title.

## Impact

`scenes/main.tscn` (`MainMenuView/Branding` replaces the empty `LogoSpace`), `scripts/main.gd`, `scripts/ui_theme.gd`, `localization/menu.*.po` (1 key), `tests/verify_ui_shell.gd`. The logo art is `assets/ui/logo.svg`.
