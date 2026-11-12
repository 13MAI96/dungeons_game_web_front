## Context

The game autosaves permanent progress, but Start Game can replace that save without warning. Dungeon feedback currently uses a short timed overlay, which is easy to miss on mobile.

## Goals / Non-Goals

**Goals:**
- Protect saved progress from accidental replacement.
- Make leaving the game hub an explicit choice.
- Keep final expedition results visible until acknowledged.

**Non-Goals:**
- Add audio or music.
- Add a cinematic end screen.
- Change combat, dungeon generation, rewards, or other balance rules.

## Decisions

1. Use a native confirmation dialog for state-changing navigation.

   A shared dialog provides consistent Confirm and Cancel actions without duplicating modal UI.

2. Require overwrite confirmation only when a valid save exists.

   A first-ever new game still starts immediately.

3. Use a full-screen dismissible result modal for expedition outcomes.

   Completion, safe retreat, energy depletion, survivable defeat, and terminal game over receive localized titles and messages. The modal remains visible until Continue is selected.

## Risks / Trade-offs

- An additional confirmation adds one tap to returning to the main menu.
- Result text must remain concise enough for the mobile viewport.
