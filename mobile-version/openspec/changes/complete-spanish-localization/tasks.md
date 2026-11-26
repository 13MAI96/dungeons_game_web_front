## 1. Implementation
- [x] 1.1 `scripts/localized_names.gd`: derived translation keys and display names for monsters, attacks/abilities, classes and effects
- [x] 1.2 `main.gd`: re-translate level-up title/back, monster attack popup title/close, D-pad and progression tooltips on language change; rebuild stat bars
- [x] 1.3 `main.gd`: translated monster name and `ENCOUNTER_MONSTER_NAME_LEVEL` header, attack names in the fight log and attack list, effect names, class buttons
- [x] 1.4 `scenes/main.tscn`: placeholder texts replaced by translation keys
- [x] 1.5 EN/ES strings for every data-driven name and the new UI texts

## 2. Verification
- [x] 2.1 `tests/verify_localization.gd` (po parity, data names, English/Spanish UI walk incl. a language switch); proven to fail on a hard-coded `"%s Lv. %s"` and on a stale "Level Up"/"Back" after a language switch
- [x] 2.2 Full suite passing
- [ ] 2.3 `openspec validate complete-spanish-localization` and archive (OpenSpec CLI not installed on this machine)
