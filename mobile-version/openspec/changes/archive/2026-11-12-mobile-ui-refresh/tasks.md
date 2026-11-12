## 1. Foundations

- [x] 1.1 Add `scripts/ui_theme.gd` with palette, default font sizes and type variations; apply it to `Main`
- [x] 1.2 Add `scripts/ad_slot_config.gd` and the bottom `AdSlot` panel with debug placeholder
- [x] 1.3 Add safe-area + ad-slot inset logic applied to every view and overlay, re-applied on resize
- [x] 1.4 Centralise view switching so showing a view hides all others and sets ad-slot visibility
- [x] 1.5 Enable Android edge-to-edge and set the export background colour

## 2. Critical fixes

- [x] 2.1 Replace `ConfirmationDialog` with an in-game modal that wraps text and fits the screen
- [x] 2.2 Compute map cell size from available space; re-render on resize
- [x] 2.3 Add a player position ring inside the current map cell

## 3. Screens

- [x] 3.1 Scene: remove per-node style overrides, apply type variations, guideline sizes
- [x] 3.2 Hub: level header, primary Explore button, coming-soon style
- [x] 3.3 Exploration: top HUD stats, arrow-icon D-pad, single action row, fixed feedback height
- [x] 3.4 Map: distinct unseen/blocked/sanctuary tiles, light location icons
- [x] 3.5 Encounter: 48 px info button, primary Fight, danger Flee, readable feedback
- [x] 3.6 Level-up, settings, result and monster info screens use theme panels and sizes
- [x] 3.7 Stat bars: larger text, outlined values; distinct speed and dungeon-XP icons

## 4. Feedback and localization

- [x] 4.1 Localize combat feedback strings (en/es)
- [x] 4.2 Feedback overlay blocks input while visible

## 5. Verification

- [x] 5.1 Add `tests/verify_ui_shell.gd` (ad slot, insets, single view, confirmation fits, marker, touch sizes)
- [x] 5.2 All tests pass; screenshots at 360x780, 390x844, 480x854; emulator check
- [x] 5.3 Validate and archive the change
