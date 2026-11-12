# level-up-allocation Specification

## Purpose
Describe how players spend progression points when a level-up is available.
## Requirements
### Requirement: Player can allocate level-up points
The mobile game SHALL allow the player to allocate reserved progression points to permanent statistics using reversible plus/minus controls before confirmation.

#### Scenario: Pending points are available for allocation
- **WHEN** the player has reserved progression points
- **THEN** the allocation view shows the number of remaining points
- **THEN** the allocation view shows life, energy, mana, armor, speed, and strength as assignable statistics
- **THEN** each assignable statistic is displayed with the same stat-bar format used by player statistics
- **THEN** each row shows the number of staged points for that statistic on the right

#### Scenario: Allocation changes are staged before confirmation
- **WHEN** the player selects plus for a statistic while reserved points remain
- **THEN** the staged allocation for that statistic increases by 1
- **THEN** the remaining unassigned points decreases by 1
- **THEN** the displayed stat value updates to include the staged increase
- **THEN** the permanent player statistic is not changed until confirmation

#### Scenario: Allocation can be reduced before confirmation
- **WHEN** the player selects minus for a statistic with staged points
- **THEN** the staged allocation for that statistic decreases by 1
- **THEN** the remaining unassigned points increases by 1
- **THEN** the staged allocation for that statistic never goes below 0

#### Scenario: Confirmed allocation is permanent
- **WHEN** the player confirms an allocation using one or more reserved progression points
- **THEN** the selected stat increases are applied to the player's permanent maximum statistics
- **THEN** spent progression points are removed from the player's reserve
- **THEN** any unspent reserved progression points remain available
- **THEN** the confirmed allocation cannot be reassigned

#### Scenario: Allocation cannot exceed reserve
- **WHEN** the staged allocation total equals the player's reserved progression points
- **THEN** plus actions are disabled or unavailable for every statistic

#### Scenario: Incomplete allocation cannot be confirmed
- **WHEN** the player has reserved progression points
- **AND** no progression points are staged
- **THEN** allocation confirmation is disabled or unavailable

### Requirement: Level-up stat points apply fixed growth values
The mobile game SHALL apply rule-defined stat growth values for each allocated improvement point unless the selected class progression overrides the conversion in a future rule.

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

