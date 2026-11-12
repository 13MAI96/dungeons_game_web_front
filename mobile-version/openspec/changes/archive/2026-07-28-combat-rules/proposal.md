## Why

Monster encounters currently use fixed placeholder attacks. The mobile version needs to apply the combat, damage, counterattack, and experience rules already defined in the existing web game so dungeon encounters behave consistently across implementations.

## What Changes

- Add a reusable GDScript combat rules layer based on the web `GameComponent.attackMonster()` and `Player` model behavior.
- Replace placeholder basic/heavy attack handling in dungeon encounters with rule-driven combat resolution.
- Apply player energy consumption, hit checks, critical hits, monster damage, counterattacks, life loss, monster defeat, and experience gain.
- Preserve encounter state so defeated monsters remain cleared and fled monsters can reappear.
- Extend dungeon location handling for non-monster encounter outcomes that already exist in the web game, including sanctuary recovery and quest/treasure-style resolution where applicable.
- Add focused headless tests for deterministic combat outcomes.

## Capabilities

### New Capabilities
- `combat-rules`: Defines reusable player, monster, damage, counterattack, energy, recovery, and experience behavior for dungeon encounters.

### Modified Capabilities
- `monster-encounter`: Replaces placeholder attack outcomes with combat-rule outcomes during active monster encounters.
- `dungeon-exploration`: Adds rule-driven handling for special dungeon location types encountered during exploration.

## Impact

- Godot scripts under `res://scripts`, likely including a new combat service/rules script and updates to `main.gd`.
- Existing dungeon encounter scene/actions in `res://scenes/main.tscn`.
- Localization resources for combat result feedback if messages are surfaced.
- Headless Godot tests for combat resolution and affected exploration behavior.
