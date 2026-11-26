# Dungeons Web — Project Index

Entry point to this repository: what it is, how it is built, the rules it follows and how it is tested and
shipped. History lives in [CHANGELOG.md](CHANGELOG.md).

---

## 1. Project

**Dungeons** is a single-player dungeon crawler. The player explores a grid of rooms, fights monsters with
d20 rolls, collects quests (treasures/traps), rests at sanctuaries and earns experience and reputation.

This repository holds **two independent clients** of the same game:

| Client | Path | Stack | Status |
|---|---|---|---|
| Web (original prototype) | `/` (`src/`) | Angular 17 + Angular Material | Prototype from 2024, frozen. Talks to `dungeons_backend`. |
| Mobile (current focus) | `mobile-version/` | Godot 4.7, GDScript | Active. Offline, self-contained, preparing 1.0 for Google Play. |

Related repository: `../dungeons_backend` (FastAPI + MongoDB) generates dungeons for the web client.
The mobile version does **not** use the backend; it generates dungeons locally.

---

## 2. Architecture

### 2.1 Web client (Angular)

```
main.ts ── bootstrapApplication(AppComponent, appConfig)
             │  appConfig: router, HttpClient (fetch), async animations
             ▼
        app.routes.ts
          ''           → redirect to /login
          /login       → LoginComponent      (form → PlayerService.login)
          /new-player  → NewPlayerComponent  (form only, no logic yet)
          /game        → GameComponent       (player stats, combat, rest, quests)
                            ├── PlayerComponent   (stats panel)
                            └── DungeonComponent  (grid map, movement, visibility)
                                   └── DungeonsDataService.getDungeon() ── HTTP GET ──► dungeons_backend :4600 /
```

| Folder | Contents |
|---|---|
| `src/app/components/` | Standalone components: `login`, `new-player`, `game`, `dungeon`, `player`, `actions` (empty placeholder). |
| `src/app/dialogs/` | Material dialogs: `login-error`, `quest`. |
| `src/app/snackbar/` | `quest` snackbar used for combat/quest feedback. |
| `src/app/services/` | `DungeonsDataService` (fetches a dungeon), `PlayerService` (login, currently mocked). |
| `src/app/models/` | `Player` (stats and formulas), `Dungeon`, `Location`, `BodyResponse<T>`. |
| `src/assets/` | SVG icons (SVG Repo) and `icons.ts` with inline SVG literals registered in `MatIconRegistry`. |

State is held in component memory only (no store, no persistence). A page reload loses the game.

### 2.2 Mobile client (Godot)

Single scene app; the full description is in [mobile-version/README.md](mobile-version/README.md).

| Path | Role |
|---|---|
| `scenes/main.tscn` | Entry scene (all screens). |
| `scripts/main.gd` | UI flow, screens, input, run lifecycle. |
| `scripts/combat_rules.gd` | D20 attack/dodge/critical resolution, costs, flee. |
| `scripts/dungeon_generator.gd` | Level-scaled map, monsters, quest, sanctuary. |
| `scripts/save_game.gd` | Local save (atomic write, format v2, active-run persistence). |
| `scripts/settings_store.gd` | Language and other settings. |
| `scripts/tutorial.gd` | First-run how-to-play overlay (paged, reopened from Settings). |
| `scripts/stat_help.gd` | Shared popup that explains a stat when its bar is tapped. |
| `scripts/ui_theme.gd` | Single source of UI styling. |
| `scripts/ad_slot_config.gd` | Reserved banner slot (no ad SDK yet). |
| `data/*.json` | Data-driven monsters, effects, abilities, classes. |
| `localization/*.po` | English / Spanish. |
| `openspec/` | Behaviour specs (`specs/`) and archived changes. |
| `tests/`, `tools/` | Headless verification scripts, test/build/playtest tooling. |

---

## 3. Definitions (glossary)

| Term | Meaning |
|---|---|
| **Dungeon** | Grid of `number_of_columns × number_of_rows` locations generated per run. |
| **Location** | One cell. Types: `ENTRANCE`, `BLOCK` (wall), `MONSTER`, `QUEST`, `SANCTUARY`, exit. |
| **Visible / canVisit / visited** | Web map flags: revealed to the player, orthogonally adjacent and walkable, already resolved. |
| **Run / expedition** | One trip into a dungeon. Ends by completing it, retreating at the entrance, dying or running out of energy. |
| **Life / Energy / Mana** | Hit points / movement-and-action budget / resource used to rest (restore life and energy). |
| **Armor / Damage** | Target number an attack roll must beat / life removed by a successful hit. |
| **Reputation / Experience** | Progression currencies. In mobile, run XP is provisional and committed only on completion or retreat. |
| **Sanctuary** | Healing location. Mobile: restores once per dungeon. |
| **Quest** | Web: treasure check (XP) or trap (life loss). |
| **D20 roll** | `random(1..20)` + modifiers compared to armor; natural 20 is a critical. |
| **Base stats** | Strength, Vitality, Accuracy, Agility, Vision, Magic; derived stats are computed from them (`Player.setVisibleStats()` on web, `player_classes.json` growth on mobile). |
| **OpenSpec change** | Proposal + design + tasks + spec deltas under `mobile-version/openspec/changes/`, archived once implemented. |

