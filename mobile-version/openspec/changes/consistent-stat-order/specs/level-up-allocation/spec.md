## MODIFIED Requirements

### Requirement: Player can allocate level-up points
The mobile game SHALL allow the player to allocate reserved progression points to permanent statistics using reversible plus/minus controls before confirmation.

#### Scenario: Pending points are available for allocation
- **WHEN** the player has reserved progression points
- **THEN** the allocation view shows the number of remaining points
- **THEN** the allocation view shows life, energy, mana, armor, strength, and speed as assignable statistics, in that order
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
