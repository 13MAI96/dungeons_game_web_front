## MODIFIED Requirements

### Requirement: Experience accumulates across dungeon runs
The mobile game SHALL maintain permanent experience as a cumulative total across completed or voluntarily exited dungeon runs.

#### Scenario: Consecutive dungeons grant experience
- **WHEN** the player completes or retreats from a dungeon with provisional experience
- **THEN** that experience is added to the permanent total
- **AND** experience committed by earlier dungeon runs remains in the total

#### Scenario: A failed dungeon follows successful runs
- **WHEN** the player loses life or energy after accumulating permanent experience in earlier runs
- **THEN** only experience gained during the failed active run is discarded
- **AND** the earlier permanent experience remains unchanged
