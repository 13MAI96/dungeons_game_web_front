## Why

Destructive or state-changing navigation currently happens immediately, and expedition outcomes can disappear in a short transient overlay. A playable release needs explicit confirmation before replacing a save or leaving the game hub and a durable result message when an expedition ends.

## What Changes

- Confirm before replacing an existing save with a new game.
- Confirm before returning from the game hub to the main menu.
- Show a dismissible final result after completion, retreat, depletion, defeat, or terminal game over.
- Keep audio and music outside the current playable-release scope.

## Capabilities

### New Capabilities
- `playable-feedback`: Defines confirmations and persistent expedition-result feedback.

### Modified Capabilities
- `save-game-persistence`: Protect existing saves from accidental replacement.
- `dungeon-exploration`: Report every stable expedition outcome until dismissed.

## Impact

- `scripts/main.gd` owns confirmation and result UI.
- `scenes/main.tscn` routes Start Game and Exit through confirmation handlers.
- Localization catalogs include confirmation and outcome text.
- Headless tests cover accept, cancel, and dismissal behavior.
