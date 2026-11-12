## Context

The current mobile progression system grants fixed pending level-up points once the player reaches the current experience threshold. The progression view can stage and confirm those points, while monster abilities already use JSON data with unlock levels. Player abilities and classes are still implicit in code or deferred.

This change introduces a broader player progression model: experience thresholds start at 100, the player may have enough experience to gain multiple levels at once, progression points can be converted and reserved, abilities are loaded from JSON, and classes become selectable at level 10 with their own progression conversion rules.

## Goals / Non-Goals

**Goals:**
- Change the first player level threshold to 100 experience and keep later thresholds based on the updated formula.
- Convert all currently available level-ups into assignable progression points when entering progression.
- Allow unassigned converted points to remain in reserve.
- Replace one-way point staging with plus/minus allocation controls.
- Store player abilities in JSON with unlock conditions, class gates, active/passive type, and energy/mana costs.
- Store player classes in JSON with point conversion and automatic stat increment cadence.
- Let the player choose one class at level 10.

**Non-Goals:**
- Implement full runtime resolution for every passive ability effect.
- Define future player attack/ability balancing beyond data shape and unlock filtering.
- Add save persistence for progression data beyond the current runtime player state.
- Add equipment or shop changes.

## Decisions

1. Use separate JSON files for player abilities and player classes.

   `data/player_abilities.json` should own ability definitions, while `data/player_classes.json` should own class definitions and progression conversion rules. This mirrors monster data and keeps balance changes out of GDScript.

   Alternative considered: keep abilities/classes as constants in `CombatRules`. That is faster initially but makes balancing harder and contradicts the requested data-driven model.

2. Convert level-ups into a reserve when progression opens.

   When the player enters progression, the system should calculate how many levels can be gained from current experience, advance those levels, convert them to points using the active class conversion rule, and store unassigned points in a reserve. If the player does not spend all points, the reserve remains available next time.

   Alternative considered: force all points to be assigned before leaving progression. The request explicitly allows assigning one or all points and reserving the rest.

3. Keep allocation mutable until confirmation.

   The progression view should allow plus/minus changes per stat between 0 and the reserve total. Confirm applies only the currently staged deltas, subtracts spent points from reserve, and leaves the rest unassigned.

   Alternative considered: immediately apply each plus click. That would require rollback behavior and make accidental input harder to recover from.

4. Gate class selection at level 10.

   Player class selection should remain unavailable before level 10. At level 10 or higher, if no class is selected, progression should expose class choices from JSON. Once selected, the class controls point conversion and automatic stat increments.

   Alternative considered: default every player to a class at level 1. That conflicts with the requested level 10 class choice.

5. Treat ability unlock filtering as data eligibility.

   Ability availability should be computed from player level, selected class, simple-skill exclusivity, and ability cost/type metadata. Active/passive execution can remain minimal until a future ability-effect change defines exact effects.

   Alternative considered: implement all effects now. The user described categories and metadata, not final effect semantics.

## Risks / Trade-offs

- [Risk] Multi-level conversion can accidentally loop forever if thresholds are not advanced correctly. → Mitigation: test multi-level conversion with known experience and thresholds.
- [Risk] Plus/minus allocation can desync staged points from reserve. → Mitigation: calculate staged totals from row state on every update and disable invalid actions.
- [Risk] Simple ability exclusivity can be ambiguous when multiple abilities unlock at the same level. → Mitigation: represent selected simple unlocks explicitly in player state and enforce one selected simple ability per unlock level.
- [Risk] Class progression rules may become too flexible for current UI. → Mitigation: define a small JSON schema now: id, name, point conversion, automatic increment cadence, and automatic increments.
