## 1. Implementation
- [x] 1.1 `_create_stat_bar()`: move the value out of the bar into a right-aligned, fixed-width column (`_create_stat_value_label()`, `STAT_VALUE_MIN_WIDTH`)
- [x] 1.2 Slim, vertically centred track (`STAT_BAR_TRACK_HEIGHT`); plain `UiTheme.TEXT` number at `FONT_STAT_VALUE` 14 px
- [x] 1.3 Narrow-screen fit: compact spacing, track and XP label minimums; `HUB_PORTRAIT_MIN_WIDTH`

## 2. Verification
- [x] 2.1 New `tests/verify_stat_bars.gd`: number beside the bar, aligned, not clipped, AA contrast, no horizontal overflow on hub / exploration / Level Up / fight panel at 1080x2220, 1440x3088 and 1080x2400 with large values, in English and Spanish (XP labels not trimmed); a real tap on the number opens the help
- [x] 2.2 `verify_ui_assets.gd` and `verify_monster_encounter_transition.gd` use the new `Value` path; `verify_stat_help.gd` passes unchanged in its row counts; full suite passing
- [x] 2.3 Screenshots at 1080x2220 (hub, exploration, Level Up, fight panel) reviewed on the desktop renderer
- [ ] 2.4 `openspec validate readable-stat-bars` and archive (OpenSpec CLI not installed on this machine)
- [ ] 2.5 Manual check on a phone (English and Spanish)
