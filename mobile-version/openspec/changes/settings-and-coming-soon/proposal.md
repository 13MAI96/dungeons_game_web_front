## Why

The main menu exposes Settings without behavior, while the game hub exposes Challenge Dungeon and Shop before those game modes exist. A playable build should avoid controls that appear broken and should let players override the automatically detected language.

## What Changes

- Add a Settings view with persistent English and Spanish selection.
- Apply language changes immediately throughout the current UI.
- Mark Challenge Dungeon and Shop as Coming Soon.
- Disable unavailable actions so they cannot appear to fail silently.

## Capabilities

### New Capabilities
- `game-settings`: Defines persistent language selection from the main menu.

### Modified Capabilities
- `localized-main-menu`: Make the visible Settings action functional.
- `new-game-view`: Clearly identify unavailable Challenge Dungeon and Shop actions.

## Impact

- `scripts/settings_store.gd` stores application settings independently from player saves.
- `scripts/main.gd` builds and controls the Settings view.
- English and Spanish localization catalogs include Settings and Coming Soon labels.
- Headless tests cover settings persistence and unavailable action state.