---

## 4. Rules

### 4.1 Game rules (web prototype, as implemented)

- Movement: one step orthogonally to an adjacent non-`BLOCK` location; requires energy > 0.
- Leaving an unresolved monster: 75% chance to be hit while fleeing.
- Attack: costs 2 energy; `d20 + damage` vs monster armor; on a miss the monster may counter-attack.
- Rest: costs 10 mana, restores 20% life and 20% energy.
- Quest: costs 1 energy; success gives 5 XP, failure is a trap (−2 life).
- Leaving the dungeon away from the entrance asks for confirmation (reputation loss).
- Death: run experience and reputation are lost, stats restored.

The mobile rules are richer and are **defined by the specs** in `mobile-version/openspec/specs/`
(combat-rules, attack-resolution-rules, player-progression-rules, monster-progression-rules, …).
Those specs are the source of truth; code must match them.

### 4.2 Development rules

- **Spec first (mobile):** every behaviour change goes through an OpenSpec change → implement → add/extend a
  `tests/verify_*.gd` → `openspec validate <name>` → `openspec archive <name> -y`.
  A `MODIFIED` requirement must keep all existing scenario names; replaced behaviour uses `REMOVED` + `ADDED`.
- **Scope:** mobile work stays inside `mobile-version/`; the Angular app is not modified unless explicitly requested.
- **Data over code:** balance numbers (monsters, abilities, class growth) belong in `data/*.json`;
  class growth values must be positive integers.
- **UI (mobile):** style through `ui_theme.gd` variations, never per-node overrides; touch targets ≥ 48 px;
  switch screens with `_activate_screen()`.
- **Localization:** every user-facing mobile string goes through the `.po` files (EN + ES).
- **Secrets:** signing keystore and passwords stay in `~/.android/keystores/`, never in the repo
  (`export_presets.cfg` must remain secret-free).
- **Documentation:** each change adds an entry at the top of `CHANGELOG.md`.
- **Code style:** readable, self-documenting code with a comment on each class/method added.

---

## 5. Testing

### Web

```bash
npm install
npm start            # ng serve → http://localhost:4200 (needs dungeons_backend on 127.0.0.1:4600)
npm test             # Karma + Jasmine
```

There are currently **no spec files** (`app.component.spec.ts` was removed in "Primer version"), so
`npm test` has nothing to run. Testing is manual through the browser.

### Mobile

| Level | Command |
|---|---|
| All automated tests (headless, ~1 min) | `cd mobile-version && tools/run_tests.sh` |
| Single test | `godot --headless --path . -s res://tests/verify_combat_rules.gd` |
| Balance report | `godot --headless --path . -s res://tools/analyze_balance.gd` |
| Automated play-through | `godot --headless --path . -s res://tools/playtest.gd -- runs=80 games=6` |
| Desktop play | `godot --path . --resolution 410x844` |
| Android emulator / phone | `tools/run_android.sh [--logs]` (emulator with `-gpu host`) |

Each `verify_*.gd` exits `0` on success and `1` on the first failed check. Coverage areas: combat rules,
dungeon generation and movement, location effects, save game, settings, navigation, UI shell/assets,
experience accumulation, release fixes and balance guard.

---

## 6. Deployment

### Web

```bash
npm run build        # production build → dist/dungeons_web/browser
```

The output is a static site and can be served by any web server. There is no hosting target configured,
and the API URL is hardcoded in `src/app/services/dungeons-data.service.ts` (no `environments/` files).

### Mobile

| Target | Command / notes |
|---|---|
| Android debug APK | `godot --headless --path . --export-debug "Android" export/android/dungeons.apk` |
| Android release APK | `tools/build_release.sh` → `export/android/dungeons-release.apk`, signed with the keystore read from `~/.android/keystores/dungeons-release.properties` |
| Web (PWA) | `godot --headless --path . --export-release "Web" export/web/index.html` |
| iOS | Preset exports an Xcode project only; build/sign on macOS. |

Package name `com.dungeons.mobile`; bump `version/code` and `version/name` in the Android preset before each
published build. Exports go to `export/` (git-ignored). Google Play still requires an AAB build and store
setup; see [mobile-version/docs/release-readiness.md](mobile-version/docs/release-readiness.md).

---

## 7. CI/CD

**There is no CI/CD pipeline.** No `.github/`, `.forgejo/` or other pipeline files exist; builds,
tests and releases are run manually with the commands above. Remote: `github.com/13MAI96/dungeons_game_web_front`.

Suggested pipeline when one is added:

1. **Mobile tests:** on push, run `tools/run_tests.sh` in a headless Godot 4.7 container, plus
   `openspec validate --all`.
2. **Mobile build:** on tag, export the Android AAB/APK with the keystore injected from CI secrets
   (`GODOT_ANDROID_KEYSTORE_RELEASE_*`).
3. **Web:** `npm ci && npm run build` to catch compile errors.
