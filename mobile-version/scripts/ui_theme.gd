extends RefCounted
## Shared UI theme for the whole game. Built in code so it is reviewable and testable;
## assigned once to the root `Main` control and inherited by every view and overlay.
##
## Type variations (set `theme_type_variation` on a node):
##   Buttons: PrimaryButton, DangerButton, ComingSoonButton, DPadButton, IconButton, SelectedButton
##   Labels:  TitleLabel, HeaderLabel, CaptionLabel, FeedbackLabel
##   Panels:  CardPanel, DialogPanel, AdSlotPanel  (for PanelContainer and Panel)

# Palette (dark brown-black base required by the menu/new-game specs).
const BACKGROUND := Color("1b130d")
const SURFACE := Color("2a1f17")
const SURFACE_RAISED := Color("3a2b1f")
const SURFACE_SUNKEN := Color("140e0a")
const BORDER := Color("5a4330")
const ACCENT := Color("d9a441")
const ACCENT_BRIGHT := Color("ffd75e")
const ACCENT_DEEP := Color("a8741f")
const TEXT := Color("f2e8d8")
const TEXT_MUTED := Color("b8a890")
const TEXT_DISABLED := Color("7a6b5a")
const DANGER := Color("c4553c")
const DANGER_DEEP := Color("4a1d16")
const SCRIM := Color(0.04, 0.03, 0.02, 0.88)

# Sizes in logical pixels (~dp at the 390-wide design viewport).
const TOUCH_MIN := 48
const BUTTON_HEIGHT := 52
const PRIMARY_HEIGHT := 56
const DPAD_SIZE := 64
const ICON_BUTTON_SIZE := 48
const SCREEN_GUTTER := 20

const FONT_BODY := 16
const FONT_BUTTON := 17
const FONT_PRIMARY := 19
const FONT_CAPTION := 14
const FONT_HEADER := 20
const FONT_TITLE := 28
const FONT_STAT := 12
const FONT_STAT_VALUE := 13

static func build() -> Theme:
	var theme := Theme.new()
	theme.default_font_size = FONT_BODY
	var bold := FontVariation.new()
	bold.base_font = ThemeDB.fallback_font
	bold.variation_embolden = 0.7

	_build_buttons(theme, bold)
	_build_labels(theme, bold)
	_build_panels(theme)
	_build_misc(theme)
	return theme

static func box(bg: Color, border: Color = Color.TRANSPARENT, border_width: int = 0, radius: int = 10, margin_h: int = 16, margin_v: int = 10) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg
	style.border_color = border
	style.set_border_width_all(border_width)
	style.set_corner_radius_all(radius)
	style.content_margin_left = margin_h
	style.content_margin_right = margin_h
	style.content_margin_top = margin_v
	style.content_margin_bottom = margin_v
	style.anti_aliasing = true
	return style

static func _set_button_styles(theme: Theme, type: String, normal: StyleBox, hover: StyleBox, pressed: StyleBox, disabled: StyleBox) -> void:
	theme.set_stylebox("normal", type, normal)
	theme.set_stylebox("hover", type, hover)
	theme.set_stylebox("pressed", type, pressed)
	theme.set_stylebox("hover_pressed", type, pressed)
	theme.set_stylebox("disabled", type, disabled)
	theme.set_stylebox("focus", type, StyleBoxEmpty.new())

static func _set_button_colors(theme: Theme, type: String, normal: Color, pressed: Color, disabled: Color) -> void:
	for color_name: String in ["font_color", "font_hover_color", "font_focus_color"]:
		theme.set_color(color_name, type, normal)
	theme.set_color("font_pressed_color", type, pressed)
	theme.set_color("font_hover_pressed_color", type, pressed)
	theme.set_color("font_disabled_color", type, disabled)
	for color_name: String in ["icon_normal_color", "icon_hover_color", "icon_focus_color"]:
		theme.set_color(color_name, type, normal)
	theme.set_color("icon_pressed_color", type, pressed)
	theme.set_color("icon_hover_pressed_color", type, pressed)
	theme.set_color("icon_disabled_color", type, Color(disabled, 0.45))

