## 1. Main Menu Scene

- [x] 1.1 Update `res://scenes/main.tscn` so it is a Control-based main menu screen with a dark brown-black full-screen background.
- [x] 1.2 Add an upper reserved layout area for a future logo without displaying menu options there.
- [x] 1.3 Add a centered lower vertical list with three button controls for start game, load game, and settings.

## 2. Localization

- [x] 2.1 Add English and Spanish translation resources for the three menu labels.
- [x] 2.2 Register translation resources in `project.godot`.
- [x] 2.3 Update `res://scripts/main.gd` to select Spanish only when `OS.get_locale_language()` is `es`, and English otherwise.
- [x] 2.4 Apply translated labels to the three menu buttons using Godot translation keys.

## 3. Verification

- [x] 3.1 Validate the project opens headlessly with Godot.
- [x] 3.2 Verify the menu scene contains the three required options and the lower-centered layout structure.
- [x] 3.3 Verify English fallback and Spanish locale behavior from the script/resource setup.
