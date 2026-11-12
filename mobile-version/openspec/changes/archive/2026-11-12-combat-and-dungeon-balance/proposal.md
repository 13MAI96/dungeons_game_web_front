## Why

The current rules make Strength reduce accuracy, leave low Speed with effectively no dodge chance, allow attacks without sufficient resources, and generate more monsters than the player's energy can plausibly support. This prevents meaningful progression through partial early expeditions.

## What Changes

- Make Strength improve attack accuracy through an explicit base difficulty.
- Resolve dodge through an opposed D20 Speed check.
- Reject player attacks that cannot pay their full energy and mana costs.
- Generate sparse early dungeons, then populate at least 25 percent of level-10-and-higher maps with monsters.
- Preserve the intentionally wide random 5-by-5 through 25-by-25 size range from level 10 onward.
- Preserve a deliberately difficult early loop where players may defeat part of a dungeon and retreat before later completing it.

## Capabilities

### New Capabilities

### Modified Capabilities
- `attack-resolution-rules`: Replace attack and dodge formulas.
- `combat-rules`: Require full player attack resources before resolution.
- `dungeon-exploration`: Use bounded objective density and gradual map growth.

## Impact

- `scripts/combat_rules.gd` changes attack resolution and resource validation.
- `scripts/dungeon_generator.gd` changes map population and size scaling.
- Combat and generation tests cover the new invariants.
- `tools/analyze_balance.gd` provides deterministic regression metrics.
