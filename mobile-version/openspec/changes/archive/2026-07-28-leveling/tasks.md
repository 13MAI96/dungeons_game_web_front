## 1. Player Progression Rules

- [x] 1.1 Add player runtime fields for pending improvement points, reputation level, and level-up eligibility.
- [x] 1.2 Ensure current experience can exceed the required threshold without being clamped by stat bars or rule helpers.
- [x] 1.3 Add a rule helper that grants 3 pending improvement points when current experience reaches the current level threshold.
- [x] 1.4 Increase player level and recalculate the next experience threshold after level-up acceptance.
- [x] 1.5 Clear any death life sequel restriction when the player levels up.
- [x] 1.6 Add automatic reputation level progression and next-threshold recalculation without gameplay side effects.

## 2. Level-Up Allocation Flow

- [x] 2.1 Add stat growth constants for life +5, energy +5, mana +4, armor +1, speed +1, and strength +1.
- [x] 2.2 Implement staged allocation state for exactly 3 pending level-up points.
- [x] 2.3 Prevent confirmation until all pending points are assigned.
- [x] 2.4 Apply confirmed allocation permanently to player max stats and current stats outside a dungeon run.
- [x] 2.5 Clear pending allocation after confirmation and prevent reassignment.
- [x] 2.6 Add a manage-equipment/progression allocation view reachable from the new game action menu.
- [x] 2.7 Add or update localization for the allocation view, remaining points, confirm action, and any renamed manage-equipment action.

## 3. Monster Level Generation

- [x] 3.1 Add a monster-level selection helper for player levels below 10 using range `max(1, player_level - 5)` through `player_level`.
- [x] 3.2 Add a monster-level selection helper for player levels 10 and above using range `max(1, player_level - 5)` through `player_level + 5`.
- [x] 3.3 Pass player level into monster generation for every dungeon exploration start.
- [x] 3.4 Assign generated monster level before stat scaling.
- [x] 3.5 Apply 2 random stat points per monster level above 1 using the same growth values as player allocation.
- [x] 3.6 Keep generated monster current life and current mana aligned with scaled maximum life and mana.

## 4. Monster Attack Unlocks

- [x] 4.1 Add `unlock_level` to monster attack definitions in `data/monsters.json`.
- [x] 4.2 Treat missing `unlock_level` values as level 1 for backward compatibility.
- [x] 4.3 Filter generated monster attacks to those with `unlock_level <= monster level`.
- [x] 4.4 Ensure every generated monster keeps at least one available attack.

## 5. Verification

- [x] 5.1 Add headless tests for experience overflow and level-up point creation.
- [x] 5.2 Add headless tests for stat allocation values and irreversible confirmation.
- [x] 5.3 Add headless tests for automatic reputation level progression.
- [x] 5.4 Add headless tests for monster level ranges below level 10 and from level 10 onward.
- [x] 5.5 Add headless tests for monster random stat scaling point totals.
- [x] 5.6 Add headless tests for monster attack unlock filtering.
- [x] 5.7 Run Godot headless project load and all affected verification scripts.
- [x] 5.8 Run `openspec validate "leveling"`.
