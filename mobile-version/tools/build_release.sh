#!/usr/bin/env bash
# Builds a release-signed Android APK.
# The keystore and its password stay outside the repository; they are read from a properties
# file and passed to Godot through environment variables, so export_presets.cfg holds no secrets.
#
# Usage: tools/build_release.sh [output.apk]
# Properties file (default ~/.android/keystores/dungeons-release.properties, override with
# DUNGEONS_RELEASE_PROPERTIES):
#   keystore=/absolute/path/to/dungeons-release.keystore
#   alias=dungeons
#   password=...
set -euo pipefail
GODOT="${GODOT:-godot}"
PROPS="${DUNGEONS_RELEASE_PROPERTIES:-$HOME/.android/keystores/dungeons-release.properties}"
OUTPUT="${1:-export/android/dungeons-release.apk}"
cd "$(dirname "$0")/.."

if [ ! -r "$PROPS" ]; then
	echo "Release properties not found: $PROPS" >&2
	exit 1
fi
read_prop() { grep -m1 "^$1=" "$PROPS" | cut -d= -f2-; }

export GODOT_ANDROID_KEYSTORE_RELEASE_PATH="$(read_prop keystore)"
export GODOT_ANDROID_KEYSTORE_RELEASE_USER="$(read_prop alias)"
export GODOT_ANDROID_KEYSTORE_RELEASE_PASSWORD="$(read_prop password)"
if [ ! -r "$GODOT_ANDROID_KEYSTORE_RELEASE_PATH" ]; then
	echo "Keystore not found: $GODOT_ANDROID_KEYSTORE_RELEASE_PATH" >&2
	exit 1
fi

mkdir -p "$(dirname "$OUTPUT")"
"$GODOT" --headless --path . --export-release "Android" "$OUTPUT"
echo "Built $OUTPUT"
