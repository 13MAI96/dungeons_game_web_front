## Decisions

1. **Numbers from the rules, not the texts.** Every hint is a `%s` template filled from `CombatRules`: `INITIAL_PROGRESSION_POINTS` (5), `LEVEL_UP_POINTS` (3) and `CLASS_CHOICE_LEVEL` (10). `CLASS_CHOICE_LEVEL` is new. It replaces the literal `10` in `select_player_class()` and `_rebuild_class_choices()`, so the hint, the lock and the view cannot drift apart. The level-10 ability unlocks in `data/player_abilities.json` stay data.
2. **Where the hints live.** Level Up gets a `ProgressionHints` column (`PointsHint`, `ClassUnlockHint`, `CaptionLabel` style) right under "Remaining points". This is the first place the player sees the 5 points. The hub's `HubHeader` now holds a `Rows` column: `LevelLabel` plus a one-line `ProgressionHint` caption. The red pending dot on Progression is unchanged. It is a 12 px dot without room for text, and its tooltip only shows with a mouse.
3. **When each hint is relevant.**
   - Points hint: at level 1 it explains the starting points and the points per level. From level 2 on it gives only the points per level, since "you start with" no longer applies.
   - Class hint: only below `CLASS_CHOICE_LEVEL`. At that level the class buttons show instead.
   - Hub: the starting-points hint shows only at level 1 while points are unspent. After that the hub shows the class unlock level, or "Choose your class in Progression" from level 10 without a class.
   - With a class chosen, every hint is hidden. The class then owns the progression (its growth and automatic increments), and there is nothing left to unlock.
4. **Refresh.** The Level Up hints are set in `_update_level_allocation_view()`, so they update on open, on a class choice and after staging. The hub hint is set in `_update_hub_header()`, which runs on hub show, on stats refresh and in `_apply_menu_text()`. `_apply_menu_text()` also refreshes the Level Up hints, so a language change re-translates both.
5. **Spanish** uses voseo: "Empezás con…", "elegís", "Elegí tu clase…".
