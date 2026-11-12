## Why

Player leveling now needs to move beyond fixed three-point upgrades into a broader progression system with data-driven abilities, class-gated unlocks, and accumulated assignable points. Defining these rules now prevents the progression UI, combat actions, and future class behavior from diverging as player builds become more complex.

## What Changes

- Update player experience progression so level 1 requires 100 experience.
- Convert all available level-ups into assignable progression points when the player enters the progression view.
- Allow assignable points to remain reserved if the player leaves the progression view without assigning all of them.
- Replace one-way staged allocation with plus/minus controls that can move points between stats before confirmation.
- Show progression allocation rows using the same stat-bar style as player statistics, with assigned point counts on the right.
- Move player abilities into a dedicated JSON file.
- Add ability metadata for type, active/passive behavior, energy cost, mana cost, unlock level, class requirements, and simple-skill exclusivity.
- Enforce simple ability unlock exclusivity when multiple simple abilities unlock at the same level.
- Add player classes in a dedicated JSON file with class-specific point conversion and automatic stat increment cadence.
- Allow the player to choose a class at level 10.
- Keep player attack and passive effect resolution limited to data availability and unlock state in this change; detailed future ability effects can build on the JSON shape.

## Capabilities

### New Capabilities
- `player-abilities`: Data-driven player active/passive abilities, unlock conditions, class gates, costs, and simple-skill exclusivity.
- `player-classes`: Data-driven player class choices at level 10, class point conversion rules, and automatic stat increment cadence.

### Modified Capabilities
- `player-progression-rules`: Experience threshold baseline, multi-level conversion to points, reserved unassigned points, and class-aware progression.
- `level-up-allocation`: Progression allocation UI changes from fixed 3-point irreversible confirmation to reserve-backed plus/minus allocation with stat bars.
- `new-game-view`: Progression entry behavior must support point conversion, class choice availability, and reserved allocations.

## Impact

- `scripts/combat_rules.gd` for experience threshold, multi-level conversion, reserved progression points, and class-aware progression helpers.
- `scripts/main.gd` for progression UI rows, plus/minus controls, reserved points, class selection, and ability unlock display if needed.
- New data files such as `data/player_abilities.json` and `data/player_classes.json`.
- Localization for progression rows, class choice, ability labels, and point reserve status.
- Headless Godot tests for experience thresholds, multi-level conversion, allocation bounds, ability filtering, class choice, and JSON validation.
