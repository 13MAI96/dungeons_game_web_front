## ADDED Requirements

### Requirement: Low energy is warned before it ends the run
The dungeon exploration view SHALL warn the player once per dungeon run when current energy drops to 25 percent of maximum energy or below, before energy runs out.

#### Scenario: Energy drops to the warning threshold
- **WHEN** an action during a dungeon run leaves current energy above zero and at or below the larger of 1 and 25 percent of maximum energy, rounded up
- **THEN** the app shows a low energy warning with the remaining energy and the provisional dungeon experience at risk
- **THEN** the warning advises returning to the entrance and retreating to keep that experience

#### Scenario: Warning is shown once per run
- **WHEN** the low energy warning was already shown in the current dungeon run
- **AND** energy drops further without reaching zero
- **THEN** the app does not show the warning again

#### Scenario: Resumed run keeps the warning state
- **WHEN** a run in which the warning was shown is saved and later resumed
- **THEN** the app does not show the warning again in that run

## MODIFIED Requirements

### Requirement: Dungeon depletion exits are explained before menu return
The dungeon exploration view SHALL notify the player before returning to the new game view when the dungeon run ends because life or energy was depleted, stating how much provisional dungeon experience was lost.

#### Scenario: Energy depletion notification appears
- **WHEN** the player's current energy reaches zero or less during a dungeon run for any reason other than a successful retreat from the entrance
- **THEN** the app shows an energy depleted notification before returning to the new game view
- **THEN** the player loses current experience gained during the dungeon run
- **THEN** the notification states the amount of dungeon experience lost when it is greater than zero

#### Scenario: Life depletion notification appears
- **WHEN** the player's current life reaches zero or less during a dungeon run
- **THEN** the app shows a life depleted notification before returning to the new game view
- **THEN** the player loses current experience gained during the dungeon run
- **THEN** the notification states the amount of dungeon experience lost when it is greater than zero
- **THEN** the player receives the dungeon death sequel

#### Scenario: Successful last-energy retreat does not show defeat notification
- **WHEN** the player retreats from the dungeon entrance
- **AND** retreat spends the player's last current energy point
- **THEN** the app exits the dungeon alive
- **THEN** the app does not show an energy depleted defeat notification
