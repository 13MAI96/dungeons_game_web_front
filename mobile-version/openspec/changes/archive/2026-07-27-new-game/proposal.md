## Why

The app needs the first real navigation step after the main menu so a new player can enter a functional game shell. This change establishes the in-game hub view where character status and core player actions will live before dungeon, inventory, shop, and exit behavior are implemented.

## What Changes

- Make the main menu start-game option navigate to a new game view.
- Add a new game view that keeps the existing dark background.
- Split the upper portion of the new game view into two columns:
  - Left column reserved for a future character image.
  - Right column showing current character statistics.
- Base the visible statistics on the existing web `player-component` reference: energy, life, mana, armor, damage, reputation, and experience.
- Add a lower centered action list with five options: Explore Dungeon, Challenge Dungeon, Manage Equipment, Shop, and Exit.
- Preserve Spanish/English localization expectations for the new action labels.

## Capabilities

### New Capabilities
- `new-game-view`: Defines the post-start-game view, character summary layout, visible player stats, and lower action menu.

### Modified Capabilities
- `localized-main-menu`: The start-game option now navigates from the main menu to the new game view.

## Impact

- Godot scene structure under `res://scenes`.
- GDScript navigation and view state under `res://scripts`.
- Localization resources for the new action labels.
- Potential new GDScript player data model or view model mirroring the web `Player` visible/current stat fields.
