## ADDED Requirements

### Requirement: Player can allocate level-up points
The mobile game SHALL allow the player to allocate pending level-up improvement points to permanent statistics.

#### Scenario: Pending points are available for allocation
- **WHEN** the player has pending level-up improvement points
- **THEN** the allocation view shows the number of remaining points
- **THEN** the allocation view shows life, energy, mana, armor, speed, and strength as assignable statistics

#### Scenario: Allocation changes are staged before confirmation
- **WHEN** the player selects a statistic while points remain
- **THEN** the staged allocation for that statistic increases by 1
- **THEN** the remaining unassigned points decreases by 1
- **THEN** the permanent player statistic is not changed until confirmation

#### Scenario: Confirmed allocation is permanent
- **WHEN** the player confirms an allocation using all pending points
- **THEN** the selected stat increases are applied to the player's permanent maximum statistics
- **THEN** pending level-up improvement points are cleared
- **THEN** the confirmed allocation cannot be reassigned

#### Scenario: Incomplete allocation cannot be confirmed
- **WHEN** the player has unassigned pending level-up improvement points
- **THEN** the allocation confirmation action is disabled or unavailable

### Requirement: Level-up stat points apply fixed growth values
The mobile game SHALL apply rule-defined stat growth values for each allocated improvement point.

#### Scenario: Life point increases maximum life
- **WHEN** the player confirms 1 allocated point in life
- **THEN** maximum life increases by 5
- **THEN** current life increases by 5 unless the player is in a dungeon run

#### Scenario: Energy point increases maximum energy
- **WHEN** the player confirms 1 allocated point in energy
- **THEN** maximum energy increases by 5
- **THEN** current energy increases by 5 unless the player is in a dungeon run

#### Scenario: Mana point increases maximum mana
- **WHEN** the player confirms 1 allocated point in mana
- **THEN** maximum mana increases by 4
- **THEN** current mana increases by 4 unless the player is in a dungeon run

#### Scenario: Combat stat points increase permanent stats
- **WHEN** the player confirms allocated points in armor, speed, or strength
- **THEN** each armor point increases maximum armor by 1
- **THEN** each speed point increases maximum speed by 1
- **THEN** each strength point increases maximum strength by 1
