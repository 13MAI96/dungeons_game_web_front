## 1. Implementation
- [x] 1.1 `FightVictoryModal` with icon, title, message and Continue (`_add_fight_victory_modal`, `_show_fight_victory`, `_hide_fight_victory`)
- [x] 1.2 `_fight()` victory path shows it instead of the experience overlay; back acts as Continue
- [x] 1.3 Last monster: completion result includes the victory lines (`_complete_dungeon_if_ready(..., victory_summary)`)
- [x] 1.4 Low-energy warning raised during the victory result waits for Continue
- [x] 1.5 Translated monster names (`MONSTER_NAME_*`) and EN/ES victory strings
- [x] 1.6 Playtest bot presses Continue on the victory result
- [x] 1.7 `_finish_depleted_dungeon_exit()` runs once per exit (stale overlay timer no longer wipes a newer run)

## 2. Verification
- [x] 2.1 `tests/verify_fight_victory.gd`; `tests/verify_monster_encounter_transition.gd` updated; full suite passing
- [ ] 2.2 `openspec validate fight-victory-result` and archive (OpenSpec CLI not installed on this machine)
- [ ] 2.3 Manual check on the Android emulator (English and Spanish)
