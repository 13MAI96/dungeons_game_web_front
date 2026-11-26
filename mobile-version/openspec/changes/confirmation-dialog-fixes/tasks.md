## 1. Implementation
- [x] 1.1 `_show_confirmation()` takes translation keys and sets title, message, accept and cancel on every call (`_refresh_confirmation_text`, `confirmation_text_keys`)
- [x] 1.2 `_close_confirmation()` for accept, cancel, back and screen changes; drops the pending action and texts
- [x] 1.3 Level Up Back button and system back use `_request_leave_level_allocation()` (discard confirmation only with staged points)
- [x] 1.4 Hub Exit dialog: "Exit game?", resume message, "Exit" button
- [x] 1.5 EN/ES strings (`CONFIRM_EXIT_*`, `CONFIRM_DISCARD_*`)

## 2. Verification
- [x] 2.1 `tests/verify_dialog_fixes.gd`; `tests/verify_localization.gd` captures the discard dialog; full suite passing
- [ ] 2.2 `openspec validate confirmation-dialog-fixes` and archive (OpenSpec CLI not installed on this machine)
- [ ] 2.3 Manual check on the Android emulator (English and Spanish, back key and on-screen Back)
