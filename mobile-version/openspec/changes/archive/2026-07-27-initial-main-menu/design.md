## Context

The project currently has a minimal Godot 4 mobile shell with a main scene and one GDScript file. This change turns that shell into a functional first screen: a localized main menu that can be opened on mobile and later extended with gameplay, save loading, and settings flows.

## Goals / Non-Goals

**Goals:**
- Make `res://scenes/main.tscn` the initial main menu screen.
- Keep the upper screen area visually open for a future logo.
- Place the three menu actions as a centered vertical list near the lower portion of the viewport.
- Resolve menu labels from the device language, using Spanish only when the device language is Spanish and English otherwise.
- Keep implementation simple and local to scenes, scripts, and localization resources.

**Non-Goals:**
- Implementing game start, save loading, or settings behavior beyond visible menu entries.
- Designing or adding the future logo.
- Adding non-English/non-Spanish localization.
- Building persistence, save-game discovery, or settings screens.

## Decisions

1. Use a single Control-based main scene for the menu.

   The menu is UI-only and needs to adapt to mobile viewport sizes, so a `Control` root with anchors and containers is appropriate. A Node2D scene was considered, but it would require more manual layout work for responsive UI.

2. Use Godot translation resources for menu labels.

   The menu text should follow the device language, and Godot already provides translation lookup through `tr()`. Hard-coded branching in the scene script was considered, but translation resources keep future text additions centralized and easier to expand.

3. Normalize locale selection to Spanish or English at startup.

   The app only supports Spanish and English for this change. If `OS.get_locale_language()` returns `es`, the locale will be set to Spanish; every other value will use English. This makes fallback behavior explicit and testable.

4. Leave menu actions inert except for focus/press wiring readiness.

   The user-visible requirement is reaching the main menu with three options. The buttons can exist as real interactive controls, but navigation or gameplay actions belong to later changes.

## Risks / Trade-offs

- Locale behavior can vary by platform and simulator settings -> Mitigation: base selection on Godot's language code and keep the fallback rule simple.
- Mobile viewport sizes vary significantly -> Mitigation: use anchors/containers and avoid absolute placement for the core menu list.
- Godot translation import metadata can be easy to miss -> Mitigation: include localization resources and generated import/UID files in version control when produced by the editor.
