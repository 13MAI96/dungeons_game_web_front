## Method

Every change was measured with `tools/playtest.gd`, which drives the real main scene: path-finding toward unexplored cells and living monsters, resting below 50% life, fleeing at 30% life, returning to retreat when energy is close to the distance home. Runs are classified as completed, retreated, energy-out, died or stuck, per player-level band.

## Decisions

1. **Strength adds damage** rather than raising base damage further: it keeps level-1 balance unchanged (bonus 0 at strength 3) and gives Strength points a visible effect; it applies to monsters too, so monster growth stays meaningful.
2. **Monster growth stays at 2 points per level.** 3 points made level 10+ unwinnable (4% completed, 25% died); 2.5 still gave 17% deaths at level 10+. Mid-game (levels 5–9) is easy (~87% completed): accepted as a power phase.
3. **One monster-count formula for all levels** instead of density: completion requires defeating every monster, so the count must stay bounded; larger maps add exploration instead.
4. **Threshold growth read as a percentage.** The previous code read "10 percent + level / 10" as 0.10 + 1.1 (120% per level), making level 15 require ~79,000 XP. The percentage reading gives ~11% per level.

## Risks

- The bot is one play style; human players will differ. `tests/verify_balance.gd` uses loose bounds (≥15% completed, ≤15% deaths, level 2 within 10 runs) to catch regressions, not to pin exact numbers.
