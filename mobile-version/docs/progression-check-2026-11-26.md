# Progression check — 2026-11-26 (DNG-15)

Analysis only. Nothing in this report was applied to the rules or balance numbers. The hints from the same ticket are in the OpenSpec change `progression-hints`.

## Context

A user test raised four points:

1. It was unclear where the 5 starting points come from. Fixed by the hints.
2. The class choice unlocks at level 10, but nothing said so. Fixed by the hints.
3. Level 1 felt slow: a gamer had 67/100 XP after 2.5 expeditions. The balance target is level 2 in about 5 runs (`docs/release-readiness.md`, step 2).
4. Stacking Strength might dominate.

The rule values involved (`scripts/combat_rules.gd`, `scripts/dungeon_generator.gd`, `data/monsters.json`):

| Rule | Value |
|---|---|
| Starting points | `INITIAL_PROGRESSION_POINTS` = 5 |
| Points per level | `LEVEL_UP_POINTS` = 3 (classes also use 3) |
| Class choice | `CLASS_CHOICE_LEVEL` = 10 |
| XP thresholds | cumulative, `level × 100` through level 10 (level 2 at 100, level 5 at 400), then +(10 + level/10)% per level |
| Monster XP | template XP (1 or 2) × `EXPERIENCE_TEMPLATE_MULTIPLIER` 4, so 4 or 8 per kill |
| Completion bonus | +1 XP per monster in the dungeon (5–7 at level 1) |
| Quest | `QUEST_REWARD_EXPERIENCE` = 5 |
| Strength | to-hit `10 + armor/2 − strength/2` (d20), plus +1 damage per 2 points above 3 |
| Growth per point | Life +5, Energy +5, Mana +4, Armor/Speed/Strength +1 |

## Method

- `tools/analyze_balance.gd` (static dungeon and combat sampling).
- `tools/playtest.gd -- runs=40 games=6 seed=1`: 6 games × 40 runs each, real main scene, cautious bot (`tools/playtest_bot.gd`).
- The bot has a new `allocation=` option: `default | strength | balanced | tank`. Each strategy ran on the same seed. The stat orders are cycled on every Level Up visit:
  - `default`: Str, Life, Energy, Str, Armor, Life, Speed, Energy. This is the original bot, which `tests/verify_balance.gd` measures.
  - `strength`: every point in Strength.
  - `balanced`: Life, Str, Energy, Armor, Speed, Mana.
  - `tank`: Life, Armor, Life, Armor, Energy (no Strength).
- `default` with the new code gives the same result as the old bot, down to the action count (17631 actions). The default behaviour, and so `verify_balance`, is unchanged.
- "Runs to level N" is the average number of finished runs before the player first reaches level N. "XP/run" is the experience a run committed to the permanent total (0 when the run was lost).

Limits: one bot personality (it fights every monster, rests below 50% life, flees below 30%), basic attack only, and 6 games per strategy. Treat differences under about 1 run as noise. Combat rolls use the global RNG, so strategies share the dungeon seeds but not every roll.

## Static analysis (`tools/analyze_balance.gd`)

| Level | Cells | Monsters | Quests | Sanctuaries |
|---|---|---|---|---|
| 1 | 30.1 | 6.1 (5–7) | 1 | 1 |
| 5 | 30.1 | 6.9 (6–8) | 2 | 1 |
| 10 | 55.6 | 8.9 (8–10) | 3 | 1 |

| Player | Hit rate | Expected damage per attack |
|---|---|---|
| Strength 3 | 46.6% | 1.55 |
| Strength 8 | 59.3% | 3.22 (×2.1) |

| Player | Dodge rate when an attack passes |
|---|---|
| Speed 3 | 5.0% |
| Speed 8 | 11.1% |

A full level-1 clear is worth about 30 XP: 6 kills × 4–8 XP, plus the completion bonus of about 6, plus the quest's 5 when it succeeds. Level 2 (100 XP) therefore needs about 3 full clears. Partial runs that retreat take longer.

## Pacing (sensible player = `default` bot)

| Milestone | Runs (average) | Target |
|---|---|---|
| Level 2 | **4.7** | ~5 ✅ |
| Level 3 | 8.5 | — |
| Level 4 | 11.7 | — |
| Level 5 | 14.3 | — |
| Level 10 | 24.3 | 25 ✅ |

| Level band | Runs | Completed | Retreated | Out of energy | Died | XP/run |
|---|---|---|---|---|---|---|
| L1 | 28 | 36% | 54% | 11% | 0% | **24.8** |
| L2–4 | 58 | 57% | 40% | 3% | 0% | 31.2 |
| L5–9 | 60 | 92% | 8% | 0% | 0% | 51.4 |
| L10+ | 94 | 74% | 21% | 2% | 2% | 59.9 |

Runs per level: L1→2 4.7, L2→3 3.8, L3→4 3.2, L4→5 2.6, then about 2 per level up to level 10.

