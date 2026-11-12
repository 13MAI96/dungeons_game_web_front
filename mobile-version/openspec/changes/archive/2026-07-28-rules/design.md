## Context

The mobile version currently has one compact `CombatRules` script and runtime UI construction in `main.gd`. Existing rules still resemble the early web prototype: player damage is a stat, attacks compare roll plus damage against armor, rest consumes mana, sanctuary restores life and energy, dungeon depletion restores the player after ejecting them, and dungeon size is based on the previous generator range.

The new rules redefine core game behavior across player state, dungeon run state, combat resolution, monster data, dungeon generation limits, completion rewards, and encounter feedback. These changes should remain testable without launching the editor, because most behavior can be verified through headless GDScript tests.

## Goals / Non-Goals

**Goals:**
- Centralize player defaults, progression thresholds, run rewards, and death penalties in rule helpers.
- Replace old attack math with the new D20, armor, strength, speed, dodge, and critical-hit model.
- Track dungeon-run state needed for completion rewards, defeated monster counts, and automatic exit.
- Keep UI code responsible for presentation only: stat order, roll text, completion feedback, and D20 visual display.
- Keep generated dungeon size capped by player level while the visible map viewport remains 5 by 7.

**Non-Goals:**
- Define the final attack catalogue or exact attack damage values beyond a minimal default attack needed to keep combat functional.
- Implement inventory, consumibles, potions, shop levels, save deletion persistence, or level-up stat growth beyond the requested thresholds and death-sequel behavior.
- Redesign encounter art or exploration layout outside the rule-driven data now required.

## Decisions

1. Keep rule calculations in GDScript services, not in UI callbacks.

   `CombatRules` should own attack resolution, rest, treasure, sanctuary, retreat, completion, death, and restoration calculations. A new or expanded progression helper can expose level and reputation threshold functions. `main.gd` should call these helpers and update views from returned structured results.

   Alternative considered: embed each rule directly in button handlers. That would be faster for a single screen but would make dice, completion rewards, and failure behavior harder to test and reuse.

2. Represent player damage through attacks while adding `strength` and `speed` as player stats.

   The player state should no longer expose `damage` as a persistent stat bar. It should expose `strength` and `speed`, and combat should resolve through an attack definition. Until a full attack system exists, use one default attack definition to preserve the existing fight button behavior.

   Alternative considered: keep `damage` temporarily and hide it. That would preserve old data shape but would allow old formulas to survive invisibly.

3. Preserve dungeon-run counters separately from permanent player state.

   A run should track monsters defeated, total monsters, experience earned during the run, reputation earned on completion, and whether completion occurred. On death or energy depletion, current run experience is lost. On full completion, reputation equals defeated monster count and the app exits automatically after feedback.

   Alternative considered: infer completion from map state every frame only. That is useful for validation, but explicit run counters make completion feedback and rewards easier to verify.

4. Generate dungeon size from player level constraints.

   Before level 10, generated dungeons should fit the current 5 by 7 maximum. At level 10 and above, generated dungeons may expand up to 25 by 25. Rendering still uses the existing 5 by 7 window around the player.

   Alternative considered: always generate large dungeons and hide most of them. That would make early runs too energy-expensive and would violate the level-gated maximum.

5. Add D20 roll display as encounter state.

   Combat results should include player roll and defender dodge roll when used. The encounter view should render those values below the corresponding actor stats and load an updated `d20.svg` visual where the main face can display the rolled value.

   Alternative considered: only write rolls into text feedback. The requested visual calls for dice values tied to each combatant, so explicit UI nodes are clearer.

## Risks / Trade-offs

- Existing tests expect web-derived combat values → Update tests alongside specs and keep focused compatibility only where behavior is unchanged.
- Random rest percentages and dice rolls can make tests flaky → Allow rule helpers to accept injected rolls/percentages for deterministic tests.
- Save deletion when life reaches 0 has no persistence layer yet → Represent it as an in-memory deleted/save-invalid state and defer durable save handling.
- Future attack definitions are not finalized → Implement a minimal default attack contract and leave attack catalogue expansion explicit for a later change.
