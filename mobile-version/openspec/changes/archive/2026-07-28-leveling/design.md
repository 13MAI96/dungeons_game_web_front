## Context

The mobile version currently has rule helpers for experience and reputation thresholds, base player stats, monster templates, and dungeon generation. Experience can be gained during completed dungeons, but reaching a threshold does not yet create a level-up flow, pending improvement points, permanent stat growth, or scaled monster generation.

This change crosses player progression, monster generation, JSON monster data, and the new-game action menu. The implementation should remain local to `mobile-version` and testable through headless GDScript scripts.

## Goals / Non-Goals

**Goals:**
- Track level-up eligibility without capping current experience at the required threshold.
- Grant 3 pending improvement points per level-up event and allow the player to allocate them once.
- Apply fixed stat growth values for life, energy, mana, armor, speed, and strength.
- Keep reputation level-up automatic and behavior-neutral.
- Generate monster levels based on player level and scale monster stats by random point assignment.
- Filter monster attacks by unlock level.
- Expose the point-allocation flow from the manage equipment action.

**Non-Goals:**
- Define player attack or ability unlock rules.
- Add inventory, equipment items, shop effects, or persistence beyond the current runtime state model.
- Implement point respecs or undo after confirming an allocation.
- Redesign the full new-game menu beyond the allocation entry point and any required action rename.

## Decisions

1. Store pending level-up state on the player dictionary.

   The current rules use a dictionary returned by `CombatRules.create_default_player()`, and existing UI reads directly from that runtime state. Adding fields such as `pending_level_points`, `unassigned_level`, and current/permanent max stats keeps the change aligned with the existing prototype and easy to verify in GDScript tests.

   Alternative considered: introduce dedicated player classes/resources. That would be cleaner long term but broader than this change and inconsistent with the current scripts.

2. Treat the experience threshold as an eligibility value, not a cap.

   Experience bars may use the threshold as a display maximum, but player current experience remains allowed to exceed it. Level-up checks should compare `current_experience >= experience_next_level` and should not clamp or discard overflow.

   Alternative considered: subtract threshold experience on level-up. The current request says the maximum is what is required to level up, not a limit, so overflow should remain visible unless a later change defines spending or rollover.

3. Confirm stat allocations in one irreversible transaction.

   The allocation UI should let the player distribute the 3 points before confirming. Once confirmed, the selected stats are applied permanently, points are cleared, and the decision cannot be changed.

   Alternative considered: apply every tap immediately. That is simpler, but it makes accidental taps irreversible without a confirmation affordance.

4. Use one stat-growth function for player and monster scaling.

   The same point values apply to both players and monsters: life +5, energy +5, mana +4, armor +1, speed +1, strength +1. Monster generation should reuse the same growth table to avoid drift.

   Alternative considered: duplicate player and monster growth logic. That would be faster to write but makes future balancing changes risky.

5. Generate monster levels before stat scaling.

   Dungeon generation should choose a monster level from the allowed range based on player level, then create the base monster from JSON, then assign `2 * (monster_level - 1)` random stat points to scale it.

   Alternative considered: scale by formulas per stat. Random point assignment matches the requested rule and creates stat variance between monsters of the same level.

6. Add `unlock_level` to monster attack definitions.

   The monster JSON already owns attack definitions. Adding `unlock_level` there keeps monster attack availability data-driven. Missing unlock levels should default to 1 for compatibility.

   Alternative considered: store unlocks in a separate attack table. That may be useful later for shared attacks, but current monster attacks are template-local.

## Risks / Trade-offs

- [Risk] Experience overflow and repeated eligibility could accidentally grant multiple levels in one check. → Mitigation: define and test whether a level-up check processes one level at a time; this change should grant 3 points when the current level reaches its threshold and leave further automatic chaining for a later explicit rule.
- [Risk] Random monster stat allocation can make tests flaky. → Mitigation: allow dungeon generation helpers to accept seeded `RandomNumberGenerator` values and assert ranges/totals instead of exact distributions where needed.
- [Risk] Irreversible point allocation can frustrate users if the UI is unclear. → Mitigation: use a staged allocation with visible remaining points and a confirm action.
- [Risk] Manage equipment naming may affect localization keys. → Mitigation: keep existing action behavior compatible and update localization only if the visible label changes.
