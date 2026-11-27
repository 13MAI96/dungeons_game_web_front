## Context

`_create_stat_bar()` in `main.gd` is the only place that builds stat rows. The hub, the exploration HUD, the Level Up rows (`StatPreview`, next to the points label and the +/- buttons) and both sides of the fight panel use it. Before this change the row was `Icon`, optional `Label`, then a 24 px `ProgressBar` with the `Value` label anchored full-rect inside it: white text, 5 px dark outline, centred.

## Goals / Non-Goals

**Goals:** numbers legible at any fill level on small (1080x2220) and large (1440x3088) phones; every screen still fits without horizontal overflow; rows stay tappable for the stat help.

**Non-Goals:** changing the stat colours, the icons or what values are shown.

## Decisions

1. **Number outside the bar (chosen).** Options considered:
   - *Stronger outline or a drop shadow over the full-width bar.* Still drawn over two backgrounds that change with the fill, so contrast varies along the text. Pastel fills (energy yellow, armor grey) make white text weak even with an outline, and a heavier outline blurs the 13 px digits on small phones.
   - *Dark text on a light chip inside the bar.* Hides part of the bar and adds a third colour.
   - *Number in its own column right of the bar.* The text always sits on the same dark row background, so contrast does not depend on the fill. It is the only option whose legibility does not change with the value. Cost: the bar is shorter.

   The column is right-aligned with `STAT_VALUE_MIN_WIDTH` = 56 px (fits "999/999" at 14 px), so stacked numbers line up. A Label without clipping reports its text width as its minimum size, so a longer value (for example "12345/23456" XP) widens its own row instead of being cut.

2. **Text style.** `UiTheme.TEXT` (#f2e8d8) on `BACKGROUND`/`SURFACE` is well above WCAG AA 4.5:1; `verify_stat_bars.gd` checks this with the WCAG formula. The outline is no longer needed. `FONT_STAT_VALUE` goes from 13 to 14 px; it is only used by this label.

3. **Slim track.** With no text inside, the bar becomes a 14 px track (`STAT_BAR_TRACK_HEIGHT`), vertically centred (`SIZE_SHRINK_CENTER`) in the 24 px row. This also fixes the Level Up rows, where the 24 px bar used to stick to the top of the 48 px row while the icon was centred.

4. **Fitting narrow screens.** The number column costs about 60 px per row. Measured with large values (all stats 999, XP 12345/23456):
   - Compact rows (every current screen): spacing 6 → 4 px, minimum track 56 → 32 px. The XP label keeps 82 px: "XP mazmorra" needs 79 px at 12 px, and a narrower label trimmed it (the test checks both languages).
   - Hub: the portrait's minimum width is 132 px for every character image. On a 1440x3088 phone (393 logical px wide) that left 210 px for the stats, less than the XP row needs. The hub portrait alone gets `HUB_PORTRAIT_MIN_WIDTH` = 112 px. The art keeps its aspect and scales to fit, so it only loses a little size on narrow screens.
   - Fight panel and exploration HUD already had enough width.

5. **Tapping.** The `Value` label is a child of the row, which `stat_help_popup.attach(row, ...)` already wires (children ignore input, the row receives the tap). `verify_stat_help.gd` keeps tapping the centre of each row, and `verify_stat_bars.gd` taps the number itself.

## Risks / Trade-offs

- Shorter bars: the fill is a little less precise to read at a glance. The exact value is now always readable, which is what testers asked for.
- Values above five digits per side would widen the row past the hub column on the narrowest phones. Experience reaches that only far beyond level 30; the test covers 5-digit values.
- Node path change (`Bar/Value` → `Value`); only tests used it.
