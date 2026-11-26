## Root cause of DNG-12

There was no runtime leak between dialogs: `_show_confirmation()` already set the title and message on every call. The wrong text was the hub Exit's own copy. `CONFIRM_EXIT_MESSAGE` ("Any unconfirmed allocation changes will be discarded") dates from the first mobile version, and warns about something that cannot happen on the hub: `staged_allocation` is reset each time Level Up opens, and leaving Level Up dropped the staged points without asking (DNG-11). The warning belonged on Level Up's Back, not on the hub's Exit.

The dialog could still leak in other ways, which this change closes:
- The accept and cancel labels were set only at start-up and on a language change, never per dialog, so a dialog with its own button label would have leaked it into the next one.
- `_activate_screen()` hid the dialog but kept `pending_confirmation_action`, so a dialog closed by a screen change still held an action.

## Decisions

1. **Keys, not texts.** `_show_confirmation(title_key, message_key, action, accept_key = CONFIRM_ACCEPT_KEY)` stores the keys in `confirmation_text_keys` and `_refresh_confirmation_text()` translates them. Every call sets all four texts (title, message, accept, cancel), and `_apply_menu_text()` re-translates the open dialog instead of resetting its buttons.
2. **One close path.** `_close_confirmation()` hides the dialog and clears its action and keys. Accept, cancel, system back and `_activate_screen()` all use it. Accept takes the action before closing, then runs it.
3. **Hub Exit keeps its action.** The Exit button still returns to the main menu: quitting the app from the hub would remove the only way back to the main menu (Settings, Load Game, New Game). The title "Exit game?" / "¿Salir de la partida?" reads as leaving the current game, and the message says how to resume it. The main menu's system back keeps "Quit the game?", which closes the app.
4. **Accept labels name the action** where it helps: "Exit" / "Salir" and "Discard" / "Descartar". The other dialogs keep "Confirm".
5. **Level Up Back.** `_request_leave_level_allocation()` serves the Back button and `_handle_back()` on `SCREEN_LEVEL_UP`. It asks only when `_get_staged_points() > 0`. A class choice is applied at once (not staged), so it never counts as an unconfirmed change. The discard clears `staged_allocation`; the reserve is untouched because staged points are never taken from it before confirmation.
6. **Input cooldown.** The dialog was already a watched node of `input-cooldown-after-screen-change`, so the tap that pressed Back cannot also press Discard.
