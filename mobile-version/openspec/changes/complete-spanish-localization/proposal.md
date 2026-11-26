## Why

A user test with the Spanish locale (Vikunja task DNG-8) still showed English text: the Level Up screen title "Level Up" and its "Back" button, monster names (Giant Spider, Bat, Wolf, Snake...), "Lv.", attack names in the fight log (Strike, Bite...), and "Monster attacks" / "Close" in the monster attack popup.

Two causes:
- Screens built at runtime (level up, monster attack popup) set their static texts once at start-up, so they kept the start-up language after a language change in Settings.
- Data-driven names from `data/*.json` and the `Lv.` label were shown as raw English strings, never through the translation files.

## What Changes

- **Every visible text goes through the .po files.** Runtime-built screens keep references to their static texts and `_apply_menu_text()` re-translates them on a language change; the D-pad tooltips and the progression tooltip too. Stat bars are rebuilt on a language change.
- **Data-driven names are translated at display time** with `scripts/localized_names.gd`: monsters (`MONSTER_NAME_<NAME>`), monster attacks and player abilities (`ABILITY_NAME_<NAME>`), classes (`CLASS_NAME_<ID>`) and effects (`EFFECT_NAME_<ID>`). Data files and saves keep the English names and ids; a name without a translation falls back to its data name (never a raw key).
- The encounter header uses `ENCOUNTER_MONSTER_NAME_LEVEL` ("%s Lv. %s" / "%s Nv. %s"). Fight-log lines and the monster attack list show translated attack and effect names.
- Scene placeholder texts in `scenes/main.tscn` are translation keys instead of English words.
- New EN/ES strings (Rioplatense voseo, as the existing ones): 40 keys for this change.
- New test `tests/verify_localization.gd` that fails when visible UI text bypasses translation.

## Capabilities

### Modified Capabilities
- `game-settings`: a language change updates every visible text, including runtime-built screens; all visible text, data-driven names included, is translated.
- `monster-encounter`: the monster name, level label, attack names and effect names follow the selected language.
- `monster-progression-rules`: the monster level label is localized.

## Impact

`scripts/main.gd`, new `scripts/localized_names.gd`, `scenes/main.tscn`, `localization/menu.en.po`, `localization/menu.es.po`, new `tests/verify_localization.gd`. No save-format change: saves keep English names and ids.
