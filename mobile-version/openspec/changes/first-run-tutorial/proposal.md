## Why

New players are not told the rules. In the 2026-11-26 user test, players did not know that every step costs energy, that dungeon experience is provisional, or that Retreat only works at the entrance. Vikunja task DNG-6.

## What Changes

- A short, paged **how-to-play tutorial** (6 cards, Next / Skip, Done on the last card) covering:
  the grid and arrows; energy cost per step, per fight round, per flee attempt and per treasure; provisional dungeon XP (kept on completion or Retreat, lost when energy or life run out); Retreat only at the green entrance; Rest (mana cost, energy and life restored); Sanctuary and treasure.
- Every number shown is read from `CombatRules` constants. The hard-coded Rest, Sanctuary and treasure values in `combat_rules.gd` become named constants (`REST_*_PERCENT_*`, `SANCTUARY_PERCENT_*`, `QUEST_SUCCESS_ROLL`). Values are unchanged.
- The tutorial opens automatically on the **first dungeon entry** only, and is marked seen when it is skipped or finished.
- The "tutorial seen" flag lives in the settings file (`SettingsStore`), next to the language. Saving one setting no longer erases the other.
- A **How to play** button in Settings reopens it at any time.
- Android back closes the tutorial (same as Skip).
- New EN/ES strings: `TUTORIAL_*`, `SETTINGS_HOW_TO_PLAY`.

## Capabilities

### Modified Capabilities
- `dungeon-exploration`: the first dungeon entry shows the how-to-play tutorial.
- `game-settings`: Settings can reopen the tutorial, and the tutorial-seen flag is a persisted setting.

## Impact

New `scripts/tutorial.gd`. Changes to `scripts/main.gd`, `scripts/settings_store.gd`, `scripts/combat_rules.gd` (constants only), `tools/playtest_bot.gd` (skips the tutorial), `localization/menu.en.po`, `localization/menu.es.po`. New `tests/verify_first_run_tutorial.gd`. No save-game format change.
