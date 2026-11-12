## Context

The mobile version currently uses Godot labels and panels as placeholders for player art, monster art, stat rows, map contents, and combat feedback. The web front reference already establishes an icon language for stats and dungeon content:
- `player-component` renders stat counters with icons and progress bars.
- Energy uses the lightning icon, life uses hearts, armor uses shield, and damage uses bomb explosion.
- Dungeon special locations use sword for monsters, scroll for quests, and heart tower for sanctuaries.
- Quest locations expose a `Collect Treasure` action rather than resolving only as passive map color.

The mobile project is still a single Godot scene with GDScript helpers. This change should improve visual clarity without introducing a broader scene architecture.

## Goals / Non-Goals

**Goals:**
- Add concrete player and monster visual assets instead of text placeholders.
- Port the web stat icon language into reusable Godot stat bars.
- Display player life, energy, and mana during dungeon exploration.
- Display monster/player stats consistently across new-game and encounter views.
- Show special location icons on the map and expose quest resolution as an explicit action.
- Add a short damage feedback overlay using the bomb explosion asset.

**Non-Goals:**
- Final production art direction for every character or monster.
- Inventory/equipment UI redesign.
- Full animation system, particle effects, or sound.
- Changing combat formulas or dungeon generation rules.
- Backend asset loading.

## Decisions

1. Store assets under `res://assets`.

   Use Godot-importable SVG/PNG files under a local `assets` folder. Existing web SVGs can be copied or adapted where they are already available, and player/monster images can be generated as simple transparent-background PNGs or SVGs. Keeping them local avoids runtime network dependencies.

2. Build a reusable stat bar component with Godot controls.

   Implement stat rows as composed nodes or helper-generated controls: icon, bar fill, optional depleted/remaining background, and centered value text. This preserves the web reference while staying native to Godot. Using raw labels only was considered, but it does not meet the icon/bar requirement.

3. Use the same stat bar format in new-game, exploration, and encounter surfaces.

   The start-game/new-game view remains the source visual pattern. Exploration uses a compact subset: life, energy, and mana. Encounter views use the same format for player and monster stats so both sides are readable and consistent.

4. Render special map icons inside cells.

   The web front maps location type to icons through `getImg()`, so the mobile map should show icons on visible special cells. Quest locations should keep an explicit lower action when current and unresolved; sanctuary can resolve on entry because current combat rules already define immediate recovery.

5. Damage feedback is an overlay, not a route change.

   Add a full-screen overlay above the current view, briefly darken the screen, show the bomb explosion asset centered, and place result text near the bottom. This keeps the user in context and can be triggered from combat or trap outcomes.

## Risks / Trade-offs

- Generated images may not match final game style. -> Use simple transparent assets and keep asset filenames/mappings stable for later replacement.
- Godot SVG rendering/import can vary by asset complexity. -> Prefer simple SVGs for icons and PNGs for generated character/monster illustrations if import fidelity is uncertain.
- Bars with embedded values can become cramped on mobile. -> Use compact current/max text only where meaningful and keep icon sizing fixed.
- Map cells can become visually busy with icons and colors. -> Show icons only for visible special cells and keep current/visited highlighting dominant.
