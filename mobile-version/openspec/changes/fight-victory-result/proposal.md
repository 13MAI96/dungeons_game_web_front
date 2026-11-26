## Why

A won fight ends straight on the map. The only feedback is a 0.8 s "You gained N experience" flash that is easy to miss, so testers did not know they had won, what they had beaten or what it gave them. Vikunja task DNG-10.

## What Changes

- A **fight victory result** after a won fight that does not end the run: the experience icon, "Victory!", the defeated monster's translated name, the dungeon experience gained, the run's provisional total with how to keep it, and a Continue button back to the map. It replaces the short experience flash after a kill.
- **Last monster:** the dungeon completion result names the defeated monster above the completion rewards. No separate victory result is shown, so two results never stack.
- **Last energy:** a kill that spends the last energy (other monsters left) ends the run as today; only the depletion result is shown.
- **Low-energy warning:** a warning raised by the winning blow waits until Continue on the victory result, then appears.
- System back on the victory result acts like Continue.
- Monster names are translated through `MONSTER_NAME_<NAME>` keys (falls back to the data name).
- New EN/ES strings: `FIGHT_VICTORY_TITLE`, `FIGHT_VICTORY_DEFEATED`, `FIGHT_VICTORY_EXPERIENCE`, `FIGHT_VICTORY_RUN_TOTAL` and `MONSTER_NAME_*` for every monster in `data/monsters.json`.

Rules are unchanged: the experience is still provisional until completion or retreat.

## Capabilities

### Modified Capabilities
- `monster-encounter`: a monster defeat shows the victory result instead of the experience overlay; new requirement for the victory result and how it combines with completion, depletion and the low-energy warning.

## Impact

`scripts/main.gd`, `localization/menu.en.po`, `localization/menu.es.po`, `tools/playtest_bot.gd` (presses Continue on the victory result), `tests/verify_monster_encounter_transition.gd` (expects the victory result). `_finish_depleted_dungeon_exit()` also gets a run-once guard (see design), new `tests/verify_fight_victory.gd`. No save-format change.
