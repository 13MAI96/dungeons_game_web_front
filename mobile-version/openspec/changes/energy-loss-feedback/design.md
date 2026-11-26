## Decisions

1. **Threshold:** `max(1, ceil(max_energy × 25%))`. With the level-1 maximum of 25 energy, the warning fires at 7, which still leaves enough steps to walk back on a small map.
2. **Once per run:** the flag `low_energy_warned` lives in `dungeon`, which is already part of the run snapshot. No new save fields are needed, and resuming keeps the flag.
3. **Where it is checked:** `_warn_if_energy_low()` runs after every action that can spend energy (move, fight, flee, collect treasure), after depletion and completion have been handled, and before the checkpoint is saved. It never fires on the action that ends the run.
4. **Presentation:** it reuses the result modal (title, message, Continue). It is blocking on purpose: the 0.8 s feedback overlay is too short for a rule explanation, and the testers missed the one-line feedback label.
5. **Experience lost:** captured from `dungeon_experience` before `discard_dungeon_experience` / `apply_death_sequel` reset it.
