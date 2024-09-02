# memeMaker
Create captions under / above / beside images using ImageMagick

## Purpose

This bash script adds a captioned border to an image using ImageMagick. It allows you to add text to a specified side of an image (top, bottom, left, or right) with customizable border size and font options.

## Features

- Add a border with text to any side of an image
- Customizable border size (as a percentage of image dimensions)
- Optional font selection
- Automatic text wrapping within the border
- Flexible defaults for ease of use

## Prerequisites

- Bash shell
- ImageMagick (must be installed and accessible in your PATH)

## Usage

`./caption.sh <input_image> <output_image> <text> [side] [border_percentage] [font]`

### Parameters:

* <input_image>: Path to the input image file
* <output_image>: Path where the output image will be saved
* <text>: The caption text (enclose in quotes if it contains spaces)
* [side]: (Optional) Side to place the caption (top, bottom, left, right). Default: bottom
* [border_percentage]: (Optional) Border size as a percentage of image dimension (25-50). Default: 25% for top/bottom, 50% for left/right
* [font]: (Optional) Font to use for the caption. Default: System default font

See a list of fonts available with - `magick convert -list font | more`

### Examples:

Basic usage (adds caption to bottom with default settings):

`bashCopy./caption.sh input.jpg output.jpg "This is a caption"`

Specifying side and border percentage:

`bashCopy./caption.sh input.jpg output.jpg "Left side caption" left 30`

Full parameter usage:

`bashCopy./caption.sh input.jpg output.jpg "Custom font caption" top 40 Arial`

## Notes

The script will create a temporary file (text_image.png) in the current directory, which is deleted after processing.

If an invalid side is specified, it defaults to bottom.

If an invalid border percentage is provided, it defaults to 25%.

If a specified font is not available, the system default will be used.

## Troubleshooting

If you encounter any issues, ensure that:

ImageMagick is correctly installed and accessible in your PATH

You have write permissions in the current directory and the output directory

Your input image file exists and is a valid image format

For any persistent issues, please check the script's output for error messages.
