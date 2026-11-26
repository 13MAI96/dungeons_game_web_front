## 1. Implementation
- [x] 1.1 `CombatRules` reports `player_attack_damage` and `counterattack_damage` (no rule change)
- [x] 1.2 `scripts/combat_feedback.gd`: result to fight log entries, outcome labels and float texts
- [x] 1.3 `scripts/fight_log.gd`: last 4 entries, oldest first, newest highlighted, reset per encounter
- [x] 1.4 `scripts/damage_numbers.gd`: 0.8 s rising and fading numbers over the portraits, above the damage overlay
- [x] 1.5 `main.gd`: wire `_fight()`, `_flee_encounter()`, `_show_monster_encounter()`; damage overlay names the attack and damage; hint line hidden when empty
- [x] 1.6 Remove `COMBAT_FEEDBACK_*` keys, add `COMBAT_OUTCOME_*` and `COMBAT_LOG_*` (EN/ES), rewrite rules message texts

## 2. Verification
- [x] 2.1 `tests/verify_combat_feedback.gd`; `verify_monster_encounter_transition.gd`, `verify_localization.gd`, `verify_ui_shell.gd` updated; full suite passing
- [ ] 2.2 `openspec validate combat-feedback` and archive (OpenSpec CLI not installed on this machine)
- [ ] 2.3 Manual check on the Android emulator or a phone (English and Spanish)
