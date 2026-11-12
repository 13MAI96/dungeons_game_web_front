## Why

The mobile app needs an initial functional entry point so the project can move beyond a blank Godot shell. This establishes the first user-visible screen and localization behavior before gameplay systems are introduced.

## What Changes

- Add a main menu screen as the app's initial scene.
- Show three centered menu options near the lower portion of the screen: Start Game, Load Game, and Settings.
- Reserve the upper portion of the screen for a future logo.
- Use a dark background color between brown and black.
- Detect the device language at runtime and show menu text in Spanish when the device language is Spanish; otherwise show English.

## Capabilities

### New Capabilities
- `localized-main-menu`: Defines the initial mobile main menu layout and language-dependent menu labels.

### Modified Capabilities

None.

## Impact

- Godot scene structure under `res://scenes`.
- GDScript menu/localization logic under `res://scripts`.
- Project-level localization resources or settings as needed.
