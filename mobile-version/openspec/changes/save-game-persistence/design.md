## Context

The game uses a runtime player dictionary and intentionally treats dungeon experience as provisional until a dungeon is completed. Saving the entire scene or an active dungeon would preserve temporary combat state and make migrations harder.

## Goals / Non-Goals

**Goals:**
- Persist character progression and permanent death consequences locally.
- Reject missing, malformed, or unsupported saves safely.
- Keep the existing offline game loop independent from the backend.

**Non-Goals:**
- Resume a dungeon or encounter in progress.
- Provide multiple save slots or cloud synchronization.
- Encrypt or prevent manual modification of save data.

## Decisions

1. Store a versioned JSON document under `user://`.

   JSON keeps the current dictionary model easy to inspect and migrate. A version field prevents silently accepting incompatible future formats.

2. Write to a temporary file before replacing the active save.

   This reduces the chance of leaving truncated JSON when a write is interrupted.

3. Merge loaded data into current defaults.

   Only known player keys with compatible types are restored. New fields therefore receive current defaults, while unknown fields are ignored.

4. Save only at stable checkpoints.

   New game creation, progression confirmation, class selection, successful retreat, dungeon completion, and forced dungeon exits are checkpoints. Active dungeon layout, monster health, and provisional dungeon experience are not persisted.

5. Physically remove invalidated saves.

   When death rules mark a save deleted, the file is removed, Load Game is disabled, and the app returns to the main menu after showing the existing feedback.

## Risks / Trade-offs

- An app terminated during a dungeon resumes from the last stable checkpoint rather than mid-dungeon.
- JSON is user-editable; tamper resistance is deferred.
- Removing a save after terminal death is irreversible by design.
