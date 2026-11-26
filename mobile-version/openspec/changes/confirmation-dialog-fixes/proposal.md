## Why

User test 2026-11-26 found two problems with the shared confirmation dialog:

- **DNG-11:** on the Level Up screen, the on-screen Back button and the Android back key return to the hub and silently drop the staged (unconfirmed) points.
- **DNG-12:** the Exit button on the hub (the screen with the character, which players see as the game's main menu) asks "Return to the main menu? Your progress is saved. Any unconfirmed allocation changes will be discarded." The allocation warning makes no sense there, because staged points only live on the Level Up screen, and the title does not match the "Exit" button.

## What Changes

- **Level Up Back:** both Back paths ask "Discard changes?" when points are staged. Confirm (Discard) drops the staged points, which stay in the reserve, and returns to the hub; Cancel or back stays on Level Up with the staged points intact. With nothing staged, Back returns to the hub at once.
- **Hub Exit:** the Exit button and system back on the hub ask "Exit game?" / "¿Salir de la partida?" with "Your progress is saved. You can continue later with Load Game." and an "Exit" accept button. Confirming still returns to the main menu (the action is unchanged).
- **One dialog, own texts:** `_show_confirmation()` takes translation keys and sets the title, message and both button labels on every call; closing the dialog (accept, cancel, back or a screen change) also drops its action and texts. A screen change can no longer leave a hidden dialog whose action could still run, and a language change re-translates an open dialog.
- New EN/ES strings: `CONFIRM_EXIT_ACCEPT`, `CONFIRM_DISCARD_TITLE`, `CONFIRM_DISCARD_MESSAGE`, `CONFIRM_DISCARD_ACCEPT`; new texts for `CONFIRM_EXIT_TITLE` and `CONFIRM_EXIT_MESSAGE`.

The main menu's system back keeps its "Quit the game?" confirmation, which closes the app.

## Capabilities

### Modified Capabilities
- `level-up-allocation`: new requirement for leaving Level Up with staged points.
- `app-shell`: back on Level Up follows the discard rule; the hub leave confirmation is the Exit dialog; every confirmation shows its own texts.

## Impact

`scripts/main.gd`, `localization/menu.en.po`, `localization/menu.es.po`, new `tests/verify_dialog_fixes.gd`, `tests/verify_localization.gd` (also captures the discard dialog). No save-format or rules change.