**Reading.** Level 2 arrives on target. The user-test gamer (67 XP in 2.5 runs, about 27 XP/run) was on the same pace as the bot (24.8 XP/run) and would reach level 2 in about 4 runs. The early game still *feels* slow for a structural reason: **level 1 is the slowest level of the first ten**. XP per run doubles from L1 to L5–9, while every threshold step is the same flat 100. The pacing curve is inverted: the first level-up, the one that teaches the loop, takes the longest. Only 36% of level-1 dungeons are completed, against 92% at L5–9, which matches the known "levels 5–9 are easy" note in `release-readiness.md`.

## Allocation strategies (same seeds)

| Strategy | Level after 40 runs | Runs to L2 / L3 / L5 / L10 | Completed | Died | Out of energy | L1 XP/run |
|---|---|---|---|---|---|---|
| default (mixed) | **16.3** | 4.7 / 8.5 / 14.3 / 24.3 | **70%** | 0.8% | 2.9% | **24.8** |
| balanced | 16.2 | 6.0 / 9.3 / 15.0 / 25.3 | 66% | 1.7% | 2.5% | 18.1 |
| strength only | 9.3 | 6.0 / 10.7 / 18.8 / 38.5 | 17% | **19.6%** | 1.7% | 18.4 |
| tank (Life/Armor, no Strength) | 4.8 | 6.0 / 12.5 / 30.2 / never | 7% | 0% | **41.7%** | 17.6 |

**Strength does not dominate.** All-Strength is the second-worst build:
- Its offence is good, but with 10 life it dies often: 5 deaths in 36 level-1 runs, and 34 deaths in L5–9 against 0 for the default build.
- It reaches level 10 only around run 38, against run 24 for the mixed build.

Strength is still **necessary**. Without it (tank), fights take so long that 42% of runs end out of energy, and the build stalls around level 5. The best results come from mixing Strength with Life and Energy. That is what the default bot does, and the balanced order is close behind. Strength does double duty (to-hit and damage), so it is the most valuable single stat per point. The other stats are not traps, though: Life and Energy are what let a Strength build survive and finish a dungeon.

Armor and Speed are weak per point. One point changes nothing until it crosses an even number (`ATTRIBUTE_SCALE_DIVISOR` = 2). Even then it moves a d20 roll by only 1, and dodge is capped near 5–11%. The tank build fails mostly because Armor does not shorten fights.

## Recommendations (follow-up, not applied)

| # | Proposal | Where | Why / how to check |
|---|---|---|---|
| F1 | **Shorten level 1 only:** first threshold 100 → **70**, keeping the later thresholds (200, 300, …) | `CombatRules.get_experience_threshold()` (special-case level 1) and the `player-progression-rules` spec ("level 1 requires 100") | Brings level 2 to about 3 runs, so the first level-up lands while the player is still learning, without moving level 10 (~24 runs). Check with `tools/playtest.gd -- runs=40 games=6 seed=1`. Target: L2 ≈ 3, L10 within 23–26. `tests/verify_balance.gd` (L2 ≤ 10) still passes. |
| F2 | Alternative to F1: **completion bonus ×2 below level 5** (2 XP per monster instead of 1) | `main._complete_dungeon_if_ready()` / `commit_dungeon_experience()` | Rewards finishing the dungeon, the behaviour the game wants to teach, and adds about +6 XP to a level-1 clear. Use F1 or F2, not both. |
| F3 | **Show XP to next level on the hub** (e.g. "67 / 100 XP"), or a "+XP" line in the run result | `main.gd` hub stat bars, result modal | The user test's "feels slow" is partly perception. The bar is there, but the gain per run is not stated. UI only, no balance change. |
| F4 | **No Strength nerf.** Keep `STRENGTH_DAMAGE_BASELINE` 3 and +1 damage per 2 Strength | — | Measured: Strength-only is worse than mixed builds. Revisit only if real players report one-shot builds after classes and abilities ship. |
| F5 | Make **Armor** worth a point: +2 armor per point at base, or armor reduces damage by 1 per 4 armor | `CombatRules.STAT_GROWTH["armor"]` or `resolve_attack()` | Armor is the weakest stat per point and the tank build cannot finish fights. Measure with `allocation=tank`. Target: out-of-energy rate below 15%. |
| F6 | L5–9 is too easy (92% completed) | `DungeonGenerator.monster_points_per_level` (2.0 → 2.5) or the monster level ranges | Already a known item in `release-readiness.md`. Measure with `monster_points=2.5`. It speeds the 5–9 stretch less than it shortens it, so check that L10 stays near 25 runs. |
| F7 | Add a **Life-first starting tip** to the level-1 hint, e.g. "Life and Strength are good first picks" | `LEVEL_HINT_START_POINTS` | The worst new-player mistake measured is putting all 5 starting points in one stat (Strength-only L1: 14% deaths). Copy change only. |

To reproduce:

```bash
godot --headless --path . -s res://tools/analyze_balance.gd
for s in default strength balanced tank; do
  godot --headless --path . -s res://tools/playtest.gd -- runs=40 games=6 seed=1 dir=user://dng15_$s allocation=$s
done
```

Each run of 6 × 40 takes about 10–15 minutes of CPU. Use a distinct `dir=` per parallel run so the save files do not collide.
