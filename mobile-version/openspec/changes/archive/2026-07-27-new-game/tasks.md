## 1. Navigation

- [x] 1.1 Wire the main menu start-game button to transition from the main menu state to the new game view state.
- [x] 1.2 Keep load-game and settings buttons visible but without adding new behavior in this change.

## 2. New Game View Layout

- [x] 2.1 Add a top-level new game view container to `res://scenes/main.tscn`.
- [x] 2.2 Reuse the existing dark background without introducing a new background theme.
- [x] 2.3 Add an upper two-column character summary layout with a left placeholder area for future character image.
- [x] 2.4 Add a right stats column in the upper layout.
- [x] 2.5 Add a lower centered vertical action list with five buttons.

## 3. Player Stats

- [x] 3.1 Add a compact GDScript player stat view model for energy, life, mana, armor, damage, reputation, and experience.
- [x] 3.2 Render each stat in the new game view with a label, current value, and progress-style affordance where a max value exists.

## 4. Localization

- [x] 4.1 Add English and Spanish translation keys for explore dungeon, challenge dungeon, manage equipment, shop, and exit.
- [x] 4.2 Apply localized labels to the new game action buttons.
- [x] 4.3 Keep the existing Spanish-only/English-fallback locale rule for the new view.

## 5. Verification

- [x] 5.1 Validate the project opens headlessly with Godot.
- [x] 5.2 Verify selecting start game reveals the new game view.
- [x] 5.3 Verify the new game view contains the required upper two-column character summary and lower five-option action list.
- [x] 5.4 Verify the stat list matches the web `player-component` stat set.
- [x] 5.5 Verify English and Spanish labels are represented in localization resources.
