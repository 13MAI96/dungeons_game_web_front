extends RefCounted

const DEFAULT_SETTINGS_PATH := "user://settings.cfg"
const SETTINGS_SECTION := "display"
const LOCALE_KEY := "locale"
const SUPPORTED_LOCALES := ["en", "es"]

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
	var config := ConfigFile.new()
	config.set_value(SETTINGS_SECTION, LOCALE_KEY, locale)
	return config.save(path) == OK

static func delete_settings(path: String = DEFAULT_SETTINGS_PATH) -> bool:
	if not FileAccess.file_exists(path):
		return true
	return DirAccess.remove_absolute(ProjectSettings.globalize_path(path)) == OK
