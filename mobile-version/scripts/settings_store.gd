extends RefCounted
## Device-level settings (not part of the player save): language and the first-run tutorial flag.
## Every setter loads the existing file first, so saving one setting never erases the others.

const DEFAULT_SETTINGS_PATH := "user://settings.cfg"
const SETTINGS_SECTION := "display"
const LOCALE_KEY := "locale"
const SUPPORTED_LOCALES := ["en", "es"]
## Section and key of the "how to play" tutorial flag (true once the player skipped or finished it).
const TUTORIAL_SECTION := "tutorial"
const TUTORIAL_SEEN_KEY := "seen"

static func load_locale(fallback_locale: String, path: String = DEFAULT_SETTINGS_PATH) -> String:
	var normalized_fallback := fallback_locale if fallback_locale in SUPPORTED_LOCALES else "en"
	var config := ConfigFile.new()
	if config.load(path) != OK:
		return normalized_fallback
	var locale := String(config.get_value(SETTINGS_SECTION, LOCALE_KEY, normalized_fallback))
	return locale if locale in SUPPORTED_LOCALES else normalized_fallback

static func save_locale(locale: String, path: String = DEFAULT_SETTINGS_PATH) -> bool:
	if locale not in SUPPORTED_LOCALES:
		return false
	var config := _load_or_create(path)
	config.set_value(SETTINGS_SECTION, LOCALE_KEY, locale)
	return config.save(path) == OK

## True when the first-run tutorial was already skipped or completed on this device.
## A missing or unreadable settings file counts as "not seen", so the tutorial shows.
static func load_tutorial_seen(path: String = DEFAULT_SETTINGS_PATH) -> bool:
	var config := ConfigFile.new()
	if config.load(path) != OK:
		return false
	return bool(config.get_value(TUTORIAL_SECTION, TUTORIAL_SEEN_KEY, false))

## Stores the first-run tutorial flag, keeping the other settings (language) intact.
static func save_tutorial_seen(seen: bool, path: String = DEFAULT_SETTINGS_PATH) -> bool:
	var config := _load_or_create(path)
	config.set_value(TUTORIAL_SECTION, TUTORIAL_SEEN_KEY, seen)
	return config.save(path) == OK

static func delete_settings(path: String = DEFAULT_SETTINGS_PATH) -> bool:
	if not FileAccess.file_exists(path):
		return true
	return DirAccess.remove_absolute(ProjectSettings.globalize_path(path)) == OK

## Existing settings file, or an empty one when it is missing or unreadable.
static func _load_or_create(path: String) -> ConfigFile:
	var config := ConfigFile.new()
	if config.load(path) != OK:
		config = ConfigFile.new()
	return config
