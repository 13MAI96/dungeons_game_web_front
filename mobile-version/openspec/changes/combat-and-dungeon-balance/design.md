## Context

Deterministic analysis of 1000 generated dungeons found an average of 22.15 monsters at level 1 and a theoretical minimum attack cost of 44.31 energy against 25 starting energy. Increasing Strength from 3 to 8 reduced hit rate from 57.7 percent to 32.7 percent, while Speed 3 produced no dodges.

## Goals / Non-Goals

**Goals:**
- Make offensive and defensive attributes beneficial.
- Let early players make partial progress and choose retreat.
- Make completion difficult but reachable through allocation, recovery, routing, and luck.
- Prevent resource values from becoming negative through unaffordable attacks.

**Non-Goals:**
- Make first-run completion consistently easy.
- Finalize experience rewards or stat-growth values.
- Add attack selection UI.

## Decisions

1. Resolve normal hits from half-scaled Strength and Armor.

   Effective attributes are `floor(attribute / 2)`. The required roll is `clamp(10 + effective armor - effective strength, 3, 19)`, and critical thresholds cannot be lower than 3, keeping hit chance between 10 and 90 percent. Each raw attribute point is worth about 2.5 percentage points over time.

2. Resolve dodge from half-scaled attacker and defender Speed.

   The required roll is `clamp(20 + effective attacker speed - effective defender speed, 14, 20)`, keeping dodge chance between 5 and 35 percent. Critical hits still bypass dodge.

3. Require the complete attack cost before combat resolution.

   Rejected attacks do not spend partial resources and do not trigger a monster counterattack.

4. Populate maps from level-specific targets.

   Level 1 generates 5-7 monsters, one quest, one sanctuary, a small number of blocks, and empty traversal cells. From level 10 onward, a random 25-35 percent of all cells contain monsters, making 25 percent the guaranteed minimum while preserving unfavorable variation. Required objectives are kept reachable by clearing blocks along routes from the entrance.

5. Preserve full post-level-10 map-size variance.

   From level 10 onward, each dimension is sampled independently from 5 through 25. Large unfavorable layouts combine travel cost with proportional monster density and are expected to force retreat until the player is sufficiently developed.

## Risks / Trade-offs

- Early completion remains demanding and depends strongly on initial point allocation.
- Sparse large maps can consume substantial movement energy by design; players must evaluate layout risk and retreat when necessary.
- Existing experience pacing may be slow when players repeatedly retreat after only a few kills.
