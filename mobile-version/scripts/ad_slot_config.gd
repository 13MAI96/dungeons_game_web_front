extends RefCounted
## Reserved ad banner slot configuration.
##
## The slot is only a layout reservation: no ad SDK is integrated yet. When one is added
## (e.g. the Poing Studios AdMob plugin), set `height` from the loaded banner's reported
## height (anchored adaptive banners are 50-90 dp) and set `enabled = false` for no-ads
## purchases, missing consent or failed loads so the slot collapses to zero.

## Master switch. When false the slot takes no space on any screen.
static var enabled: bool = true

## Banner height in logical pixels (~dp at the 390-wide viewport). 50 = standard banner.
static var height: int = 60

## Non-interactive spacing between the slot and the nearest control (AdMob placement policy).
const GAP := 12

## Screens where a banner is allowed. Gameplay screens (exploration, combat) are excluded
## because AdMob discourages banners next to controls that are tapped continuously.
const SCREEN_MENU := "menu"
const SCREEN_HUB := "hub"
const SCREEN_SETTINGS := "settings"
const SCREEN_LEVEL_UP := "level_up"
const SCREEN_EXPLORE := "explore"
const SCREEN_ENCOUNTER := "encounter"
const ALLOWED_SCREENS := [SCREEN_MENU, SCREEN_HUB, SCREEN_SETTINGS, SCREEN_LEVEL_UP]

static func allows(screen: String) -> bool:
	return enabled and ALLOWED_SCREENS.has(screen)

## Total vertical space reserved when the slot is visible (banner + separation gap).
static func reserved_height() -> int:
	return height + GAP
