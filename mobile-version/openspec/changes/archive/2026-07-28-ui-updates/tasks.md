## 1. Asset Setup

- [x] 1.1 Create `res://assets` subfolders for icons, characters, monsters, and feedback visuals.
- [x] 1.2 Port or adapt web-front SVG icons for life, energy, mana, armor, damage, reputation, experience, monster, quest, sanctuary, and bomb explosion.
- [x] 1.3 Generate or create a local player character portrait asset for the new-game view.
- [x] 1.4 Generate or create local monster image assets for every monster template in `DungeonGenerator.MONSTER_TEMPLATES`.
- [x] 1.5 Add fallback character/monster assets for missing specific mappings.
- [x] 1.6 Replace stat and special-location icons with the SVG assets from the existing web front.
- [x] 1.7 Update the player portrait to show a full-body person.

## 2. Reusable Stat Bar UI

- [x] 2.1 Add a reusable GDScript helper or scene pattern for icon-based stat bars.
- [x] 2.2 Render stat icons instead of text labels.
- [x] 2.3 Render current values inside each stat bar.
- [x] 2.4 Render current/maximum text and remaining-bar contrast for stats with current/max values.
- [x] 2.5 Apply stable sizing so stat bars do not shift or overflow on mobile viewports.
- [x] 2.6 Reduce stat bar widths so they stay inside the mobile viewport.
- [x] 2.7 Apply stat-specific colors to icons and filled bars while leaving missing bar segments dark.
- [x] 2.8 Match stat colors exactly to the existing web-front `player-component`.

## 3. New Game View Updates

- [x] 3.1 Replace the character placeholder label with the generated character portrait asset.
- [x] 3.2 Replace new-game player stat rows with reusable icon stat bars.
- [x] 3.3 Ensure energy, life, mana, armor, damage, reputation, and experience remain visible.
- [x] 3.4 Validate the new-game layout keeps action buttons centered below the character summary.

## 4. Exploration UI Updates

- [x] 4.1 Add compact player life, energy, and mana stat bars to the dungeon exploration view.
- [x] 4.2 Render monster, quest, and sanctuary icons inside visible special map cells.
- [x] 4.3 Keep current-location, visited-location, and blocked-location visual states readable with icons present.
- [x] 4.4 Add a collect-treasure action that appears only on unresolved current `QUEST` locations.
- [x] 4.5 Move quest resolution from automatic entry behavior to the collect-treasure action.
- [x] 4.6 Preserve sanctuary recovery on entry.
- [x] 4.7 Limit the map viewport to 5 columns by 7 rows and recenter it around the player when moving.

## 5. Encounter UI Updates

- [x] 5.1 Replace monster text image placeholders with monster image assets.
- [x] 5.2 Map each generated dungeon monster template to its corresponding local monster asset.
- [x] 5.3 Replace monster stats with reusable icon stat bars.
- [x] 5.4 Replace encounter player stats with reusable icon stat bars.
- [x] 5.5 Keep fight and flee actions in the lower encounter action area.
- [x] 5.6 Preserve monster maximum life so damaged monster life bars show remaining life over the original total.
- [x] 5.7 Cross encounter rows diagonally: rival stats left with image right, player image left with stats right.
- [x] 5.8 Keep encounter player stat order aligned with the main player stat order, starting with life.

## 6. Damage Feedback

- [x] 6.1 Add a full-screen damage feedback overlay above all current views.
- [x] 6.2 Darken the screen briefly when the player receives damage.
- [x] 6.3 Show the bomb explosion visual centered over the overlay.
- [x] 6.4 Show damage/result text near the bottom of the overlay.
- [x] 6.5 Trigger the overlay from combat damage and quest trap damage without changing view state unless the dungeon run ends.
- [x] 6.6 Show monster-defeat experience as an overlay with the underhand asset before returning attention to the map.
- [x] 6.7 Color the damage and experience feedback SVGs so they remain visible over the darkened overlay.

## 7. Localization

- [x] 7.1 Add English and Spanish labels for collect treasure.
- [x] 7.2 Reuse existing combat feedback translations where possible.
- [x] 7.3 Add missing English and Spanish feedback text for the damage overlay if needed.

## 8. Verification

- [x] 8.1 Add headless verification that required asset files exist and are mapped.
- [x] 8.2 Update new-game navigation tests to verify portrait and icon stat bars exist.
- [x] 8.3 Update dungeon movement/location tests to verify special map icons and collect-treasure action behavior.
- [x] 8.4 Update encounter tests to verify monster image assets and stat bars exist.
- [x] 8.5 Add a headless test for damage overlay visibility after player damage.
- [x] 8.6 Validate the project opens headlessly with Godot.
- [x] 8.7 Validate the `ui-updates` OpenSpec change.
- [x] 8.8 Add a headless test for 5 by 7 map viewport centering and edge behavior.
- [x] 8.9 Verify colored stat bar styling and damaged monster life current/maximum display.
- [x] 8.10 Verify exact web-front stat colors and encounter diagonal layout.
