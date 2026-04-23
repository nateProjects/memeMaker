# memeMaker

Add a caption to any side of an image using ImageMagick.

## Installation

Run the install script to get ImageMagick on macOS or Linux:

```bash
./install.sh
```

This installs via Homebrew on macOS, or your distro's package manager on Linux (apt, dnf, yum, pacman, zypper).

## Usage

```bash
./memeMaker <input_image> <output_image> <text> [side] [border_percentage] [font]
```

| Parameter | Required | Description |
|---|---|---|
| `input_image` | Yes | Path to the source image |
| `output_image` | Yes | Path for the output image |
| `text` | Yes | Caption text — quote it if it contains spaces |
| `side` | No | Where to place the caption: `top`, `bottom`, `left`, `right` (default: `bottom`) |
| `border_percentage` | No | Border size as a % of that dimension, 25–50 (default: 25 for top/bottom, 50 for left/right) |
| `font` | No | Font name — defaults to system font |

To see available fonts:

```bash
magick -list font
```

### Examples

```bash
# Caption on the bottom with defaults
./memeMaker input.jpg output.jpg "This is my caption"

# Left side with a custom border size
./memeMaker input.jpg output.jpg "Left side caption" left 30

# Top caption with a specific font
./memeMaker input.jpg output.jpg "Custom font" top 40 Arial
```

## Testing

A test suite is included that runs the script against `monkey-test-image.jpg` across all four sides, two text lengths, and a couple of custom border sizes:

```bash
./test.sh
```

Output images are written to `test-output/` so you can inspect them visually.

## Notes

- Text is automatically scaled to fit the caption box — longer text will appear smaller.
- If an invalid side is given, it defaults to `bottom`.
- If an invalid border percentage is given, it defaults to 25%.
- If a specified font is not found, the system default is used.
