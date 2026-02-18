#!/usr/bin/env python3
# -*- coding: utf-8 -*-

'''
Convert input image to .ico format for Windows executables
'''

import os

from pathlib import Path
from PIL import Image

def image_to_ico(input_image_path: Path, output_ico_path: Path) -> None:
  '''
  Convert input image to .ico format and save to output path

  TODO: Produce ICO file which will keep its proper aspect ratio and not look stretched in Windows Explorer.
  '''

  # Open the input image
  with Image.open(input_image_path) as img:
    # Convert image to RGBA if not already in that mode
    if img.mode != 'RGBA':
      img = img.convert('RGBA')

    # Save the image as .ico format
    img.save(output_ico_path, format='ICO', sizes=[(16,16), (32,32), (48,48), (64,64), (128,128), (256,256)])


def magick_image_to_ico(input_image_path: Path, output_ico_path: Path) -> None:
  '''
  Convert input image to .ico format using ImageMagick command line tool.
  '''

  possible_magick_dirs = list(Path(os.environ['PROGRAMFILES']).glob('ImageMagick*'))
  if not any(possible_magick_dirs):
    raise FileNotFoundError('ImageMagick not found in Program Files. Please install it from https://imagemagick.org/script/download.php#windows and ensure magick.exe is in your PATH.')

  magick_path = possible_magick_dirs[0] / 'magick.exe'

  temp_png_path = input_image_path.parent / (input_image_path.stem + '_temp.png')

  cmd = [
    str(magick_path),
    str(input_image_path),
    '-resize', '256x256', '-gravity', 'center', '-background', 'transparent', '-extent', '256x256',
    str(temp_png_path)]

  from subprocess import run, CalledProcessError
  try:
    run(cmd, check=True)
  except CalledProcessError as e:
    raise RuntimeError(f'ImageMagick conversion failed: {e}')

  cmd = [
    str(magick_path),
    str(temp_png_path),
    '-define', 'icon:auto-resize=256,128,64,48,32,16',
    str(output_ico_path)
  ]

  try:
    run(cmd, check=True)
  except CalledProcessError as e:
    raise RuntimeError(f'ImageMagick ICO creation failed: {e}')

if __name__ == '__main__':
  import sys

  if len(sys.argv) != 3:
    print('Usage: python image_to_ico.py <input_image_path> <output_ico_path>')
    sys.exit(1)

  input_image_path = Path(sys.argv[1])
  output_ico_path = Path(sys.argv[2])

  image_to_ico(input_image_path, output_ico_path)
  print(f'Converted {input_image_path} to {output_ico_path}')
