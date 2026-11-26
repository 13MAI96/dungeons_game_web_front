## ADDED Requirements

### Requirement: Damage numbers float over the fighters
The monster encounter view SHALL float the result of each attack over the portrait of the fighter who received it, without blocking input or the game flow.

#### Scenario: Damage is shown as a number
- **WHEN** an attack by the player or the monster takes life from its target
- **THEN** a number with the life lost (for example "-3") appears over the target's portrait
- **THEN** the number rises and fades out in about 0.8 seconds
- **THEN** a critical hit shows the critical label with the number (for example "Critical! -6")

#### Scenario: An attack without damage shows its outcome
- **WHEN** an attack is dodged or blocked by armor
- **THEN** the outcome word ("Dodged" or "Blocked") floats over the target's portrait instead of a number

#### Scenario: Numbers stay readable over the damage overlay
- **WHEN** the player is hurt and the damage feedback overlay is shown
- **THEN** the player's damage number is drawn above the overlay
- **THEN** modals opened during the encounter are drawn above the numbers

#### Scenario: Numbers do not outlive the encounter
- **WHEN** the encounter view closes (victory, escape or depletion) or a new encounter starts
- **THEN** no floating number from the previous encounter remains on screen

#### Scenario: Numbers never delay actions
- **WHEN** fight or flee is triggered again while numbers are still floating
- **THEN** the action is resolved immediately

### Requirement: Fight log shows the last attacks
The monster encounter view SHALL show a fight log with the last four attacks of the current encounter, in plain language and with the damage dealt.

#### Scenario: Each attack is logged with its outcome and numbers
- **WHEN** the player attacks, or the monster attacks after an attack or a failed flee
- **THEN** the log adds one entry per attack with an outcome label (Hit, Critical!, Dodged or Blocked)
- **THEN** the entry names the monster, and the attack when it did no damage, and states the damage when it hit (for example "You hit Kobold for 3", "Kobold dodged your Strike", "Bat hit you with Bite for 2")
- **THEN** the damage in the entry equals the life the target lost

#### Scenario: Failed flee is logged
- **WHEN** the player fails to flee
- **THEN** the log adds an entry saying the escape failed, followed by the monster's attack

#### Scenario: Only the last entries are kept
- **WHEN** more than four attacks have been logged in the encounter
- **THEN** the log shows only the four most recent entries
- **THEN** entries are ordered from oldest at the top to newest at the bottom, and the newest stands out

#### Scenario: Log resets for a new encounter
- **WHEN** a monster encounter starts
- **THEN** the fight log is empty

#### Scenario: Log fits above the actions
- **WHEN** the log is full on a 1440x3088 or 1080x2220 portrait phone
- **THEN** the log does not overlap the player panel or the Fight and Flee buttons
- **THEN** the Fight and Flee buttons stay on screen

#### Scenario: Damage overlay names the attack
- **WHEN** the damage feedback overlay is shown because the monster hurt the player
- **THEN** the overlay text is the log entry of that attack, with the damage

## MODIFIED Requirements

### Requirement: Combat feedback explains outcomes
The monster encounter view SHALL show readable combat feedback instead of raw D20 roll readouts below actor statistics. The feedback uses only the outcomes the combat rules produce: critical hit, hit, dodged, and blocked (the attack roll did not beat the defender's armor). It SHALL NOT use jargon such as "was protected".

#### Scenario: Player attack result is explained
- **WHEN** the player performs an attack
- **THEN** the fight log and the floating feedback identify the player attack outcome as hit, critical hit, dodged, or blocked by armor
- **THEN** a hit or critical hit states the damage dealt

#### Scenario: Monster attack result is explained
- **WHEN** the monster performs a counterattack
- **THEN** the fight log identifies the monster and its attack name
- **THEN** the fight log identifies whether the monster attack hit, was a critical hit, was dodged, or was blocked by armor
- **THEN** a hit or critical hit states the damage taken

#### Scenario: Raw dice values are not shown under stats
- **WHEN** combat resolves player or monster rolls
- **THEN** the encounter view does not show raw D20 roll values below the player statistics
- **THEN** the encounter view does not show raw D20 roll values below the monster statistics

### Requirement: Combat feedback is localized
The monster encounter view SHALL show combat outcome text in the selected application language.

#### Scenario: Spanish is selected
- **WHEN** the application language is Spanish and an attack resolves
- **THEN** the combat feedback text is shown in Spanish
- **THEN** the fight log sentences, outcome labels and floating words are shown in Spanish, with translated monster and attack names
