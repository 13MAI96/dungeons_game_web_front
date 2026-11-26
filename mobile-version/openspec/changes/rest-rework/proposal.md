## Why

In a user test, Rest felt useless: it gave +1 life and +4 energy and showed no numbers, only "You rested". The rule restored a random 5–25 % of maximum energy and 10–40 % of maximum life for 5 mana, so a level-1 hero (10 life, 12 mana) got 1 to 4 life, twice per run. The button did not say what it cost, and when mana ran out it stayed enabled and did nothing. Rest messages also stayed on screen after moving. Vikunja task DNG-16.

## What Changes

- **Fixed recovery:** Rest restores a fixed 30 % of maximum life and 20 % of maximum energy for 5 mana (a level-1 hero: +3 life, +5 energy). No random roll. The values were picked by comparing three candidates with the balance bot against the current rule (see design.md).
- **Cost on the button:** "Rest · 5 mana" / "Descansar · 5 maná".
- **Result with the real numbers:** after resting, the exploration feedback line shows the points really gained and spent: "+3 life, +5 energy, −5 mana" / "+3 de vida, +5 de energía, −5 de maná". Gains are capped at the maximum, and the line says what was really added.
- **Messages clear on the next move:** every exploration message (rest result, sanctuary, treasure, "retreat only from the entrance") disappears when the player moves again.
- **Disabled with a reason:** Rest is disabled when it cannot be used, and the feedback line says why, like Fight does for an unaffordable attack:
  - less than 5 mana: "Rest needs 5 mana." / "Para descansar necesitás 5 de maná.";
  - life and energy already full: "Life and energy are full." / "Tenés la vida y la energía al máximo." (resting would only waste mana).
  - During a monster encounter Rest stays out of reach (it lives on the exploration screen) and `_rest()` does nothing.
- The how-to-play Rest page shows the new fixed percentages from the rule constants.

## Capabilities

### Modified Capabilities
- `combat-rules`: rest restores fixed percentages and is refused at full life and energy.
- `dungeon-exploration`: the Rest button shows its cost, is disabled with a reason, the rest result shows numbers, and exploration messages clear on the next move.

## Impact

`scripts/combat_rules.gd` (`REST_LIFE_PERCENT`, `REST_ENERGY_PERCENT` replace the `REST_*_PERCENT_MIN/MAX` range; new `get_rest_block_reason()`; `rest()` reports `life_restored`, `energy_restored`, `mana_spent` and no longer takes percentage arguments), `scripts/main.gd` (Rest label, result, block reason, `explore_message` cleared on move), `scripts/tutorial.gd`, `localization/menu.en.po`, `localization/menu.es.po`. Tests: new `tests/verify_rest.gd`; `verify_combat_rules.gd`, `verify_location_effects.gd`, `verify_first_run_tutorial.gd` and `verify_localization.gd` updated. No save-format change.
