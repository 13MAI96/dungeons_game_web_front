## 1. Implementation
- [x] 1.1 `_warn_if_energy_low()` with a once-per-run flag stored in the dungeon
- [x] 1.2 Call it after move, fight (victory and ongoing), flee, and collect treasure
- [x] 1.3 Depletion results (energy and life) add the "experience lost" line
- [x] 1.4 EN/ES strings

## 2. Verification
- [x] 2.1 `tests/verify_energy_warning.gd`; playtest bot dismisses the warning (`tools/playtest_bot.gd`); full suite 18/18 passing
- [ ] 2.2 `openspec validate energy-loss-feedback` and archive (OpenSpec CLI not installed on this machine)
- [x] 2.3 Manual check on the Android emulator (S23, Spanish: warning at 7/25 energy)
