## Why

A UI audit at 390x844 and 360x780 found defects that block or confuse play, plus systemic issues that make the UI hard to evolve:

- The confirmation dialog (new game over a save, leave hub) grows wider than the screen; the confirm button is cut off.
- The map's top row is clipped whenever feedback text or Collect Treasure appears, and the map jumps.
- The player is invisible while standing on the entrance; there is no position marker.
- Touch targets as small as 34 px, stat text at 10–11 px, white values on pastel bars (~1.3:1 contrast), disabled buttons that look enabled.
- No safe-area handling for notches or gesture bars, and no space reserved for a future ad banner.
- Styling is spread over ~120 per-node overrides with 9 button heights, 11 font sizes and 4 background tones.

## What Changes

- Add a shared, code-built UI theme (palette, button/label/panel variations, touch-size minimums) applied at the root.
- Add an app shell: every view is inset by the device safe area and by a reserved bottom ad banner slot.
- Reserve an ad banner slot (60 px + 12 px separation) on non-gameplay screens only; it collapses to zero when ads are disabled and is hidden on exploration and combat screens.
- Replace the native confirmation window with an in-game modal that wraps text and fits the screen.
- Size the map from the space actually available, keep exploration layout stable, and mark the player's position.
- Raise touch targets (48 px min, 56 px primary, 64 px D-pad) and text sizes; outline bar values for contrast; give disabled and "coming soon" buttons distinct styles.
- Replace ASCII D-pad labels with arrow icons; distinct speed and dungeon-XP icons; light map icons.
- Localize combat feedback text (English and Spanish).
- Make overlays block input while shown and make view switching hide every other view.

## Capabilities

### New Capabilities
- `app-shell`: safe-area insets, reserved ad banner slot, shared theme and touch/text size minimums, single active view.

### Modified Capabilities
- `dungeon-exploration`: player position marker, map sized to its area, readable map tiles, arrow-icon D-pad.
- `playable-feedback`: confirmations fit the screen.
- `monster-encounter`: localized combat feedback, feedback overlay blocks input.

## Impact

- `scripts/main.gd`, `scenes/main.tscn`, new `scripts/ui_theme.gd` and `scripts/ad_slot_config.gd`.
- New/updated SVG icons under `assets/icons/`.
- `localization/menu.{en,es}.po` gain combat feedback strings.
- Android export: edge-to-edge enabled, background colour matches the theme.
- No gameplay rule changes; save format unchanged.
