## 1. Combat Rules Service

- [x] 1.1 Add `res://scripts/combat_rules.gd` with pure dictionary-based player and monster rule functions.
- [x] 1.2 Implement player attack energy cost, hit roll, critical hit, normal hit, failed low roll, and monster life mutation.
- [x] 1.3 Implement monster counterattack resolution after non-lethal successful hits.
- [x] 1.4 Implement monster defeat handling with zeroed life, visited location state, and player experience gain.
- [x] 1.5 Add deterministic roll inputs or injectable RNG support for tests.

## 2. Player State

- [x] 2.1 Normalize the mobile player dictionary to include current/max life, energy, mana, armor, damage, experience, level, and vision fields.
- [x] 2.2 Update displayed player stats in new game and encounter views from current player state.
- [x] 2.3 Add helper functions for restoring life/energy, consuming energy, consuming mana, adding experience, and losing life.

## 3. Encounter Integration

- [x] 3.1 Replace placeholder basic/heavy attack behavior with the web-rule fight action.
- [x] 3.2 Update encounter buttons and localization so the available attack action matches the implemented fight rule.
- [x] 3.3 Keep the encounter visible when combat ends with the monster alive.
- [x] 3.4 Return to exploration and mark the location visited when combat defeats the monster.
- [x] 3.5 Preserve flee behavior so fleeing does not mark the monster location visited.

## 4. Exploration Location Effects

- [x] 4.1 Wire Rest to the web recovery rule using current mana, energy, and life.
- [x] 4.2 Apply sanctuary recovery when entering `SANCTUARY` locations and mark them visited.
- [x] 4.3 Apply quest/treasure-style resolution for `QUEST` locations with energy cost, experience success, damage failure, and visited state.
- [x] 4.4 Update map coloring and movement state after special location effects.
- [x] 4.5 Exit the dungeon and reset gained experience when current life or current energy reaches zero.

## 5. Feedback And Localization

- [x] 5.1 Add combat result message keys for hit, critical hit, counterattack hit, miss, experience gained, quest success, quest trap, rest, and insufficient mana.
- [x] 5.2 Surface concise combat and location result feedback in the existing mobile view without adding a new screen.
- [x] 5.3 Add English and Spanish translations for new combat and location feedback.

## 6. Verification

- [x] 6.1 Add headless unit-style tests for combat critical hit, normal hit, failed low roll, counterattack hit/miss, and monster defeat experience.
- [x] 6.2 Update the encounter transition test to assert rule-driven fight behavior and defeated monster persistence.
- [x] 6.3 Add headless exploration tests for rest, sanctuary, and quest outcomes.
- [x] 6.4 Add headless tests for forced dungeon exit when life or energy is depleted.
- [x] 6.5 Validate the project opens headlessly with Godot.
- [x] 6.6 Validate the `combat-rules` OpenSpec change.
