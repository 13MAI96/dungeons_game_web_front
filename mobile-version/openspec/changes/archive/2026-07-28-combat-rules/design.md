## Context

The mobile app already supports dungeon exploration and switches to an encounter view when the player enters a living monster location. Combat is currently placeholder logic with fixed basic/heavy damage.

The web reference defines the relevant behavior in `src/app/components/game/game.component.ts` and `src/app/models/player.ts`:
- Monster attack consumes 2 energy.
- Attack roll is `random * 20 + player.current_damage`.
- A roll equal to 20 is treated as a critical hit that deals `player.damage * 2`.
- A roll greater than monster armor deals `player.damage`.
- If the monster dies, the location is marked visited and the player gains monster experience.
- If the monster survives a successful hit, the monster can counterattack with `random * 20 + monster.damage`; it hits when greater than player armor.
- On a poor player roll below monster damage, the monster hits the player.
- Rest consumes 10 mana and restores 20% energy and life.
- Sanctuary locations restore 50% energy and life.
- Quest/treasure locations consume energy and either grant experience or hurt the player based on the player vision/level formula.

## Goals / Non-Goals

**Goals:**
- Port the web combat and location outcome rules into small, testable GDScript services.
- Replace placeholder encounter attacks with one rule-driven attack action.
- Keep player and monster state dictionaries compatible with the current mobile UI.
- Make random outcomes injectable or deterministic enough for headless tests.
- Apply defeat, experience, player damage, rest, sanctuary, and quest/treasure outcomes in dungeon exploration.

**Non-Goals:**
- Final combat balancing beyond matching the current web rules.
- Inventory, equipment, skills, status effects, or a full level-up flow.
- Backend persistence or network synchronization.
- Final combat result art, animation, or sound.

## Decisions

1. Add a dedicated GDScript rules script.

   Create `res://scripts/combat_rules.gd` with pure functions for attack resolution, rest, sanctuary recovery, and quest/treasure resolution. This keeps web-derived formulas isolated from `main.gd` UI code and allows tests to exercise rules directly. Embedding formulas in `main.gd` was considered, but it would make later balancing and test coverage harder.

2. Keep the current dictionary-based data model for this change.

   The existing mobile prototype stores player and monster stats as dictionaries and already renders those values. A class-based player model was considered, but porting the full web `Player` class would broaden the change beyond combat behavior. The rules script can operate on dictionaries with field names aligned to the web model: `life`, `current_life`, `energy`, `current_energy`, `mana`, `current_mana`, `armor`, `current_armor`, `damage`, `current_damage`, `experience`, `current_experience`, `experience_next_level`, `level`, and `vision`.

3. Use an injectable random number source.

   Combat and quest outcomes depend on random rolls. The rules script should accept an optional `RandomNumberGenerator` or explicit roll values in tests so headless tests can assert hit, miss, critical, counterattack, and reward cases. Direct calls to global randomness inside UI handlers were considered, but deterministic tests would be brittle.

4. Replace basic/heavy attacks with the web attack rule.

   The current two buttons represent placeholder attacks. The mobile encounter should use the web "Fight" rule as the first real combat action. If the scene keeps multiple buttons temporarily, both must resolve through the same combat function or the extra placeholder action should be removed during apply.

5. Model result messages without coupling to UI implementation.

   Rule functions should return a compact result dictionary such as `hit`, `critical`, `monster_defeated`, `counterattack_hit`, `player_defeated`, `experience_gained`, and `message_key`. `main.gd` can decide how to display those results now or later.

## Risks / Trade-offs

- Web rule uses `resultado == 20` with a floating random expression, so exact critical hits are unlikely. → Preserve observable intent by treating an explicit roll of 20 as critical when deterministic rolls are supplied, and document the formula used.
- The mobile player currently has simplified stats. → Normalize player dictionary fields during startup so combat rules have the current/max values they need.
- Quest/treasure behavior was previously not surfaced in mobile. → Add minimal functional resolution without introducing new screens; mark resolved locations visited and update player state.
- Removing the extra placeholder attack may affect tests and translations. → Update encounter tests and localization in the same apply step.
