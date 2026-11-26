## Why

User test 2026-11-26 (Vikunja task DNG-15): the player could not tell where the 5 starting points came from, and nothing said that a class is chosen at level 10 (the class choice only appears once the player is level 10). The early game gave no hint about how progression works.

## What Changes

- **Level Up hints.** Under the remaining points, Level Up shows short captions:
  - at level 1: "You start with 5 points to spend. Each new level gives 3 more."
  - from level 2: "Each new level gives 3 points to spend."
  - before level 10: "At level 10 you choose a class."
  At level 10 the class hint is replaced by the class choice itself. Once a class is chosen, both hints are hidden.
- **Hub hint.** A caption under the hub's "Level N":
  - level 1 with unspent points: "You start with 5 points to spend in Progression."
  - otherwise before level 10: "At level 10 you choose a class."
  - level 10 or more without a class: "Choose your class in Progression."
  - hidden once a class is chosen.
- The numbers come from `CombatRules.INITIAL_PROGRESSION_POINTS`, `CombatRules.LEVEL_UP_POINTS` and the new `CombatRules.CLASS_CHOICE_LEVEL` (10, now also used by `select_player_class()` and the class choice view instead of a literal `10`).
- New EN/ES strings: `LEVEL_HINT_START_POINTS`, `LEVEL_HINT_LEVEL_POINTS`, `LEVEL_HINT_CLASS_UNLOCK`, `HUB_HINT_START_POINTS`, `HUB_HINT_CLASS_READY`.

Progression pacing and Strength dominance were measured in the same ticket. The results and tuning recommendations are in `docs/progression-check-2026-11-26.md`. They are follow-up items, not part of this change.

## Capabilities

### Modified Capabilities
- `level-up-allocation`: Level Up explains the starting points, the points per level and the class unlock level.
- `new-game-view`: the hub shows a progression hint under the player level.

## Impact

`scripts/combat_rules.gd` (constant only, same value), `scripts/main.gd`, `localization/menu.en.po`, `localization/menu.es.po`, new `tests/verify_progression_hints.gd`, `tests/verify_localization.gd` (also captures Level Up at level 1). No rule, balance or save-format change.
