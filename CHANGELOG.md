# Changelog

All notable changes to this project, **newest first**. Each entry lists what changed and known issues.

<!--
## YYYY-MM-DD — Short title
### Changes
- What changed (files or commit sha)
### Issues
- Known problems, or "None known."
-->

## 2026-11-26 — Mobile: low-energy warning and experience-lost message (DNG-4)
### Changes
- One-time "Low energy" warning per run when energy drops to 25% of maximum or below. It shows the energy left and the dungeon XP at risk, and advises retreating at the entrance (`mobile-version/scripts/main.gd`, `_warn_if_energy_low`).
- Energy and life depletion results now state the dungeon experience lost.
- EN/ES strings `LOW_ENERGY_TITLE`, `LOW_ENERGY_MESSAGE`, `DUNGEON_EXPERIENCE_LOST`.
- OpenSpec change `openspec/changes/energy-loss-feedback` (not archived yet) and new `tests/verify_energy_warning.gd`.
- Origin: user test with two simulated players on Android emulators; 20 follow-up tickets DNG-4 to DNG-23.
### Issues
- OpenSpec CLI is not installed here, so the change has not been validated or archived yet.

## 2026-11-26 — Project documentation
### Changes
- Added `INDEX.md` (project, architecture, definitions, rules, testing, deployment, CI/CD) and this `CHANGELOG.md`.
### Issues
- None known.

## 2026-11-14 — Mobile: progression balance (`566dc9e`, DNG-3)
### Changes
- OpenSpec change `progression-balance` (archived).
- Basic attack 3 damage / 1 energy; Strength adds damage; easier level-1 monsters; monster XP × 4.
- One monster-count formula at every level; map grows with level from 10 (max 25×25); narrower monster level ranges.
- Post-level-10 experience/reputation thresholds grow ~11% per level instead of ~120%.
- Saved attacks refresh from ability data on load.
- New `tools/playtest.gd`, `tools/playtest_bot.gd` and `tests/verify_balance.gd`.
- Measured: dungeons completed 0% → 56%, out-of-energy runs 66% → 6%, level 10 reached in ~25 runs.
### Issues
- Levels 5–9 are easy (~87% of dungeons completed).

## 2026-11-14 — Mobile: release-blocking gameplay fixes (`dbd160a`)
### Changes
- Sanctuaries heal once per dungeon run.
- Victory and dungeon completion resolve before the energy-depletion check.
- Atomic saves with temp/backup recovery; save format v2 (v1 still loads).
- Active runs persist on every action and on app pause; Load Game resumes them.
- Android back navigates in-game with quit/leave/abandon confirmations; new "abandon expedition".
- Fight disabled with an explanation when the attack cannot be paid.
- Progression indicator shows convertible level-ups.
- Mage armor growth 0.5 → 1; class growth must be whole numbers.
- Start Game confirms before replacing any save file, even unreadable ones.
- Added `mobile-version/docs/release-readiness.md` and `tests/verify_release_fixes.gd`.
### Issues
- Not releasable yet: scope decisions, polish and Google Play setup (AAB build, store listing, closed testing) pending.

## 2026-11-12 — Mobile: fixes and restyling (`b59b5a1`)
### Changes
- New SVG art for player, monsters and D-pad/status icons; removed old monster art.
- Centralized theme (`scripts/ui_theme.gd`), touch sizes, safe-area insets, ad banner slot (`ad_slot_config.gd`).
- OpenSpec changes: combat and dungeon balance, experience accumulation, mobile UI refresh, playable feedback,
  save-game persistence, settings and "coming soon" screens.
- Expanded `mobile-version/README.md` (testing, emulator, exporting, OpenSpec workflow).
### Issues
- Progression effectively blocked (0% dungeons completed in automated runs), fixed on 2026-11-14.

## 2026-11-12 — Mobile: first Godot version (`476a6c0`)
### Changes
- Added `mobile-version/`: Godot 4 portrait dungeon crawler written with Codex.
- Localized main menu (EN/ES), new game, dungeon exploration, monster encounters, D20 combat,
  leveling and player classes, data-driven JSON content, headless `verify_*.gd` tests.
- OpenSpec specs and archived changes dated 2026-07-27/28.
### Issues
- Several gameplay bugs and balance problems (see the following entries).

## 2024-08-03 — Web: dungeon data service URL (`43ac7b9`)
### Changes
- `DungeonsDataService` gains an alternative LAN backend URL (commented out).
### Issues
- Backend URL is hardcoded; there are no environment files.

## 2024-08-03 — Web: first playable version (`0a554a8`)
### Changes
- Login, new-player, game, dungeon and player components; quest dialog and snackbar.
- `Player`, `Dungeon`, `Location` models; stats formulas; combat, rest, quest and flee mechanics.
- Dungeon fetched from `dungeons_backend` (`127.0.0.1:4600`); Angular Material UI with SVG Repo icons.
### Issues
- Login is mocked in `PlayerService` (one hardcoded username, no backend call).
- Energy cost of movement and flee damage are commented out in `DungeonComponent`.
- New-player screen has no logic; `actions` component is empty.
- No unit tests (default spec removed).

## 2024-05-14 — Initial commit (`a8587b8`)
### Changes
- Angular CLI 17.3.7 scaffold.
### Issues
- None known.
