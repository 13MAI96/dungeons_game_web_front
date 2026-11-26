## Why

Fast second taps land on the screen that has just appeared. After a won fight the next tap hits a move arrow and moves the hero; a double tap on Confirm in Level Up hits Exit on the hub that replaces it. The player never meant either action. Vikunja task DNG-9.

## What Changes

- A short **input cooldown** (`SCREEN_CHANGE_INPUT_COOLDOWN_MSEC = 300`) starts whenever a screen, modal or overlay is shown or hidden. During it, taps (screen touches and mouse buttons, press and release) are swallowed before any button sees them.
- The cooldown is central: `main.gd` connects the `visibility_changed` signal of every screen, modal and overlay to one helper, and `_input` drops taps while it is active. No button is patched individually.
- Only real input events are gated. Code that calls the action methods directly (tests, `tools/playtest_bot.gd`) is never delayed.

## Capabilities

### Modified Capabilities
- `app-shell`: taps right after a screen, modal or overlay change are ignored.

## Impact

`scripts/main.gd`, new `tests/verify_input_cooldown.gd`. No save-format or string changes.
