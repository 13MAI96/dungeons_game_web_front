## Why

The mobile prototype is functionally navigable, but the UI still uses text placeholders for character art, monsters, stat presentation, and damage feedback. This change upgrades those surfaces so exploration and encounters are easier to read and closer to the existing web front reference.

## What Changes

- Add a generated character portrait asset to the start-game/new-game character image slot.
- Replace stat text labels with icon-based stat rows inspired by the web `player-component`.
- Render stat values inside bars, including current/maximum values where the stat has a depleted/current state.
- Reuse or port web-front stat and location icons such as life, armor, damage, energy, monster, quest, sanctuary, and bomb explosion.
- Show life, energy, and mana bars in the dungeon exploration view.
- Show special location icons on the dungeon map:
  - Monster locations use the sword/monster indicator.
  - Quest locations use the scroll indicator.
  - Sanctuary locations use the heart tower indicator.
- Preserve special location behavior: sanctuary resolves on entry, while quest locations expose an extra action to resolve/collect treasure.
- Add generated monster image assets for monster templates and show them in encounters.
- Make encounter player and monster stat displays use the same compact stat-bar format as the start-game view.
- Add a damage feedback animation: briefly darken the screen and show the bomb-explosion asset over the scene with feedback text near the bottom.

## Capabilities

### New Capabilities
- `visual-assets`: Defines generated/imported UI assets for player portrait, monster images, stat icons, location icons, and damage feedback overlays.

### Modified Capabilities
- `new-game-view`: Character image and player stat presentation change from placeholder/labels to asset and icon-bar UI.
- `dungeon-exploration`: Exploration gains player status bars, special map icons, and quest extra action behavior.
- `monster-encounter`: Encounter images, stat presentation, and damage feedback behavior change.

## Impact

- Godot scene updates in `res://scenes/main.tscn`.
- New or ported assets under `res://assets`.
- GDScript UI helpers in `res://scripts`, likely for stat bar construction, asset mapping, and damage feedback.
- Localization updates for any new quest action or feedback text.
- Headless Godot verification for node structure and behavior; visual checks where practical for generated assets and overlay visibility.
