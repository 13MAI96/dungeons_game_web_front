## Why

In a user test, the numbers on the stat bars were hard to read. The white "current/max" label sat centred over the bar with a dark outline, so on a low bar it was half on the coloured fill and half on the dark empty track. Testers still struggled with it on small phones. Vikunja task DNG-18.

## What Changes

- **The number moves beside the bar.** Every stat row is now: icon, optional label (Total XP, Dungeon XP), a slim bar track, and the "current/max" number in its own right-aligned column. The number is always drawn on the plain dark row background, so it reads the same at 0 %, 50 % or 100 %.
- **Fixed-width number column.** The column is at least wide enough for "999/999", so the numbers of stacked rows line up on one right edge. A longer value (large XP thresholds) widens its own column instead of being clipped.
- **Plain light text, a little larger.** The number uses the theme's main text colour (AA contrast on the screen background and the cards) at 14 px instead of 13 px, without the outline it needed over the fill.
- **Slimmer track.** The bar is a 14 px track centred in the 24 px row; the whole row stays the tap target for the stat help (DNG-7), including the number.
- **Room on narrow screens.** Compact rows use 4 px spacing and a 32 px minimum track; the XP label keeps 82 px so "XP mazmorra" is not trimmed. The hub portrait may shrink to 112 px wide (the art scales to fit), so the hub stats with large values fit a 1440x3088 phone.
- No new texts.

## Capabilities

### New Capabilities
- None.

### Modified Capabilities
- `app-shell`: stat bar numbers are readable at any fill level on every screen.
- `new-game-view`: the hub statistics show their value beside the bar instead of inside it.

## Impact

`scripts/main.gd` (`_create_stat_bar()`, new `_create_stat_value_label()`, `STAT_BAR_TRACK_HEIGHT`, `STAT_VALUE_MIN_WIDTH`, `HUB_PORTRAIT_MIN_WIDTH`), `scripts/ui_theme.gd` (`FONT_STAT_VALUE` 13 → 14). The value label moves from `<Stat>StatBar/Bar/Value` to `<Stat>StatBar/Value`: `tests/verify_ui_assets.gd` and `tests/verify_monster_encounter_transition.gd` updated. New `tests/verify_stat_bars.gd`. No rule, save or text change.
