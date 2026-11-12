#!/usr/bin/env bash
# Builds a debug APK, installs it on the connected device/emulator and launches it.
# Usage: tools/run_android.sh [--logs]   (--logs streams Godot's log output afterwards)
set -euo pipefail
GODOT="${GODOT:-godot}"
ADB="${ADB:-${ANDROID_HOME:-$HOME/Android/Sdk}/platform-tools/adb}"
PACKAGE="com.dungeons.mobile"
APK="export/android/dungeons.apk"
cd "$(dirname "$0")/.."

if [ "$("$ADB" devices | grep -cw device)" -eq 0 ]; then
	echo "No device found. Plug in a phone with USB debugging, or start an emulator:" >&2
	echo "  ~/Android/Sdk/emulator/emulator -avd Pixel_3a_API_34_extension_level_7_x86_64 -gpu host" >&2
	exit 1
fi

mkdir -p "$(dirname "$APK")"
"$GODOT" --headless --path . --export-debug "Android" "$APK"
"$ADB" install -r "$APK"
"$ADB" shell am force-stop "$PACKAGE"
"$ADB" shell am start -n "$PACKAGE/com.godot.game.GodotAppLauncher" >/dev/null
echo "Launched $PACKAGE"

if [ "${1:-}" = "--logs" ]; then
	"$ADB" logcat -c
	"$ADB" logcat -s godot:V
fi
