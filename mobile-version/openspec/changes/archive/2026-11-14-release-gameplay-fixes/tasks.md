## 1. Rules
- [x] 1.1 Sanctuary single use per run
- [x] 1.2 Resolve monster defeat / completion before depletion in `_fight`
- [x] 1.3 Disable Fight when the attack cannot be paid, with feedback
- [x] 1.4 Integer class growth (Mage armor) + data test

## 2. Persistence
- [x] 2.1 Atomic save with temp-file recovery and write-error checks; save version 2
- [x] 2.2 Persist active run at each action and on pause/close; resume on Load Game
- [x] 2.3 Confirm Start Game whenever a save file exists

## 3. Navigation and feedback
- [x] 3.1 Android back navigation and quit confirmation
- [x] 3.2 Abandon expedition from exploration
- [x] 3.3 Pending-progression indicator includes convertible level-ups

## 4. Verification
- [x] 4.1 Update tests for new save behaviour; add `tests/verify_release_fixes.gd`
- [x] 4.2 Re-run the play-through bot; all tests pass; code review