static func _build_buttons(theme: Theme, bold: Font) -> void:
	var disabled_box := box(SURFACE_SUNKEN, Color(BORDER, 0.35), 1)
	_set_button_styles(theme, "Button",
		box(SURFACE, BORDER, 1),
		box(SURFACE_RAISED, BORDER, 1),
		box(SURFACE_SUNKEN, ACCENT, 2),
		disabled_box)
	_set_button_colors(theme, "Button", TEXT, ACCENT_BRIGHT, TEXT_DISABLED)
	theme.set_font_size("font_size", "Button", FONT_BUTTON)
	theme.set_constant("h_separation", "Button", 8)
	theme.set_constant("outline_size", "Button", 0)

	theme.set_type_variation("PrimaryButton", "Button")
	_set_button_styles(theme, "PrimaryButton",
		box(ACCENT_DEEP, ACCENT, 2, 12),
		box(ACCENT_DEEP.lightened(0.12), ACCENT_BRIGHT, 2, 12),
		box(ACCENT_DEEP.darkened(0.25), ACCENT_BRIGHT, 2, 12),
		box(SURFACE_SUNKEN, Color(BORDER, 0.35), 1, 12))
	_set_button_colors(theme, "PrimaryButton", Color("1b130d"), Color("1b130d"), TEXT_DISABLED)
	theme.set_font_size("font_size", "PrimaryButton", FONT_PRIMARY)
	theme.set_font("font", "PrimaryButton", bold)

	theme.set_type_variation("DangerButton", "Button")
	_set_button_styles(theme, "DangerButton",
		box(DANGER_DEEP, DANGER, 1),
		box(DANGER_DEEP.lightened(0.1), DANGER, 1),
		box(DANGER_DEEP.darkened(0.3), DANGER, 2),
		disabled_box)
	_set_button_colors(theme, "DangerButton", Color("ffd9cf"), Color.WHITE, TEXT_DISABLED)

	# Features that do not exist yet: flat, borderless, clearly not actionable.
	theme.set_type_variation("ComingSoonButton", "Button")
	var coming_soon := box(Color(SURFACE_SUNKEN, 0.6), Color(BORDER, 0.25), 1)
	_set_button_styles(theme, "ComingSoonButton", coming_soon, coming_soon, coming_soon, coming_soon)
	_set_button_colors(theme, "ComingSoonButton", TEXT_DISABLED, TEXT_DISABLED, TEXT_DISABLED)
	theme.set_font_size("font_size", "ComingSoonButton", FONT_CAPTION + 1)

	theme.set_type_variation("DPadButton", "Button")
	_set_button_styles(theme, "DPadButton",
		box(SURFACE_RAISED, BORDER, 1, 14, 8, 8),
		box(SURFACE_RAISED.lightened(0.08), ACCENT, 1, 14, 8, 8),
		box(SURFACE_SUNKEN, ACCENT_BRIGHT, 2, 14, 8, 8),
		box(SURFACE_SUNKEN, Color(BORDER, 0.3), 1, 14, 8, 8))
	_set_button_colors(theme, "DPadButton", TEXT, ACCENT_BRIGHT, TEXT_DISABLED)
	theme.set_constant("icon_max_width", "DPadButton", 34)

	theme.set_type_variation("IconButton", "Button")
	var radius := ICON_BUTTON_SIZE / 2
	_set_button_styles(theme, "IconButton",
		box(SURFACE_RAISED, BORDER, 1, radius, 0, 0),
		box(SURFACE_RAISED.lightened(0.1), ACCENT, 1, radius, 0, 0),
		box(SURFACE_SUNKEN, ACCENT_BRIGHT, 2, radius, 0, 0),
		box(SURFACE_SUNKEN, Color(BORDER, 0.3), 1, radius, 0, 0))
	_set_button_colors(theme, "IconButton", TEXT, ACCENT_BRIGHT, TEXT_DISABLED)
	theme.set_font_size("font_size", "IconButton", 20)
	theme.set_font("font", "IconButton", bold)

	# Narrow buttons that share a row (exploration actions): tighter padding, smaller text.
	theme.set_type_variation("CompactButton", "Button")
	_set_button_styles(theme, "CompactButton",
		box(SURFACE, BORDER, 1, 10, 4, 6),
		box(SURFACE_RAISED, BORDER, 1, 10, 4, 6),
		box(SURFACE_SUNKEN, ACCENT, 2, 10, 4, 6),
		box(SURFACE_SUNKEN, Color(BORDER, 0.35), 1, 10, 4, 6))
	_set_button_colors(theme, "CompactButton", TEXT, ACCENT_BRIGHT, TEXT_DISABLED)
	theme.set_font_size("font_size", "CompactButton", FONT_CAPTION + 1)
	theme.set_type_variation("CompactPrimaryButton", "PrimaryButton")
	_set_button_styles(theme, "CompactPrimaryButton",
		box(ACCENT_DEEP, ACCENT, 2, 10, 4, 6),
		box(ACCENT_DEEP.lightened(0.12), ACCENT_BRIGHT, 2, 10, 4, 6),
		box(ACCENT_DEEP.darkened(0.25), ACCENT_BRIGHT, 2, 10, 4, 6),
		box(SURFACE_SUNKEN, Color(BORDER, 0.35), 1, 10, 4, 6))
	theme.set_font_size("font_size", "CompactPrimaryButton", FONT_CAPTION + 1)

	# A choice that is already active (e.g. the current language): disabled but highlighted.
	theme.set_type_variation("SelectedButton", "Button")
	var selected := box(Color(ACCENT_DEEP, 0.25), ACCENT, 2)
	_set_button_styles(theme, "SelectedButton", box(SURFACE, BORDER, 1), box(SURFACE_RAISED, BORDER, 1), box(SURFACE_SUNKEN, ACCENT, 2), selected)
	_set_button_colors(theme, "SelectedButton", TEXT, ACCENT_BRIGHT, ACCENT_BRIGHT)

