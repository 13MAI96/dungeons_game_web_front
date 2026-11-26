## Decisions

1. **Fixed percentages instead of a random range.** A rest now restores exactly `REST_LIFE_PERCENT` (30 %) of maximum life and `REST_ENERGY_PERCENT` (20 %) of maximum energy, rounded like every other recovery (`roundi`), capped at the maximum. The player can plan with it: a level-1 hero (10 life, 25 energy) always gets +3 life and +5 energy, where the old rule gave 1 to 4 life and 1 to 6 energy. The cost stays 5 mana, so the 12 starting mana still allow two rests per run. The `REST_*_PERCENT_MIN/MAX` constants are removed; `rest()` no longer takes percentage arguments (only tests used them).

2. **Values chosen with the balance bot.** Every option was played with `tools/playtest.gd -- runs=40 games=6 seed=1` (240 runs, same seed, same bot). The bot rests whenever life is below 50 % and it has the mana.

   | Rule | Completed | Died | Energy out | Retreated | Runs to L2 / L5 / L10 | Avg level after 40 runs |
   |---|---|---|---|---|---|---|
   | Baseline: random 10–40 % life, 5–25 % energy | 70.0 % | 0.8 % | 2.9 % | 26.3 % | 4.7 / 14.3 / 24.3 | 16.3 |
   | **A: fixed 30 % life, 20 % energy (chosen)** | 72.5 % | 1.3 % | 3.3 % | 22.9 % | 4.7 / 13.7 / 23.3 | 16.7 |
   | B: fixed 40 % life, 25 % energy | 77.9 % | 2.1 % | 1.3 % | 18.8 % | 4.2 / 12.5 / 23.3 | 17.3 |
   | C: random 30–50 % life, 15–25 % energy | 79.2 % | 0.8 % | 2.9 % | 17.1 % | 4.7 / 13.5 / 23.5 | 17.0 |

   No option had game overs or stuck runs. Differences of 1–3 deaths in 240 runs are noise.

   **A** is chosen. Each rest is worth 3 times the old worst case (+3 instead of +1 life at level 1) and a little more than the old average (25 % life, 15 % energy). It is fully predictable, and pacing stays where it was: completion is +2.5 points and levelling is at most one run faster. **B** turns Rest into a strong heal. It reaches L5 two runs earlier and cuts retreats by 7 points, so dungeons get easier. **C** gives similar gains to B but stays random, which the ticket asked to remove.

   `tests/verify_balance.gd` (12 runs × 6 games, seed 11) still passes with its thresholds unchanged: completed 48.6 % (baseline 45.8 %), died 2.8 % (2.8 %), energy out 4.2 % (5.6 %), level 2 after 4.8 runs (4.8).

3. **The rules say why Rest is blocked.** `CombatRules.get_rest_block_reason()` returns `REST_BLOCKED_NO_MANA` (mana below the cost), `REST_BLOCKED_FULL` (life and energy both at maximum) or `""`. `rest()` uses it and changes nothing when blocked. The UI uses the same function, so the button, the message and the rule always agree. When both apply, the missing mana wins, because it is the reason that lasts.

4. **Full life and energy blocks Rest.** Resting then would only spend 5 mana for nothing, so the button is disabled and the line says "Life and energy are full." This mostly happens at the dungeon entrance before the first step (moving costs energy), and right after a full sanctuary. If only one of the two is below maximum, Rest stays allowed: the player may want the energy.

5. **No rest during a fight.** The Rest button lives on the exploration screen, which is hidden during a monster encounter, and `_rest()` returns at once while an encounter is active (`active_monster_location`). The ability data's `guarded_rest` is not wired to combat, so nothing else can rest mid-fight.

6. **Result line from the real numbers.** `rest()` reports `life_restored`, `energy_restored` (after the maximum cap) and `mana_spent`. `main.gd` formats them with named placeholders (`{life}`, `{energy}`, `{mana}`), so near the maximum the line shows what was really gained ("+1 life"). The text uses "life", like the stat bars and the tutorial, rather than "HP", which the game never uses. The minus sign is U+2212 and the button separator U+00B7. `verify_rest.gd` checks that the theme font has both.

7. **One feedback line, two parts.** The exploration feedback label shows `explore_message` (the last action's message) and, on a second line, the reason Rest is disabled. Every writer goes through `_show_explore_message()`, and `_update_exploration_actions()` refreshes the reason. `move_player()` clears `explore_message` before the new location's effect runs. A rest result, a treasure or trap message or the "retreat only from the entrance" text disappears on the next step, while a sanctuary entered on that step shows its own message. The label already allows two lines, and the reasons are short so they fit.

8. **Tutorial text.** The Rest page now reads "Rest costs %s mana and restores %s%% of your maximum life and %s%% of your maximum energy". The values come from the constants, so the page cannot drift from the rule.
