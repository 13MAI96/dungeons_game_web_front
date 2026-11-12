## Context

The mobile project currently opens to a localized main menu with three options. The next step is to make the start-game path functional by showing an in-game hub view that previews the player state and presents the next core actions.

The web project reference uses `player-component` to display the player visible/current stats as rows with progress indicators: energy, life, mana, armor, damage, reputation, and experience. The mobile implementation should use those same stat concepts, while keeping the Godot UI simple enough to evolve.

## Goals / Non-Goals

**Goals:**
- Make the main menu start-game button transition to the new game view.
- Keep the existing dark background unchanged for the new view.
- Split the upper section into a two-column character summary area.
- Reserve the left character summary column for future character artwork.
- Display current player stats in the right character summary column using the web `Player` stat set as reference.
- Place five new game actions in a centered lower vertical list.
- Localize the new labels in Spanish and English.

**Non-Goals:**
- Implementing dungeon exploration, dungeon challenge, equipment management, shop, or exit behavior.
- Creating final character artwork.
- Implementing save creation, persistence, or a complete player progression system.
- Replacing the existing main-menu spec or changing load-game/settings behavior.

## Decisions

1. Keep navigation inside the current main scene for now.

   The app only has two lightweight UI states: main menu and new game view. Toggling top-level `Control` containers inside `res://scenes/main.tscn` keeps the flow easy to implement and validate. A separate scene stack was considered, but it would add lifecycle and routing complexity before there are enough views to justify it.

2. Introduce a small GDScript player view model.

   The web `Player` class has more behavior than this view needs. The mobile view should define a compact data shape or dictionary with current/max values for energy, life, mana, armor, damage, reputation, and experience. This preserves the visible contract while avoiding premature porting of all web player logic.

3. Render stats as labeled value rows with progress affordance.

   The web UI uses progress bars and current values. Godot can mirror that with labels plus `ProgressBar` controls or equivalent structured rows. This keeps the mobile UI recognizable and testable without depending on web icons.

4. Add labels to localization resources before wiring buttons.

   The first change established locale selection and `.po` resources. Extending those files keeps localization centralized and allows the new game view to follow the same Spanish-only/English-fallback rule.

## Risks / Trade-offs

- The initial player values are placeholder defaults -> Mitigation: isolate them in a view model so later player creation/persistence can replace them cleanly.
- A single-scene UI can become crowded as more views are added -> Mitigation: keep top-level containers clearly named and revisit separate scenes when the app needs deeper navigation.
- Stat names could drift from the web reference -> Mitigation: use the exact referenced stat concepts: energy, life, mana, armor, damage, reputation, and experience.
