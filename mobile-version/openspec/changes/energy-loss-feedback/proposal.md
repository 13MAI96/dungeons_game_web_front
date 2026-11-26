## Why

A user test on 2026-11-26 (two simulated players on Android emulators) showed that running out of energy feels unfair. Energy drops with no warning, the run ends with only "You ran out of energy", and the provisional dungeon experience vanishes without being mentioned. One tester lost 21 XP and never understood why. Vikunja task DNG-4.

## What Changes

- A one-time **low-energy warning** per run when current energy drops to 25% of maximum or below (at least 1). It states the remaining energy and the dungeon experience at risk, and says to go back to the entrance and Retreat to keep it.
- The warning flag is stored in the dungeon dictionary, so it is saved with the active run and a resumed run does not warn again.
- **Depletion results state the experience lost** ("You lost the N dungeon experience earned in this run."), both for energy depletion and for life depletion. The line is omitted when nothing was earned.
- New EN/ES strings: `LOW_ENERGY_TITLE`, `LOW_ENERGY_MESSAGE`, `DUNGEON_EXPERIENCE_LOST`.

Rules are unchanged: depletion still discards the provisional experience.

## Capabilities

### Modified Capabilities
- `dungeon-exploration`: low-energy warning; depletion notifications state the experience lost.

## Impact

`scripts/main.gd`, `localization/menu.en.po`, `localization/menu.es.po`, new `tests/verify_energy_warning.gd`. No save-format change (the flag lives inside the saved dungeon).
