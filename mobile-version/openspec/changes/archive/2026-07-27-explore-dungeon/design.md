## Context

The mobile app now has a main menu and a new game hub. The next gameplay step is the "Explore Dungeon" flow. The backend reference generates a dungeon as a grid of `Location` records with random dimensions based on `dungeon_type`, a random entrance on an edge, and contents selected from monsters plus progressively introduced quest/block/sanctuary options.

The web dungeon component renders the dungeon as rows and columns, starts at the entrance, reveals neighboring cells, treats orthogonal adjacent cells as visitable, blocks `BLOCK` locations, and emits the current location. The web game component switches to monster-related actions when the current unvisited location is a living monster.

## Goals / Non-Goals

**Goals:**
- Make "Explore Dungeon" open an exploration view.
- Generate a local dungeon map using the same rules and location types as `dungeons_back`.
- Show the generated map in the upper portion of the screen.
- Let the player move with four fixed directional arrow buttons, disabling invalid directions.
- Allow returning to the immediately previous location.
- Provide Rest and Retreat actions during exploration.
- Switch to a monster encounter view when entering a living monster location.
- Show monster image/details and player characteristics while the monster is alive.
- Show attack actions and flee during the monster encounter.

**Non-Goals:**
- Persisting dungeon state across app restarts.
- Fetching dungeons from the backend API.
- Implementing all quest, block, sanctuary, trap, or trader gameplay outcomes beyond generation/display constraints.
- Final combat balancing or a full skill system.
- Final art direction for maps or monsters.

## Decisions

1. Port dungeon generation rules into a local GDScript service.

   The user asked for the map to be generated with the rules used by `dungeons_back`. A local service keeps the mobile prototype functional without network setup and makes the generator directly testable. Calling the backend was considered, but it would add API availability and offline concerns before the mobile project has a persistence/network layer.

2. Represent dungeon data with lightweight dictionaries or resource-like GDScript classes.

   The backend models are simple shapes: dungeon dimensions, locations, location type, and content. GDScript dictionaries/classes can mirror those fields without adding a heavy serialization layer. The implementation should preserve backend field names where practical: `number_of_columns`, `number_of_rows`, `locations`, `q_locations`, `column`, `row`, `type`, and `content`.

3. Use a single scene with additional top-level views for this change.

   The existing app already uses top-level view containers in `main.tscn`. Adding `DungeonExploreView` and `MonsterEncounterView` keeps navigation consistent for this iteration. A scene stack can be introduced later if the number of views grows.

4. Keep movement explicit through action buttons, not direct map taps.

   The requested mobile control surface is directional arrows plus action buttons. The map should visualize position and discovered/available cells, while movement occurs through buttons to avoid accidental taps.

5. Treat an unvisited monster location as encounter-locked.

   When the player enters a living monster location, exploration movement is paused and the encounter view is shown. Attack actions and flee are the only lower actions until the monster is defeated or the player flees. Defeated monster locations are marked visited and do not reopen encounters.

## Risks / Trade-offs

- Backend generation has rough edges such as an unused `exit_location` list -> Mitigation: mirror observable generated fields and contents, but do not add exit behavior in this change.
- Large generated maps can exceed mobile screen space -> Mitigation: render a compact scaled grid in a fixed upper container and keep movement controls separate.
- "Available attacks" are not fully defined yet -> Mitigation: start with a small explicit attack set based on current player damage/energy and keep it extensible.
- Fixed direction buttons can imply unavailable movement -> Mitigation: keep all four visible and disable invalid directions instead of hiding them.