static func _build_labels(theme: Theme, bold: Font) -> void:
	theme.set_color("font_color", "Label", TEXT)
	theme.set_font_size("font_size", "Label", FONT_BODY)

	theme.set_type_variation("TitleLabel", "Label")
	theme.set_font_size("font_size", "TitleLabel", FONT_TITLE)
	theme.set_font("font", "TitleLabel", bold)
	theme.set_color("font_color", "TitleLabel", ACCENT)

	theme.set_type_variation("HeaderLabel", "Label")
	theme.set_font_size("font_size", "HeaderLabel", FONT_HEADER)
	theme.set_font("font", "HeaderLabel", bold)

	theme.set_type_variation("CaptionLabel", "Label")
	theme.set_font_size("font_size", "CaptionLabel", FONT_CAPTION)
	theme.set_color("font_color", "CaptionLabel", TEXT_MUTED)

	theme.set_type_variation("FeedbackLabel", "Label")
	theme.set_font_size("font_size", "FeedbackLabel", 15)
	theme.set_color("font_color", "FeedbackLabel", Color("f6dfa8"))

static func _build_panels(theme: Theme) -> void:
	var card := box(SURFACE, BORDER, 1, 14, 12, 12)
	var dialog := box(Color("241a12"), ACCENT, 2, 16, 20, 20)
	dialog.shadow_color = Color(0, 0, 0, 0.5)
	dialog.shadow_size = 12
	var ad_slot := box(SURFACE_SUNKEN, Color(BORDER, 0.6), 0, 0, 0, 0)
	ad_slot.border_width_top = 1
	for base: String in ["PanelContainer", "Panel"]:
		var card_type := "CardPanel" if base == "PanelContainer" else "CardPanelFlat"
		theme.set_type_variation(card_type, base)
		theme.set_stylebox("panel", card_type, card)
	theme.set_type_variation("DialogPanel", "PanelContainer")
	theme.set_stylebox("panel", "DialogPanel", dialog)
	theme.set_type_variation("AdSlotPanel", "Panel")
	theme.set_stylebox("panel", "AdSlotPanel", ad_slot)
	theme.set_stylebox("panel", "PanelContainer", box(SURFACE, BORDER, 1, 12, 8, 8))

static func _build_misc(theme: Theme) -> void:
	theme.set_constant("separation", "VBoxContainer", 12)
	theme.set_constant("separation", "HBoxContainer", 10)
	theme.set_constant("h_separation", "GridContainer", 3)
	theme.set_constant("v_separation", "GridContainer", 3)
	var empty := StyleBoxEmpty.new()
	theme.set_stylebox("panel", "ScrollContainer", empty)
	theme.set_color("font_color", "ProgressBar", TEXT)
