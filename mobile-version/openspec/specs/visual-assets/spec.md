# visual-assets Specification

## Purpose
TBD - created by archiving change ui-updates. Update Purpose after archive.
## Requirements
### Requirement: UI uses local visual assets
The mobile app SHALL use local Godot-importable assets for character, monster, stat, location, and damage feedback visuals.

#### Scenario: Character portrait asset is available
- **WHEN** the new game view is displayed
- **THEN** the character image area shows a local generated full-body character portrait asset

#### Scenario: Monster image assets are available
- **WHEN** a monster encounter is displayed
- **THEN** the encounter shows a local monster image asset matching the active monster template when available
- **THEN** the encounter falls back to a generic monster image asset when a specific monster asset is unavailable

#### Scenario: Stat and location icon assets are available
- **WHEN** stats or special dungeon locations are displayed
- **THEN** the UI uses local icon assets for life, energy, mana, armor, damage, reputation, experience, monster, quest, sanctuary, and damage feedback
- **THEN** location icons use the matching SVG assets from the existing web front when those assets exist

#### Scenario: Experience feedback asset is available
- **WHEN** the player gains experience after defeating a monster
- **THEN** the UI uses the local underhand feedback asset from the existing web front
- **THEN** the underhand asset uses a visible green, blue, or cyan accent color

### Requirement: Damage feedback overlay is animated
The mobile app SHALL show a brief visual feedback overlay when the player receives damage.

#### Scenario: Player receives damage in combat
- **WHEN** combat reduces the player's current life
- **THEN** the current screen briefly darkens
- **THEN** the bomb explosion asset is shown over the screen
- **THEN** the bomb explosion asset uses visible red/orange coloring
- **THEN** damage feedback text is shown near the lower portion of the screen
- **THEN** the overlay disappears without changing the current view unless the dungeon run ends

#### Scenario: Player receives damage from a location effect
- **WHEN** a quest or location effect reduces the player's current life
- **THEN** the damage feedback overlay is shown

