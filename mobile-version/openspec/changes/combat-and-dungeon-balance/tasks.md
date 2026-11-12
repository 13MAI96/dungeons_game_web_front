## 1. Combat Formulas

- [x] 1.1 Make Strength increase attack accuracy.
- [x] 1.2 Add a fixed attack difficulty to preserve uncertain low-level combat.
- [x] 1.3 Replace percentage dodge with an opposed Speed check.
- [x] 1.4 Preserve critical-hit armor and dodge bypass.

## 2. Resources

- [x] 2.1 Reject attacks without sufficient energy.
- [x] 2.2 Reject attacks without sufficient mana.
- [x] 2.3 Preserve resources when an attack is rejected.
- [x] 2.4 Prevent generic energy and mana consumption from producing negative values.

## 3. Dungeon Generation

- [x] 3.1 Add traversable empty locations.
- [x] 3.2 Generate 5-7 monsters at level 1 and 25-35 percent monster density from level 10.
- [x] 3.3 Keep quests, sanctuaries, blocks, and objectives reachable.
- [x] 3.4 Preserve random post-level-10 dimensions from 5 by 5 through 25 by 25.

## 4. Verification

- [x] 4.1 Test that Strength improves accuracy.
- [x] 4.2 Test energy and mana attack rejection.
- [x] 4.3 Test low-level monster density and empty cells.
- [x] 4.4 Run deterministic before-and-after balance simulations.
- [x] 4.5 Run all Godot headless verification scripts.
- [x] 4.6 Run `openspec validate "combat-and-dungeon-balance"`.
