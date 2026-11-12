## 1. Dungeon Data And Generation

- [x] 1.1 Add GDScript dungeon/location/content data structures or dictionaries mirroring backend field names.
- [x] 1.2 Add a dungeon generator that creates random dimensions between `5^dungeon_type` and `8^dungeon_type`.
- [x] 1.3 Generate one location per row/column coordinate and set `q_locations` to the generated location count.
- [x] 1.4 Select exactly one entrance from edge locations.
- [x] 1.5 Assign non-entrance contents using the backend location option progression for monsters, quests, blocks, and sanctuaries.

## 2. Exploration View

- [x] 2.1 Wire the new game view explore-dungeon button to open a dungeon exploration view.
- [x] 2.2 Add `DungeonExploreView` to `res://scenes/main.tscn` with the map in the upper portion.
- [x] 2.3 Render the generated dungeon as a square or rectangular grid with current location highlighted.
- [x] 2.4 Add lower directional arrow controls for up, down, left, and right movement.
- [x] 2.5 Size direction buttons as a balanced rectangle with wide up/down and tall left/right buttons.
- [x] 2.6 Disable buttons whose target direction is blocked by map bounds or block locations.
- [x] 2.7 Add Rest and Retreat actions below directional movement.
- [x] 2.8 Paint visited locations grey, including defeated monster locations.
- [x] 2.9 Scale map cells larger when the upper exploration area has available space.

## 3. Movement And Encounter Transition

- [x] 3.1 Track current location and previous location during exploration.
- [x] 3.2 Move only into valid adjacent non-block locations.
- [x] 3.3 Update visible/current map state after movement.
- [x] 3.4 Switch to monster encounter view when the player enters a living monster location.

## 4. Monster Encounter View

- [x] 4.1 Add `MonsterEncounterView` to `res://scenes/main.tscn`.
- [x] 4.2 Show monster image and monster life, armor, mana, and damage while the monster is alive.
- [x] 4.3 Show player combat characteristics while the monster is alive.
- [x] 4.4 Add lower attack buttons and a flee button.
- [x] 4.5 Implement basic attack behavior that can reduce monster life and mark the monster defeated.
- [x] 4.6 Return to dungeon exploration when the monster is defeated or the player flees.
- [x] 4.7 Keep fled monster locations unvisited so returning to them reopens the encounter.

## 5. Localization

- [x] 5.1 Add English and Spanish labels for movement, rest, retreat, attack, and flee actions.
- [x] 5.2 Apply localized labels to exploration and encounter buttons.
- [x] 5.3 Preserve the existing Spanish-only/English-fallback rule.

## 6. Verification

- [x] 6.1 Add a headless generator test for dungeon dimensions, entrance placement, and `q_locations`.
- [x] 6.2 Add a headless movement test for valid directions, disabled blocked direction buttons, and allowed backtracking.
- [x] 6.3 Add a headless encounter test for entering a living monster location, fleeing, returning, and defeating it.
- [x] 6.4 Validate the project opens headlessly with Godot.
- [x] 6.5 Verify OpenSpec artifacts remain complete.
