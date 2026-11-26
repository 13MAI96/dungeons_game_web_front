## 1. Implementation
- [x] 1.1 `scripts/tutorial.gd`: paged overlay (Next / Skip / Done, page counter, icon per page), texts filled from `CombatRules`
- [x] 1.2 Named constants for Rest, Sanctuary and treasure values in `combat_rules.gd` (values unchanged)
- [x] 1.3 `SettingsStore.load_tutorial_seen` / `save_tutorial_seen`; setters keep the other settings
- [x] 1.4 Open on first dungeon entry; mark seen on Skip / Done / back; hide on screen change
- [x] 1.5 "How to play" button in Settings
- [x] 1.6 EN/ES strings (Rioplatense voseo)
- [x] 1.7 Playtest bot skips the tutorial

## 2. Verification
- [x] 2.1 `tests/verify_first_run_tutorial.gd` (first run only, Skip, Done, reopen from Settings, back, fit on 1440x3088 and 1080x2220, rule numbers, EN/ES keys); full suite passing
- [ ] 2.2 `openspec validate first-run-tutorial` and archive (OpenSpec CLI not installed on this machine)
- [ ] 2.3 Manual check on the Android emulator (first run in Spanish)
