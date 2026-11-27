## MODIFIED Requirements

### Requirement: Expedition outcomes remain visible
The mobile game SHALL show a final result when an expedition reaches a stable end. The retreat result SHALL say how much dungeon experience was kept and how far the next level is.

#### Scenario: Expedition ends
- **WHEN** the player completes a dungeon, retreats, runs out of energy, is defeated, or reaches terminal game over
- **THEN** a localized result title and summary are displayed
- **AND** the result remains visible until the player selects Continue

#### Scenario: Retreat summarises the experience kept
- **WHEN** the player retreats from the entrance with dungeon experience earned in the run
- **THEN** the result says that the player returned safely
- **AND** it shows the dungeon experience kept, for example "You kept +47 experience from this run." ("Te llevás +47 de experiencia de esta expedición." in Spanish)
- **AND** it shows the total experience against the next level threshold and how much is missing, for example "Total experience: 67 / 100 (33 more for level 2)."

#### Scenario: Retreat without experience
- **WHEN** the player retreats from the entrance without dungeon experience
- **THEN** the result says that no experience was earned in this run

#### Scenario: Retreat reaches the next level
- **WHEN** the total experience after retreating reaches the next level threshold
- **THEN** the result shows the total experience and says that the player can level up in Progression
