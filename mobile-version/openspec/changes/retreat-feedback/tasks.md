## 1. Implementation
- [x] 1.1 `main.gd`: Retreat reason caption under the Rest / Retreat row (`_add_retreat_hint()`, `_get_retreat_block_hint()`, `_update_retreat_hint()`), refreshed by `_update_exploration_actions()` and on language change
- [x] 1.2 `main.gd`: entrance ring (`_create_entrance_marker()`) and arrow to an entrance outside the map window (`_get_entrance_arrow()`, `_create_entrance_arrow()`) in `_render_map()`
- [x] 1.3 `main.gd`: retreat result with the experience kept and the progress toward the next level (`_format_retreat_summary()`), banked amount read before `commit_dungeon_experience()`
- [x] 1.4 EN/ES strings (`EXPLORE_RETREAT_ENTRANCE_ONLY` reworded; `RESULT_RETREATED_KEPT`, `RESULT_RETREATED_NOTHING_KEPT`, `RESULT_RETREATED_PROGRESS`, `RESULT_RETREATED_LEVEL_READY`)
- [x] 1.5 `tools/playtest_bot.gd` recognises the longer retreat message

## 2. Verification
- [x] 2.1 `tests/verify_retreat_feedback.gd`; `tests/verify_localization.gd` extended; full suite passing
- [ ] 2.2 `openspec validate retreat-feedback` and archive (OpenSpec CLI not installed on this machine)
- [ ] 2.3 Manual check on a phone (English and Spanish)
