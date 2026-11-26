# Changelog

All notable changes to this project, **newest first**. Each entry lists what changed and known issues.

<!--
## YYYY-MM-DD — Short title
### Changes
- What changed (files or commit sha)
### Issues
- Known problems, or "None known."
-->

## 2026-11-26 — Mobile: progression hints and Rest rework (`867cf10`, DNG-14 to DNG-16)
### Changes
- DNG-14 (decision): 1.0 gets attack selection only; follow-up DNG-25. No code change.
- DNG-15: hints for the 5 starting points and the level-10 class unlock on the hub and Level Up (`CLASS_CHOICE_LEVEL` constant). Playtest bot gains `allocation=` strategies. Analysis report `mobile-version/docs/progression-check-2026-11-26.md`: pacing on target (level 2 in 4.7 runs); level 1 is the slowest level; Strength is necessary but does not dominate. Tuning recommendations are listed there, not applied.
- DNG-16: Rest restores a fixed 30% life / 20% energy for 5 mana (was random 10–40% / 5–25%); the button shows the cost; a result line shows the real gains; disabled with a reason (not enough mana, or life and energy full); exploration messages clear on the next move. Playtest comparison of 3 candidates in `openspec/changes/rest-rework/design.md`.
- New tests `verify_progression_hints`, `verify_rest`; full suite 27/27. OpenSpec changes `progression-hints`, `rest-rework`.
### Issues
- OpenSpec changes not validated/archived (CLI missing, DNG-24).
- Progression tuning recommendations (level-1 threshold, Armor value, harder levels 5–9) need a decision.

## 2026-11-26 — Mobile: dialog fixes and combat feedback (`047a9e5`, DNG-11 to DNG-13)
### Changes
- DNG-11: Back on Level Up (on-screen and Android back) asks "Discard changes?" when points are staged; leaves at once otherwise.
- DNG-12: hub Exit asks "Exit game?" (progress is saved). Root cause: `CONFIRM_EXIT_*` had carried the Level Up discard warning since the first version. Every confirmation now sets its own title, message and button labels, and closing clears the pending action.
- DNG-13: floating damage numbers and "Blocked"/"Dodged"/"Critical!" labels over both fighters; fight log of the last 4 attacks with numbers; plain-language combat text replaces the "was protected" jargon (`scripts/combat_feedback.gd`, `fight_log.gd`, `damage_numbers.gd`). Combat rules unchanged; results now also report the damage dealt.
- New tests `verify_dialog_fixes`, `verify_combat_feedback`; full suite 25/25. OpenSpec changes `confirmation-dialog-fixes`, `combat-feedback`.
### Issues
- OpenSpec changes not validated/archived (CLI missing, DNG-24).
- On the emulator, a full 4-line fight log moves the encounter layout up a few pixels.
- Dialog changes checked by tests only, not on a device.

## 2026-11-26 — Mobile: P1 user-test fixes (`2f6b0fb`, DNG-5 to DNG-10)
### Changes
- DNG-5: main menu shows a logo (`assets/ui/logo.svg`) and the translated title.
- DNG-6: 6-page "How to play" tutorial on the first dungeon entry (`scripts/tutorial.gd`); Skip/Next/Done, reopenable from Settings; "seen" flag stored in the settings file. Rest/Sanctuary/treasure numbers are now named constants in `combat_rules.gd` (values unchanged).
- DNG-7: tapping any stat bar (hub, exploration, Level Up, fight panel) shows its name and description (`scripts/stat_help.gd`); Level Up shows a "What each stat does" guide.
- DNG-8: complete Spanish UI: data names (monsters, abilities, classes, effects) translated at display time (`scripts/localized_names.gd`); static texts refreshed on language change; new `tests/verify_localization.gd` sweeps every screen.
- DNG-9: 300 ms input cooldown after any screen/modal change swallows carried-over taps.
- DNG-10: "Victory!" screen after a won fight (monster, XP gained, run XP) with Continue; the last monster folds into the single dungeon-completed result.
- Fix: a delayed `_finish_depleted_dungeon_exit()` could run twice and wipe the next run (made automated balance runs timing-dependent).
- New tests: `verify_first_run_tutorial`, `verify_stat_help`, `verify_localization`, `verify_input_cooldown`, `verify_fight_victory`. Full suite 23/23.
- OpenSpec changes: `main-menu-branding`, `first-run-tutorial`, `stat-help`, `complete-spanish-localization`, `input-cooldown-after-screen-change`, `fight-victory-result`.
### Issues
- OpenSpec CLI not installed: the six changes are not validated or archived yet (see DNG-24).
- Checked on the Android emulators: menu, stat help, and tutorial. The victory screen and the Spanish UI were checked by tests only.
- Spanish name choices to review: Goblin → "Trasgo", Kobold → "Kóbold".

## 2026-11-26 — Mobile: low-energy warning and experience-lost message (`b5bd00b`, DNG-4)
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
