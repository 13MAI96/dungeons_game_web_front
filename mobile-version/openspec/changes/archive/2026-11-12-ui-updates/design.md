## Context

The mobile UI already builds several runtime controls in `scripts/main.gd`: stat bars, combat overlays, roll labels, and the progression allocation view. Combat result dictionaries from `CombatRules` expose enough state to distinguish hit, miss, critical, dodge, flee, depletion, and selected monster attacks, but the encounter currently favors raw roll readouts and immediate view changes.

This change keeps the current single-scene approach and improves feedback where the player needs better context: pending progression points, combat outcomes, forced dungeon exits, and monster attack inspection.

## Goals / Non-Goals

**Goals:**
- Show a pending-progression indicator when reserved progression points exist.
- Replace raw dice text under stats with readable combat outcome feedback.
- Include monster attack name and result in counterattack/flee-failure feedback.
- Allow a last-energy retreat from the entrance to exit alive.
- Show a short notification before returning to the new game view after life or energy depletion.
- Add a monster info button that shows attacks in a tooltip or modal.

**Non-Goals:**
- Redesign the full encounter layout.
- Change D20 combat math.
- Add new monster attack effects or resolve existing effect ids.
- Persist UI notification history.
- Replace the current runtime-created UI pattern with a larger scene refactor.

## Decisions

1. Build the progression indicator as a small runtime `Control` attached to the progression/manage button.

   The existing UI already creates runtime controls for added features, and the indicator only depends on `player_state.reserved_progression_points`. Updating it from `_apply_player_stats()` and view transitions keeps the badge synchronized after allocation, dungeon exits, and progression conversion.

   Alternative considered: change `main.tscn` directly. That is acceptable, but a runtime node keeps this small and consistent with existing dynamic UI.

2. Use encounter feedback text as the primary combat explanation surface.

   The app should remove raw roll labels from below actor stats and compose readable messages from combat result flags: player hit/critical/miss/dodge, monster attack name, counterattack hit/critical/miss/dodge, and flee failure counterattack. This preserves combat transparency without crowding the stat panels.

   Alternative considered: keep both raw rolls and summaries. The request explicitly says roll values are not necessary under stats.

3. Delay forced dungeon exits through a short notification path.

   `_exit_dungeon_if_player_depleted()` should support showing a feedback overlay or message before clearing dungeon state and returning to the new game view. Successful retreat from the entrance should bypass depletion failure handling even if it spends the last energy point.

   Alternative considered: keep immediate exit and set text on the new game view. That risks the player missing the reason for the transition.

4. Use a lightweight modal for monster attack information.

   A modal is more reliable than a hover tooltip on mobile. The info button should sit over or near the monster image, and the modal should list attack name, mana cost, damage, unlock level, and effect ids when present.

   Alternative considered: tooltip-only behavior. Tooltips are less discoverable and less reliable on touch devices.

5. Resolve critical hit damage from the selected attack definition.

   Player abilities and monster attacks should define `critical_threshold` and `critical_damage_percent`. Combat resolution treats a D20 roll greater than or equal to the threshold as critical, bypasses armor and dodge as before, and calculates final damage from the attack's base damage plus the configured extra critical percent, rounded down.

   Alternative considered: keep natural 20 as the only critical rule. That does not support attacks with wider or weaker/stronger critical behavior.

## Risks / Trade-offs

- [Risk] Delayed dungeon exits can leave controls active during the notification. -> Mitigation: disable relevant action buttons or ignore new actions while an exit is pending.
- [Risk] Combat summaries can become ambiguous when both player and monster outcomes happen in one turn. -> Mitigation: compose feedback in a stable order: player attack first, monster counterattack second.
- [Risk] Monster attack modal can overflow on small screens for monsters with many attacks. -> Mitigation: use compact labels in a constrained modal container.
- [Risk] The progression indicator can desync if points change outside progression. -> Mitigation: update it wherever player stats/action views are refreshed.
- [Risk] Missing critical metadata in older attack data can produce inconsistent combat. -> Mitigation: provide defaults in normalization and require explicit fields in JSON tests.
