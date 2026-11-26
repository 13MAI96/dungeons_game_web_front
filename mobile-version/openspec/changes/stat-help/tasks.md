## 1. Implementation
- [x] 1.1 `scripts/stat_help.gd`: shared popup, stat name/description texts with rule numbers, `attach()` tap wiring
- [x] 1.2 Wire every stat bar in `_create_stat_bar()` (hub, exploration HUD, Level Up, fight panel)
- [x] 1.3 Close on tap anywhere, Android back and screen change
- [x] 1.4 Level Up "What each stat does" guide with gain per point
- [x] 1.5 EN/ES strings (Rioplatense voseo)

## 2. Verification
- [x] 2.1 `tests/verify_stat_help.gd` (real taps on every stat bar of the four screens, close on tap and back, Level Up guide, ES translations); full suite passing
- [ ] 2.2 `openspec validate stat-help` and archive (OpenSpec CLI not installed on this machine)
- [ ] 2.3 Manual check on the Android emulator (tap and scroll on Level Up)
