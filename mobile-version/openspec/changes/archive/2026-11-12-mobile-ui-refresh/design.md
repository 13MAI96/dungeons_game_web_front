## Context

The UI lives in one scene (`scenes/main.tscn`) whose views are sibling containers toggled by `scripts/main.gd`; several views and all overlays are built in code. Tests address nodes by path and by member variables, so node names and the variables in `main.gd` stay stable. Logical units ≈ dp at the 390-wide viewport (`canvas_items` stretch), so platform guideline numbers apply directly.

## Goals / Non-Goals

**Goals:** one source of styling, safe-area awareness, a policy-compliant ad slot, the three critical defects fixed, guideline-sized targets and text, no regressions in existing specs/tests.

**Non-Goals:** integrating an ad SDK, new gameplay features (multiple attacks, tap-to-move), animation polish (floating damage numbers, dice tumble), reordering hub actions (spec-fixed).

## Decisions

1. **Theme built in code (`scripts/ui_theme.gd`)**, assigned to the root `Main` control so every view and overlay inherits it. A `.tres` would be editor-friendly but hand-authoring it is error-prone; a script is reviewable and testable. Type variations: `PrimaryButton`, `DangerButton`, `ComingSoonButton`, `DPadButton`, `IconButton`, `TitleLabel`, `HeaderLabel`, `CaptionLabel`, `CardPanel`, `DialogPanel`, `AdSlotPanel`.
2. **Insets instead of reparenting.** Views keep their paths; `_apply_layout_insets()` sets each full-rect view/overlay's offsets to `safe area + ad slot`. Re-applied on window resize and on every view change.
3. **Safe area** comes from `DisplayServer.get_display_safe_area()` converted from physical to viewport pixels; only applied with the `mobile` feature (desktop returns the usable rect, not notch insets).
4. **Ad slot** is a bottom-anchored `Panel` (`AdSlot`), 60 px tall plus a 12 px non-interactive gap. Shown on menu, hub, settings, level-up and result screens; hidden on exploration and combat (AdMob discourages banners next to constantly-tapped controls). `AdSlotConfig.enabled` collapses it everywhere. Debug builds draw a labelled placeholder; release builds draw an empty strip until an SDK fills it. Overlays stop above the slot so the banner is never covered.
5. **In-game confirmation modal** (`Control` + `DialogPanel`) replaces `ConfirmationDialog`; the native window ignored stretch scaling and did not wrap.
6. **Stable exploration layout:** survival stats move to a top HUD, Rest/Retreat/Collect share one row, the feedback label has a fixed two-line height. Map cell size is computed from viewport height minus the combined minimum sizes of the HUD and action area, so it no longer depends on transient content. The map re-renders on resize.
7. **Player marker** is a ring `Panel` inside the current cell (cells stay direct grid children, as tests require). The entrance stays green; non-entrance current cells keep their tile colour and get the ring.
8. **Value contrast** via a dark outline on bar values (works on pastel fills and dark empty segments), keeping the spec-mandated bar colours.

## Risks / Trade-offs

- [Code-built theme is not visible in the editor's theme inspector] → variations are still selectable by name; a `.tres` export can be added later.
- [Ad slot height is a fixed 60 px while adaptive banners vary 50–90 dp] → `AdSlotConfig.height` is a single value to update from the SDK's reported height.
- [Safe-area maths differ per device] → minimum gutters are always applied; verified on emulator, desktop falls back to zero insets.
