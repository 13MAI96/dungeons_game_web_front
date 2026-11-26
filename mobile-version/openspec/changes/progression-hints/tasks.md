## 1. Implementation
- [x] 1.1 `CombatRules.CLASS_CHOICE_LEVEL` and its use in `select_player_class()` and `_rebuild_class_choices()`
- [x] 1.2 Level Up `ProgressionHints` (points hint, class unlock hint) updated in `_update_level_allocation_view()`
- [x] 1.3 Hub `ProgressionHint` caption under the level, updated in `_update_hub_header()`
- [x] 1.4 EN/ES strings (`LEVEL_HINT_*`, `HUB_HINT_*`)

## 2. Verification
- [x] 2.1 `tests/verify_progression_hints.gd`; `tests/verify_localization.gd` captures Level Up at level 1; full suite passing
- [ ] 2.2 `openspec validate progression-hints` and archive (OpenSpec CLI not installed on this machine)
- [ ] 2.3 Manual check on the Android emulator (English and Spanish, hub caption fits on small screens)

## 3. Follow-up (not in this change)
- [ ] 3.1 Pacing and Strength tuning from `docs/progression-check-2026-11-26.md`
