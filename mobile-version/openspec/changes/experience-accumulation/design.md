## Context

The player dictionary had one `current_experience` value representing both permanent progression and the rewards at risk in the current dungeon. Those concepts have different lifecycles.

## Decisions

1. Keep `current_experience` as the permanent cumulative total.
2. Store rewards from monsters and quests in `dungeon_experience` while `in_dungeon` is true.
3. Commit provisional experience on completion or voluntary retreat, adding any completion bonus exactly once.
4. Discard provisional experience on defeat or energy depletion without changing the permanent total.
5. Reset active-run fields when loading because dungeon state is not resumable.

## Risks / Trade-offs

- Old saves receive zero provisional experience through default merging.
- The exploration UI displays permanent plus provisional experience so progress remains visible during a run.
