## Context

`main.gd` had four display lists: `PLAYER_STATS` (hub, and the fight panel player side plus dungeon XP), `EXPLORATION_STATS`, `MONSTER_STATS` (life, mana, armor, speed, strength) and `ALLOCATABLE_STATS` (life, energy, mana, armor, speed, strength; Level Up rows and stat guide). Strength and speed swapped between them.

## Decisions

1. **The order.** life, energy, mana, armor, strength, speed, reputation, experience, dungeon_experience. It matches the hub (the screen players see most) and the stat help texts (`StatHelp.STAT_TEXT_KEYS`), so only Level Up and the monster panel move. Strength before speed also reads as "how hard you hit, then how often you dodge and flee", next to armor.

2. **Single source, derived lists.** `scripts/stat_order.gd` holds `CANONICAL`. A GDScript `const` cannot call a function, so the per-screen constants in `main.gd` declare *which* stats a screen shows (written in canonical order for readability), and the order is always derived at build time with `StatOrder.select(keys)`. Even if a screen list is written in another order later, the screen still follows the canonical order. `ENCOUNTER_PLAYER_STATS` is `PLAYER_STATS + ["dungeon_experience"]`, so the fight panel cannot drift from the hub.

3. **Stat lists are plain keys.** The old `{"name", "key", "label_key"}` dictionaries are replaced by keys. The row name comes from the key (`dungeon_experience` → `DungeonExperienceStatBar`, the same names as before), and the XP text labels come from `STAT_BAR_LABEL_KEYS`. Level Up builds its preview bar with the same function.

4. **Testable from what is on screen.** Stat rows and Level Up guide entries carry their key as `stat_key` meta. `verify_stat_order.gd` opens every screen, reads the keys in child order and checks that each list is in canonical order (`StatOrder.is_canonical()`), that every pair of screens orders their shared stats the same way, and that the Level Up guide matches the rows.

5. **Not changed.** `dungeon_generator.gd` scales monster stats in its own loop order (it draws random numbers, so reordering would change generated dungeons and the balance seeds). `tools/playtest_bot.gd` `ALLOCATION_ORDERS` decide where the bot spends points, not what is displayed. `CombatRules.STAT_GROWTH` is a dictionary used by key.
