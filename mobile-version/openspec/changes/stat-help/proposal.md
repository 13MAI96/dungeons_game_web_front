## Why

The stat bars are icon-only and tapping or holding them does nothing. Players cannot tell armor from strength or speed, or what each stat does. The Level Up screen asks them to spend points without explaining what a point buys. Vikunja task DNG-7.

## What Changes

- **Tap a stat bar to see its name and a short description.** This works on the hub, the exploration HUD, the Level Up screen and the fight panel (player and monster). A tap anywhere, Android back or a screen change closes it.
- One reusable helper, `scripts/stat_help.gd`. It holds a single popup instance plus the stat name and description texts. `main.gd` wires every bar to it in `_create_stat_bar()`, so all screens share one implementation.
- Descriptions use the game's stat names (Life, Energy, Mana, Armor, Strength, Speed, Reputation, Total XP, Dungeon XP). They state the real rule numbers from `CombatRules` (energy per step and per fight round, Rest mana cost, Strength damage baseline, points per level).
- **Level Up stat guide.** A "What each stat does" card in the Level Up screen's empty area. For each allocatable stat it shows the name, the gain per point for the player's class (`+N per point`) and the shared description.
- New EN/ES strings: `STAT_<NAME>`, `STAT_<NAME>_HELP`, `STAT_HELP_CLOSE_HINT`, `LEVEL_ALLOCATION_GUIDE_TITLE`, `LEVEL_ALLOCATION_GUIDE_GROWTH`.

## Capabilities

### Modified Capabilities
- `app-shell`: stat bars explain themselves on tap on every screen.
- `level-up-allocation`: the Level Up screen lists what each stat does and its gain per point.

## Impact

New `scripts/stat_help.gd`. Changes to `scripts/main.gd`, `localization/menu.en.po`, `localization/menu.es.po`. New `tests/verify_stat_help.gd`. No rule or save change.
