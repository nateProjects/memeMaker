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

INPUT_DIMS=$(magick identify -format "%wx%h" "$INPUT")

mkdir -p "$OUTPUT_DIR"

# Border test: output dimensions must be larger than the input
run_border_test() {
    local name="$1"
    local output="$OUTPUT_DIR/${name}.jpg"
    shift
    echo -n "  $name ... "
    if "$MEME_MAKER" "$INPUT" "$output" "$@" >/dev/null 2>&1; then
        local dims
        dims=$(magick identify -format "%wx%h" "$output")
        if [ "$dims" != "$INPUT_DIMS" ]; then
            echo "PASS ($INPUT_DIMS -> $dims)"
            PASS=$(( PASS + 1 ))
        else
            echo "FAIL (dimensions unchanged — border not added)"
            FAIL=$(( FAIL + 1 ))
        fi
    else
        echo "FAIL (script error)"
        FAIL=$(( FAIL + 1 ))
    fi
}

# Overlay test: dimensions must stay the same, but pixels must differ from the original
run_overlay_test() {
    local name="$1"
    local output="$OUTPUT_DIR/${name}.jpg"
    shift
    echo -n "  $name ... "
    if "$MEME_MAKER" "$INPUT" "$output" "$@" >/dev/null 2>&1; then
        local dims changed_pixels
        dims=$(magick identify -format "%wx%h" "$output")
        # AE output is "216905 (0.433659)" — grab just the leading integer
        changed_pixels=$(magick compare -metric AE "$INPUT" "$output" /dev/null 2>&1 | awk '{print int($1)}' || true)
        if [ "$dims" != "$INPUT_DIMS" ]; then
            echo "FAIL (dimensions changed — image was resized)"
            FAIL=$(( FAIL + 1 ))
        elif [ "${changed_pixels:-0}" -gt 0 ] 2>/dev/null; then
            echo "PASS (same size, ${changed_pixels} px composited)"
            PASS=$(( PASS + 1 ))
        else
            echo "FAIL (output identical to input — text not composited)"
            FAIL=$(( FAIL + 1 ))
        fi
    else
        echo "FAIL (script error)"
        FAIL=$(( FAIL + 1 ))
    fi
}

echo ""
echo "=== memeMaker test suite ==="
echo "Input: $INPUT ($INPUT_DIMS)"
echo "Output dir: $OUTPUT_DIR"
echo ""

echo "-- Border: short text --"
run_border_test "bottom_short"  "$LOREM_SHORT" bottom
run_border_test "top_short"     "$LOREM_SHORT" top
run_border_test "left_short"    "$LOREM_SHORT" left
run_border_test "right_short"   "$LOREM_SHORT" right

echo ""
echo "-- Border: long text --"
run_border_test "bottom_long"   "$LOREM_LONG" bottom
run_border_test "top_long"      "$LOREM_LONG" top
run_border_test "left_long"     "$LOREM_LONG" left
run_border_test "right_long"    "$LOREM_LONG" right

echo ""
echo "-- Border: custom percentage --"
run_border_test "bottom_40pct"  "$LOREM_SHORT" bottom 40
run_border_test "left_30pct"    "$LOREM_LONG"  left   30

echo ""
echo "-- Overlay: text composited inside image --"
run_overlay_test "overlay_bottom" "$LOREM_SHORT" bottom 0
run_overlay_test "overlay_top"    "$LOREM_SHORT" top    0
run_overlay_test "overlay_left"   "$LOREM_SHORT" left   0
run_overlay_test "overlay_right"  "$LOREM_SHORT" right  0

echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="
echo ""
[ "$FAIL" -eq 0 ] && echo "All tests passed." || echo "Some tests failed — check $OUTPUT_DIR for output files."
echo ""
