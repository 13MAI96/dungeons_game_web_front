## 1. Implementation
- [x] 1.1 Replace the empty `LogoSpace` with `Branding` (logo frame + game title) in `scenes/main.tscn`
- [x] 1.2 `GameTitleLabel` theme variation in `scripts/ui_theme.gd`
- [x] 1.3 Null-safe logo load and translated title in `scripts/main.gd`
- [x] 1.4 `GAME_TITLE` EN/ES strings ("Dungeons" / "Mazmorras")

## 2. Verification
- [x] 2.1 `tests/verify_ui_shell.gd`: title and logo exist, are translated/loaded, and fit 1440x3088 and 1080x2220 without overlapping the buttons or the ad slot
- [x] 2.2 Full suite passing; rendered menu checked on desktop (Spanish, 393x844)
- [ ] 2.3 `openspec validate main-menu-branding` and archive (OpenSpec CLI not installed on this machine)
