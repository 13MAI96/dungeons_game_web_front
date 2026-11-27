## Why

In a user test, the player did not know how to leave a dungeon with the experience earned. Retreat only works on the entrance (by design), but away from it the button was just greyed out, with no reason. The entrance was hard to find once the player had walked away, and the map window (5 x 7 cells) can hide it completely. After retreating, the result only said "You returned safely from the dungeon.", while completing a dungeon already says "+47 experience". Vikunja task DNG-17.

## What Changes

- **Disabled with a reason:** away from the entrance, a caption under the Rest / Retreat row says "Return to the green entrance to retreat" / "Volvé a la entrada verde para retirarte", like Fight and Rest (DNG-16) explain why they are disabled. The existing key `EXPLORE_RETREAT_ENTRANCE_ONLY` is reworded and reused. On the entrance the caption is empty.
- **Entrance easy to find:** the entrance cell keeps its green tile and gets a light-green ring inside it, drawn under the gold player ring.
- **Direction to a hidden entrance:** when the entrance is outside the visible map window, a light-green arrow on the window cell nearest to it points toward it (any of 8 directions).
- **Retreat summary:** the retreat result lists the safe return, the dungeon experience kept ("You kept +47 experience from this run." / "Te llevás +47 de experiencia de esta expedición.", or "You earned no experience in this run." when there was none) and the total against the next level ("Total experience: 67 / 100 (33 more for level 2).") or, when the total already reaches it, "Total experience: 137. You can level up in Progression.".

## Capabilities

### Modified Capabilities
- `dungeon-exploration`: the disabled Retreat explains how to retreat; the entrance is highlighted and an arrow points to it when it is off the map window.
- `playable-feedback`: the retreat result summarises the experience kept and the progress toward the next level.

## Impact

`scripts/main.gd` (`_add_retreat_hint()`, `_get_retreat_block_hint()`, `_update_retreat_hint()`, `_create_entrance_marker()`, `_get_entrance_arrow()`, `_create_entrance_arrow()`, `_format_retreat_summary()`; `_render_map()`, `_update_exploration_actions()` and `_retreat()` updated), `tools/playtest_bot.gd` (recognises the longer retreat message), `localization/menu.en.po`, `localization/menu.es.po`. Tests: new `tests/verify_retreat_feedback.gd`; `tests/verify_localization.gd` extended. No rule or save-format change.
