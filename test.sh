#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
MEME_MAKER="$SCRIPT_DIR/memeMaker"
INPUT="$SCRIPT_DIR/monkey-test-image.jpg"
OUTPUT_DIR="$SCRIPT_DIR/test-output"

LOREM_SHORT="Lorem ipsum dolor sit amet, consectetur adipiscing elit."
LOREM_LONG="Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."

PASS=0
FAIL=0

mkdir -p "$OUTPUT_DIR"

run_test() {
    local name="$1"
    local output="$OUTPUT_DIR/${name}.jpg"
    shift
    echo -n "  $name ... "
    if "$MEME_MAKER" "$INPUT" "$output" "$@" >/dev/null 2>&1; then
        if [ -f "$output" ]; then
            dims=$(magick identify -format "%wx%h" "$output")
            echo "PASS ($dims)"
            PASS=$(( PASS + 1 ))
        else
            echo "FAIL (output file missing)"
            FAIL=$(( FAIL + 1 ))
        fi
    else
        echo "FAIL (script error)"
        FAIL=$(( FAIL + 1 ))
    fi
}

echo ""
echo "=== memeMaker test suite ==="
echo "Input: $INPUT"
echo "Output dir: $OUTPUT_DIR"
echo ""

echo "-- Short text --"
run_test "bottom_short"  "$LOREM_SHORT" bottom
run_test "top_short"     "$LOREM_SHORT" top
run_test "left_short"    "$LOREM_SHORT" left
run_test "right_short"   "$LOREM_SHORT" right

echo ""
echo "-- Long text --"
run_test "bottom_long"   "$LOREM_LONG" bottom
run_test "top_long"      "$LOREM_LONG" top
run_test "left_long"     "$LOREM_LONG" left
run_test "right_long"    "$LOREM_LONG" right

echo ""
echo "-- Custom border percentage --"
run_test "bottom_40pct"  "$LOREM_SHORT" bottom 40
run_test "left_30pct"    "$LOREM_LONG"  left   30

echo ""
echo "-- Overlay mode (border_percentage=0) --"
run_test "overlay_bottom" "$LOREM_SHORT" bottom 0
run_test "overlay_top"    "$LOREM_SHORT" top    0
run_test "overlay_left"   "$LOREM_SHORT" left   0
run_test "overlay_right"  "$LOREM_SHORT" right  0

echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="
echo ""
[ "$FAIL" -eq 0 ] && echo "All tests passed." || echo "Some tests failed — check $OUTPUT_DIR for output files."
echo ""
