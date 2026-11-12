## Context

The app already detects Spanish devices and falls back to English, but players cannot override that choice. Challenge Dungeon and Shop are intentionally deferred yet remain visually indistinguishable from working actions.

## Goals / Non-Goals

**Goals:**
- Let the player select English or Spanish.
- Persist the selected locale separately from character data.
- Clearly communicate which hub actions are unavailable.

**Non-Goals:**
- Add audio, graphics, accessibility, or control settings.
- Implement Challenge Dungeon or Shop behavior.

## Decisions

1. Store application settings in `user://settings.cfg`.

   Settings remain available even when a player save is deleted and use Godot's native `ConfigFile` format.

2. Keep automatic locale detection as the default.

   When no preference exists, Spanish devices use Spanish and all other devices use English. A manual choice overrides detection on subsequent launches.

3. Disable deferred actions and include Coming Soon in their labels.

   The actions remain visible as a roadmap cue without behaving like broken buttons.

## Risks / Trade-offs

- Only language is configurable in this release; the settings view will need expansion when audio or accessibility controls are introduced.
- Longer Coming Soon labels require mobile layout verification during device QA.
