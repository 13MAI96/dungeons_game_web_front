# Dungeons — Mobile Version

A portrait, touch-first dungeon crawler built with **Godot 4.7** (GDScript, Compatibility/OpenGL renderer
for the widest Android support).
Behaviour is specified with **OpenSpec** before it is implemented.

## Features

- Localized main menu (English / Spanish) with a language setting that overrides device locale.
- Local save game: new game, load, autosave of stable progress, invalidation on death.
- Level-scaled dungeon generation (sparse maps, monsters, quest, sanctuary) with movement, rest and retreat.
- D20 combat: bounded accuracy and dodge, data-driven critical thresholds, resource costs, flee.
- Player classes, abilities and level-up point allocation; experience is provisional during a run and
  committed only when the player completes the dungeon or retreats.

## Project layout

| Path | Contents |
|---|---|
| `scenes/` | Godot scenes (`main.tscn` is the entry point). |
| `scripts/` | GDScript: `main.gd` (UI/flow), `combat_rules.gd`, `dungeon_generator.gd`, `save_game.gd`, `settings_store.gd`. |
| `data/` | JSON game data: monsters, effects, player abilities and classes. |
| `assets/` | SVG art: `characters/`, `monsters/`, `icons/`, `feedback/`. |
| `localization/` | Gettext `.po` translations. |
| `tests/` | Headless verification scripts (`verify_*.gd`). |
| `tools/` | `run_tests.sh`, `run_android.sh`, `build_release.sh`, `playtest.gd` (balance bot) and `analyze_balance.gd` (balance report). |
| `openspec/` | Specs (`specs/`), active changes (`changes/`) and archived changes. |
| `export_presets.cfg` | Android, iOS and Web export presets. |

## Requirements

| Tool | Version | Notes |
|---|---|---|
| Godot | 4.7.x (standard, not .NET) | Plus matching export templates. |
| OpenSpec CLI | 2.x | `npm install -g @fission-ai/openspec` |
| JDK | 17 | Required by Godot's Android export. Set in *Editor Settings → Export → Android → Java SDK Path*. |
| Android SDK | platform 36, build-tools 36.1.0, platform-tools | Set *Android SDK Path* in Editor Settings. NDK only needed for Gradle builds. |
| Xcode (macOS) | recent | Only for building/signing iOS. |

## Testing the app

| Level | How | What it checks |
|---|---|---|
| Automated tests | `tools/run_tests.sh` | Rules, generation, save/load, navigation, assets (headless, ~1 min). |
| Desktop | `godot --path .` and press **F5**, or `godot --path . --resolution 410x844` | Fastest manual play-through. Mouse clicks act as taps. |
| Android emulator | start the emulator, then `tools/run_android.sh` | Real Android build, touch, save files on device. |
| Android phone | enable *Developer options → USB debugging*, plug in, `tools/run_android.sh` | Real performance, screen sizes and touch. |
| iOS | export the Xcode project, build on a Mac | Requires macOS + Xcode (see Exporting). |

```bash
tools/run_tests.sh                                                # all tests
godot --headless --path . -s res://tests/verify_combat_rules.gd   # single test
godot --headless --path . -s res://tools/analyze_balance.gd       # balance report
godot --headless --path . -s res://tools/playtest.gd -- runs=80 games=6   # automated play-through metrics
tools/run_android.sh --logs                                       # build, install, launch, stream logs
```

Each test exits with code `0` on success and `1` on the first failed check.

### Android emulator

```bash
~/Android/Sdk/emulator/emulator -list-avds
~/Android/Sdk/emulator/emulator -avd Pixel_3a_API_34_extension_level_7_x86_64 -gpu host
```

- Use `-gpu host`. The software GPU (`swiftshader`) is too limited for Godot's shaders and shows a gray screen.
- If the screen stays gray after switching GPU modes, clear the app's shader cache:
  `adb shell run-as com.dungeons.mobile rm -rf files/shader_cache` (or uninstall/reinstall).
- Save data lives on the device: `adb shell run-as com.dungeons.mobile cat files/player_save.json`.

## UI conventions

- **Theme**: all styling lives in [`scripts/ui_theme.gd`](scripts/ui_theme.gd) (palette, font sizes, touch sizes) and is
  applied once to the root `Main` node. Style nodes with `theme_type_variation` (`PrimaryButton`, `DangerButton`,
  `ComingSoonButton`, `DPadButton`, `IconButton`, `CompactButton`, `TitleLabel`, `HeaderLabel`, `CaptionLabel`,
  `CardPanel`, `DialogPanel`), not per-node overrides.
- **Sizes**: buttons ≥ 48 px tall, primary actions 56 px, D-pad 64 px+, body text ≥ 14 px, stat text ≥ 12 px.
- **Screens**: switch screens with `_activate_screen()` so only one is visible and insets are re-applied.
- **Safe area**: views are inset by the device safe area (notch, gesture bar) on mobile.
- **Ad banner slot**: [`scripts/ad_slot_config.gd`](scripts/ad_slot_config.gd) reserves a 60 px bottom slot (+12 px gap)
  on menu, hub, settings and level-up screens; it is hidden during exploration and combat (AdMob placement policy).
  Set `AdSlotConfig.enabled = false` to collapse it. No ad SDK is integrated yet; when adding one
  (e.g. Poing Studios AdMob plugin) set `AdSlotConfig.height` from the loaded banner height.

## Exporting

Exports go to `export/` (git-ignored).

```bash
# Android debug APK (signed with ~/.android/debug.keystore)
godot --headless --path . --export-debug "Android" export/android/dungeons.apk
adb install -r export/android/dungeons.apk

# Web (PWA)
godot --headless --path . --export-release "Web" export/web/index.html
```

- **Android release**: `tools/build_release.sh` builds `export/android/dungeons-release.apk` signed with the
  release key. The keystore and password live outside the repo in `~/.android/keystores/`
  (`dungeons-release.keystore` + `dungeons-release.properties`) and reach Godot through the
  `GODOT_ANDROID_KEYSTORE_RELEASE_*` environment variables, so `export_presets.cfg` stays secret-free.
  **Back up both files somewhere safe**: losing them means you can never publish an update to the same app.
  Bump `version/code` / `version/name` in the Android preset before each published build.
  Package name is `com.dungeons.mobile`.
- **iOS**: set `application/app_store_team_id` in the iOS preset. The preset exports an Xcode
  project (`export_project_only=true`), which can be generated on Linux; building, signing,
  the iOS Simulator and device installs require macOS with Xcode.

## OpenSpec workflow

1. Propose a change under `openspec/changes/<name>/` (proposal, design, tasks, spec deltas).
2. Implement it in Godot/GDScript and add or extend a `tests/verify_*.gd` script.
3. `openspec validate <name>` — fix any delta errors.
4. `openspec archive <name> -y` — merges the deltas into `openspec/specs/` and archives the change.

Delta rules worth remembering: a `MODIFIED` requirement must already exist and must keep every
existing scenario name; when behaviour is replaced rather than extended, use `REMOVED` + `ADDED`.
