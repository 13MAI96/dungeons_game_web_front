#!/usr/bin/env bash
# Runs every tests/verify_*.gd script headless and reports pass/fail.
# Usage: tools/run_tests.sh [godot-binary]
set -u
GODOT="${1:-${GODOT:-godot}}"
cd "$(dirname "$0")/.."

failed=0
for test in tests/verify_*.gd; do
	if output=$("$GODOT" --headless --path . -s "res://$test" 2>&1); then
		printf 'PASS  %s\n' "$test"
	else
		printf 'FAIL  %s\n' "$test"
		printf '%s\n' "$output" | grep -E 'ERROR|SCRIPT' | sed 's/^/      /'
		failed=$((failed + 1))
	fi
done

if [ "$failed" -ne 0 ]; then
	printf '\n%d test(s) failed\n' "$failed"
	exit 1
fi
printf '\nAll tests passed\n'
