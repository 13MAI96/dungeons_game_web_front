## 1. Progression Conversion

- [x] 1.1 Update the experience threshold formula so level 1 requires 100 experience and levels through 10 increase by 100.
- [x] 1.2 Add player state for reserved progression points, selected class, and selected simple abilities.
- [x] 1.3 Implement a helper to calculate every available level-up from current experience without clamping experience.
- [x] 1.4 Convert every available level-up into reserved progression points when progression opens.
- [x] 1.5 Keep unassigned reserved points available across progression sessions.
- [x] 1.6 Preserve death sequel clearing during converted level-ups.

## 2. Allocation UI

- [x] 2.1 Replace fixed allocation with reserve-backed staged allocation.
- [x] 2.2 Render each assignable stat as a stat-bar row with the staged point count on the right.
- [x] 2.3 Add plus and minus controls for life, energy, mana, armor, speed, and strength.
- [x] 2.4 Prevent staged points from exceeding the reserve and prevent negative per-stat allocation.
- [x] 2.5 Update displayed stat values as staged points change before confirmation.
- [x] 2.6 Confirm one or more staged points, apply stat increases, subtract spent points from reserve, and keep any remaining reserve.
- [x] 2.7 Add or adjust localization for progression reserve, allocation rows, and class choice.

## 3. Player Abilities JSON

- [x] 3.1 Add `data/player_abilities.json` with active and passive ability definitions.
- [x] 3.2 Include id, name, unlock level, type, active flag, energy cost, mana cost, class requirements, simple-skill group, and effect ids in each ability.
- [x] 3.3 Implement an ability loading and validation helper.
- [x] 3.4 Filter abilities by player level and selected class.
- [x] 3.5 Enforce one simple ability per unlock level when multiple simple abilities unlock together.
- [x] 3.6 Keep active ability costs available to combat and action UI.

## 4. Player Classes JSON

- [x] 4.1 Add `data/player_classes.json` with mage, knight, and thief class definitions.
- [x] 4.2 Include class progression stat growth, automatic increment cadence, and automatic stat increments.
- [x] 4.3 Implement a class loading and validation helper.
- [x] 4.4 Show class choice at level 10 when no class is selected.
- [x] 4.5 Store the selected class in runtime player state.
- [x] 4.6 Apply fixed 3-point level conversion, class stat growth, and automatic increments during progression.

## 5. Verification

- [x] 5.1 Add or update tests for the 100-point level 1 threshold and later threshold behavior.
- [x] 5.2 Add or update tests for multi-level conversion and reserved unassigned points.
- [x] 5.3 Add or update tests for plus/minus allocation bounds and partial confirmation.
- [x] 5.4 Add tests for player ability JSON schema and availability filtering.
- [x] 5.5 Add tests for simple ability exclusivity.
- [x] 5.6 Add tests for class JSON schema, level-10 class choice, and class progression conversion.
- [x] 5.7 Run the Godot headless project load and affected verification scripts.
- [x] 5.8 Run `openspec validate "leveling-player"`.
