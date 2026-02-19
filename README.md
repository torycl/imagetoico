# Description

Convert input image file to ICO file.

## Goals

* Keep image aspect ratio
* Keep image transparency if exists
* Create most compatible ICO file possible for Windows 10 and 11 Explorer

## Dependencies

### Python dependencies

```sh
pip install -r requirements.txt
```

### Image magick

Install [Image Magick](https://imagemagick.org/) software. It may generate better results than Pillow library in Python.

On Windows:

```
winget install ImageMagick.ImageMagick
```
