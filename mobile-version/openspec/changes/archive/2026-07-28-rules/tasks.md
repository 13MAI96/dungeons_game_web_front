## 1. Player Progression Model

- [x] 1.1 Update player default state to start with 10 life, 25 energy, strength 3, speed 3, level 1, zero experience, and zero reputation.
- [x] 1.2 Remove persistent player damage from the player stat presentation and combat source data.
- [x] 1.3 Add strength and speed stat support to player state, stat bar definitions, icons, and colors.
- [x] 1.4 Implement experience threshold calculation through level 10 using +10 per level.
- [x] 1.5 Implement experience threshold calculation after level 10 using `10 percent + level / 10`.
- [x] 1.6 Implement reputation threshold calculation through level 10 using +10 per level.
- [x] 1.7 Implement reputation threshold calculation after level 10 using `25 percent + level / 10`.
- [x] 1.8 Add alive dungeon exit restoration for life, energy, and mana.
- [x] 1.9 Add dungeon death sequel behavior that permanently reduces maximum life by 10 percent until level-up.
- [x] 1.10 Represent save deletion or invalidation when death would reduce maximum life to 0.

## 2. Dungeon Exploration Rules

- [x] 2.1 Update movement so each successful location move costs 1 current energy.
- [x] 2.2 Update rest so it restores a random 5-25 percent of maximum energy.
- [x] 2.3 Update rest so it restores a random 10-40 percent of maximum life.
- [x] 2.4 Ensure rest consumes 5 mana and does not restore mana.
- [x] 2.4a Ensure sanctuary restores 50-100 percent of life, energy, and mana.
- [x] 2.5 Update treasure/quest resolution so opening treasure costs 1 current energy.
- [x] 2.6 Restrict retreat to the dungeon entrance.
- [x] 2.7 Make retreat cost 1 current energy and exit alive only when the player remains alive and energized.
- [x] 2.8 Keep the entrance location always visible and green on the dungeon map.
- [x] 2.9 Update dungeon generation so dungeons before player level 10 fit within 5 columns by 7 rows.
- [x] 2.10 Update dungeon generation so level 10+ dungeons can generate up to 25 columns by 25 rows.
- [x] 2.11 Preserve the visible map viewport limit of 5 columns by 7 rows for all dungeon sizes.
- [x] 2.12 Add the experience bar to the dungeon exploration stats area.

## 3. Dungeon Completion Rewards

- [x] 3.1 Track total monsters and defeated monsters for the active dungeon run.
- [x] 3.2 Detect dungeon completion when all generated monsters are defeated.
- [x] 3.3 Automatically exit the dungeon after defeating the final living monster.
- [x] 3.4 Award current dungeon experience on completion.
- [x] 3.5 Award reputation equal to monsters defeated only for fully completed dungeons.
- [x] 3.6 Show completion feedback with gained experience and reputation.
- [x] 3.7 Ensure incomplete retreat grants no completion reputation.
- [x] 3.8 Ensure death or energy depletion loses current dungeon experience.

## 4. Combat Resolution Rules

- [x] 4.1 Introduce attack definitions with attack-specific damage and energy cost.
- [x] 4.2 Keep one default player attack wired to the existing combat action until the full attack list is specified.
- [x] 4.3 Replace player attack math with `D20 - defender armor - attacker strength`.
- [x] 4.4 Treat resolved values less than or equal to 0 as misses.
- [x] 4.5 Apply attack definition damage when resolved value is positive and not dodged.
- [x] 4.6 Treat natural 20 as a critical hit that bypasses armor and dodge.
- [x] 4.7 Add defender dodge rolls using `D20 * defender speed / 100`.
- [x] 4.8 Apply the same D20 attack and dodge rules to monster attacks.
- [x] 4.8a Select monster attacks randomly from attacks the monster can pay with current mana.
- [x] 4.8b Consume monster mana and expose selected attack effect ids when monster attacks hit.
- [x] 4.8c Resolve flee attempts with D20 plus player speed minus monster speed, consuming 1 player energy.
- [x] 4.8d Keep combat active and resolve a normal monster attack when flee fails.
- [x] 4.9 Return structured combat results containing hit, miss, critical, dodge, damage, actor rolls, defender rolls, and defeat state.

## 5. Monster Model And Encounter UI

- [x] 5.1 Expand monster templates to include level, max/current life, max/current mana, armor, speed, strength, and 2-5 attacks.
- [x] 5.1a Move monster base characteristics into a local JSON data file consumed by the dungeon generator.
- [x] 5.1b Move monster side-effect definitions into a local JSON data file.
- [x] 5.2 Display monster names with `Lv. N` in encounters.
- [x] 5.3 Replace monster damage stat display with speed and strength.
- [x] 5.4 Show monster life, mana, armor, speed, and strength bars in that order.
- [x] 5.5 Show player life, energy, mana, armor, strength, speed, reputation, and experience bars in that order.
- [x] 5.6 Render available player attacks as encounter actions and keep flee available.
- [x] 5.7 Keep monster and player life/mana bars showing current over maximum values.

## 6. D20 Roll Visualization

- [x] 6.1 Add or update `d20.svg` so the primary visible face can display a dynamic roll value.
- [x] 6.2 Remove competing face numbers from the D20 visual.
- [x] 6.3 Add player roll display below player encounter stats.
- [x] 6.4 Add monster roll display below monster encounter stats.
- [x] 6.5 Show attack roll values when player or monster attacks.
- [x] 6.6 Show dodge roll values when player or monster attempts to dodge.
- [x] 6.7 Clear stale roll values when a new encounter starts.

## 7. Feedback And Localization

- [x] 7.1 Add English and Spanish text for retreat restriction at non-entrance locations.
- [x] 7.2 Add English and Spanish text for dungeon completion rewards.
- [x] 7.3 Add English and Spanish text for death sequel and save invalidation states.
- [x] 7.4 Add English and Spanish combat feedback for miss, dodge, critical hit, and standard hit under the new rules.

## 8. Verification

- [x] 8.1 Add headless tests for new player defaults and stat presentation.
- [x] 8.2 Add headless tests for experience and reputation threshold calculations.
- [x] 8.3 Add headless tests for movement, rest, treasure, retreat, and alive exit rules.
- [x] 8.4 Add headless tests for death sequel and current dungeon experience loss.
- [x] 8.5 Add headless tests for dungeon size limits before and after player level 10.
- [x] 8.6 Add headless tests for automatic dungeon completion and reputation rewards.
- [x] 8.7 Add headless tests for D20 attack hit, miss, critical, and dodge outcomes.
- [x] 8.8 Add headless tests for monster model fields, level display, and stat bar ordering.
- [x] 8.9 Add headless tests for D20 roll visualization and stale-roll clearing.
- [x] 8.10 Validate the Godot project opens headlessly.
- [x] 8.11 Validate the `rules` OpenSpec change.
