## 1. Balance
- [x] 1.1 Baseline playtest of the current rule (`tools/playtest.gd -- runs=40 games=6 seed=1`)
- [x] 1.2 Playtest three candidates with the same seed and compare completed / died / energy-out rates
- [x] 1.3 Pick fixed 30 % life and 20 % energy; record the table in design.md

## 2. Implementation
- [x] 2.1 `CombatRules`: `REST_LIFE_PERCENT` / `REST_ENERGY_PERCENT`, `get_rest_block_reason()`, `rest()` reports the real gains
- [x] 2.2 `main.gd`: "Rest · 5 mana" label, result line with numbers, disabled Rest with a reason, `explore_message` cleared on move
- [x] 2.3 Tutorial Rest page uses the fixed percentages
- [x] 2.4 EN/ES strings (`EXPLORE_REST_WITH_COST`, `EXPLORE_REST_RESULT`, `EXPLORE_REST_NEEDS_MANA`, `EXPLORE_REST_NOT_NEEDED`, `TUTORIAL_REST_BODY`)

## 3. Verification
- [x] 3.1 `tests/verify_rest.gd`; `verify_combat_rules.gd`, `verify_location_effects.gd`, `verify_first_run_tutorial.gd`, `verify_localization.gd` updated; full suite passing
- [ ] 3.2 `openspec validate rest-rework` and archive (OpenSpec CLI not installed on this machine)
- [ ] 3.3 Manual check on the Android emulator or a phone (English and Spanish)
