# Release readiness plan — Dungeons mobile 1.0

Status date: 2026-11-14. Source: code review, spec gap analysis, store-requirements research and a
150-run automated play-through of the real game scene (see "Evidence" at the end).

**Verdict:** technically stable (15/15 tests, 17/17 specs valid, no crashes in 150 bot runs), but not
releasable yet: progression is effectively blocked, several rules can be exploited, and the build is not
in a format Google Play accepts.

## Step 1 — Gameplay bug fixes ✅ done (2026-11-14)

OpenSpec change `release-gameplay-fixes` (archived). Verified by `tests/verify_release_fixes.gd`, a code review and an Android emulator check of the back key.

| # | Problem | Fix |
|---|---|---|
| 1.1 | Sanctuary heals without limit (step off and back on) | A sanctuary restores once per dungeon, then counts as visited |
| 1.2 | A winning blow that spends the last energy forfeits the run | Resolve monster defeat / dungeon completion before the depletion check |
| 1.3 | Save can be lost if the app dies while saving | Atomic replace (write temp file, rename over), fall back to the temp file on load, check write errors |
| 1.4 | Android back gesture quits the app from any screen | Disable quit-on-back; back navigates (close modal → previous screen → confirm leave/quit) |
| 1.5 | Killing the app mid-run avoids the death penalty and loses the run | Persist the active run (map, position, monster) at every action and on pause; Load Game resumes it |
| 1.6 | Earned level-ups are invisible until Progression is opened | Pending-progression dot also shows for convertible level-ups |
| 1.7 | Fight does nothing when the attack cannot be paid | Fight is disabled with an explanation; Flee stays available |
| 1.8 | Mage armor growth `0.5` truncates to 0 | Integer growth in data + test that every class growth is a positive integer |
| 1.9 | Start Game overwrites an unreadable save without asking | Confirm whenever a save file exists, readable or not |

## Step 2 — Balance (next)

After step 1 (sanctuary no longer heals without limit) the same bot policy gave 80 retreats, 52 energy-outs,
17 deaths, 1 game over and stayed at level 1 — the game got harder, so balance is now the top priority.

Measured with the play-through bot (cautious policy, 150 runs): **0 dungeons completed**, 87 retreats,
57 energy-outs, 4 deaths; level 3 after 150 runs; reputation 0. Level 10+ dungeons average 68 monsters
(up to 213) and require killing all of them.

- Tune energy cost per attack / starting energy, player damage (strength currently adds no damage), monster life.
- Pay something on energy-out (currently all run XP is lost) or make the rule explicit in the UI.
- Cap monster count or use a completion threshold for large dungeons.
- Add the bot to `tools/` with assertions (e.g. ≥ X % of level-1 runs completable).

## Step 3 — Scope decisions (owner)

| Item | Options | Effort |
|---|---|---|
| Attack selection + abilities (Heavy Attack, class attacks, passives) | Build (spec already requires one action per available attack) | M |
| Status effects (poison, fatigue, dizziness) | Build or delete unused data | M |
| Challenge Dungeon, Shop ("Coming soon") | Build (L each) or remove buttons (S, needs spec change) | S–L |
| Equipment | Post-1.0 (no design anywhere) | L |
| Contradictory specs (D20 face vs no raw rolls, "2 to 5 attacks", "Manage Equipment" label) | Resolve | S |

## Step 4 — Polish

- App identity: real launcher icon (adaptive 432×432 layers + monochrome), name (project is "Mobile Version"), version 1.0.0, logo on the menu, splash.
- Audio (music, SFX, volume/mute setting), basic motion (hit flash, bar tween, overlay fade).
- First-run "how to play" (energy loss forfeits run XP, rest costs mana, retreat only at entrance, death sequels can delete the save).
- Localize monster / attack / class names; fix Spanish typos ("Dano" → "Daño").
- Credits and asset licences (icons from SVG Repo — verify licence).
- Ad slot: disable (`AdSlotConfig.enabled = false`) for 1.0 or integrate AdMob (needs consent flow, INTERNET permission, privacy policy update).

## Step 5 — Google Play

| Item | Level |
|---|---|
| Play Console personal account (US$25), identity + phone + device verification | Blocker (owner) |
| AAB build: install Godot Gradle build template, `use_gradle_build=true`, export format AAB, JDK 17, NDK 29.0.14206865 | Blocker |
| Verify `PAGE_ALIGNMENT_16K` with bundletool | Required |
| Privacy policy page (no data collected), linked in listing and in-game | Required |
| Listing EN/ES: name (30), short (80), full (4000), 512×512 icon, 1024×500 feature graphic, ≥ 2 phone screenshots (1080×1920) | Required |
| App content: Data safety (none), IARC rating, audience 13+, Ads = No, Advertising ID = No | Required |
| Internal test → closed test with ≥ 12 testers for 14 consecutive days → production access review (~7 days) | Blocker, ~3–4 weeks |
| Back up the upload keystore (`~/.android/keystores/`) | Blocker |
| Already compliant: target API 36, 64-bit, 16 KB alignment, edge-to-edge | Done |

iOS (optional): needs a Mac with Xcode 26 and the Apple Developer Program (US$99/yr).

## Evidence

- Automated play-through: headless bot driving `scenes/main.tscn` through its public methods (two policies × 150 runs).
- Static code review (code-reviewer agent), spec-by-spec gap analysis and store research (general-purpose agents), 2026-11-14.
