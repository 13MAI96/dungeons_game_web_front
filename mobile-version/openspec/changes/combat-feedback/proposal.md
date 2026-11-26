## Why

In a user test, fights gave almost no feedback: one line of jargon such as "Strike was protected" and no numbers. Testers could not tell how much damage they dealt or took, or why an attack failed. Vikunja task DNG-13.

## What Changes

- **Floating damage numbers** over the monster and player portraits when either takes damage ("-3" rising and fading in 0.8 s). A critical floats "Critical! -6". An attack that does no damage floats its outcome word: "Dodged" or "Blocked".
- **Outcome labels** for every attack, limited to the outcomes the rules really have: Hit, Critical!, Dodged and Blocked (the rules' "miss": the roll did not beat the defender's armor). The rules have no separate plain miss, so none is shown.
- **Fight log** above the Fight and Flee buttons with the last 4 attacks of the encounter, oldest at the top and newest at the bottom, each with its outcome tag and a plain sentence with the numbers: "You hit Kobold for 3", "Kobold dodged your Strike", "Bat hit you with Bite for 2". A failed flee is logged too. The log resets when a new encounter starts.
- **Plain-language text:** the `COMBAT_FEEDBACK_*` keys (including the jargon `*_PROTECTED` ones) are removed and replaced by `COMBAT_OUTCOME_*` and `COMBAT_LOG_*`. The rules message keys (`COMBAT_HIT`, `COMBAT_CRITICAL_HIT`, `COMBAT_MISS`, `COMBAT_DODGED`, `COMBAT_COUNTERATTACK_HIT`) get clearer EN/ES text.
- The **damage overlay** shown when the player is hurt says who hurt them and how much (the log line), instead of the generic "The monster hit you".
- The encounter hint line ("Not enough energy or mana to attack...") is only shown when it has text.

Presentation only: combat rules, rolls and balance are unchanged. `CombatRules.attack_monster()` and `attempt_flee()` now also report the damage of each attack (`player_attack_damage`, `counterattack_damage`) so the UI does not recompute it.

## Capabilities

### Modified Capabilities
- `monster-encounter`: combat outcomes are explained by a fight log with numbers and floating damage numbers; new requirements for both; localization covers them.
- `d20-roll-visualization`: the readable feedback that replaces raw rolls is the fight log and the floating numbers.

## Impact

New `scripts/combat_feedback.gd` (result to entries), `scripts/fight_log.gd` (log widget), `scripts/damage_numbers.gd` (floating numbers layer). `scripts/main.gd` (wiring in `_fight()`, `_flee_encounter()`, `_show_monster_encounter()`), `scripts/combat_rules.gd` (two reported fields), `localization/menu.en.po`, `localization/menu.es.po`. Tests: new `tests/verify_combat_feedback.gd`; `verify_monster_encounter_transition.gd`, `verify_localization.gd` and `verify_ui_shell.gd` updated to the new texts. No save-format change.
