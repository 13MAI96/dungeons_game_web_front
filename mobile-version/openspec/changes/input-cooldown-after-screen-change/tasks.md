## 1. Implementation
- [x] 1.1 `SCREEN_CHANGE_INPUT_COOLDOWN_MSEC` constant and `_start_input_cooldown()` / `is_input_cooldown_active()`
- [x] 1.2 Connect `visibility_changed` of every screen, modal and overlay to the cooldown (`_watch_screen_changes_for_input_cooldown()`)
- [x] 1.3 `_input()` swallows screen touches and mouse buttons during the cooldown

## 2. Verification
- [x] 2.1 `tests/verify_input_cooldown.gd`: tap after a won fight does not press Continue or move the hero; double tap on Level Up Confirm does not press Exit; taps after the cooldown work; direct calls are not blocked
- [x] 2.2 Full suite passing, playtest bot unaffected (`tests/verify_balance.gd`)
- [ ] 2.3 `openspec validate input-cooldown-after-screen-change` and archive (OpenSpec CLI not installed on this machine)
- [ ] 2.4 Manual check on the Android emulator (double tap on Fight and on Level Up Confirm)
