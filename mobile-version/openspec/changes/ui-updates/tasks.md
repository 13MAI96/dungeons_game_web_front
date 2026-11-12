## 1. Progression Indicator

- [x] 1.1 Add a runtime pending-progress indicator to the progression/manage action.
- [x] 1.2 Show the indicator when `reserved_progression_points` is greater than 0.
- [x] 1.3 Hide the indicator when no reserved progression points remain.
- [x] 1.4 Refresh the indicator after progression allocation, dungeon exits, and new game view updates.
- [x] 1.5 Add or update localization for the indicator tooltip or accessible text if text is exposed.

## 2. Combat Feedback

- [x] 2.1 Stop rendering raw D20 roll values below player and monster statistics.
- [x] 2.2 Build player attack feedback for hit, critical hit, protected or blocked, miss, and dodge outcomes.
- [x] 2.3 Build monster counterattack feedback that includes the monster attack name and outcome.
- [x] 2.4 Apply the same feedback style to failed flee counterattacks.
- [x] 2.5 Clear stale combat feedback when entering a new encounter.
- [x] 2.6 Add or update localization strings for combat outcome summaries.

## 3. Dungeon Exit Feedback

- [x] 3.1 Treat retreat from the entrance as an alive exit even when it spends the last current energy point.
- [x] 3.2 Keep the entrance map cell green when visible, visited, or current.
- [x] 3.3 Add an energy depleted notification before returning to the new game view.
- [x] 3.4 Add a life depleted notification before returning to the new game view.
- [x] 3.5 Prevent duplicate depletion notifications for successful last-energy retreat.
- [x] 3.6 Disable or ignore dungeon actions while a delayed exit notification is pending.
- [x] 3.7 Preserve existing experience loss and death sequel rules after the notification.

## 4. Monster Attack Info

- [x] 4.1 Add an information button over or near the monster image during active encounters.
- [x] 4.2 Build a mobile-friendly modal or tooltip listing the active monster's attacks.
- [x] 4.3 Include attack name, damage, mana cost, unlock level, and effect ids when present.
- [x] 4.4 Allow the player to dismiss the attack information and remain in the encounter.
- [x] 4.5 Ensure the info control hides or resets when leaving the encounter.

## 5. Verification

- [x] 5.1 Add or update tests for the pending progression indicator.
- [x] 5.2 Add or update tests for combat summaries replacing raw roll labels.
- [x] 5.3 Add or update tests for the entrance always displaying green.
- [x] 5.4 Add or update tests for last-energy retreat exiting alive.
- [x] 5.5 Add or update tests for energy and life depletion notifications before menu return.
- [x] 5.6 Add or update tests for the monster attack info modal or tooltip.
- [x] 5.7 Add or update tests for configurable critical thresholds, critical damage percent, and rounded-down critical damage.
- [x] 5.8 Add or update tests requiring monster attack critical metadata.
- [x] 5.9 Run Godot headless project load and affected verification scripts.
- [x] 5.10 Run `openspec validate "ui-updates"`.
