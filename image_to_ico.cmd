@echo off

:: This is older attempt to implement converison using just Image Magick command line tool.
:: It is not used in the main script, but it can be useful for testing and as a reference
:: for how to use Image Magick from command line.

:: Use Image Magick to convert an image (JPG, PNG...) to ICO format with multiple sizes
:: Make sure Image Magick is installed and 'magick' command is available in PATH
:: Use https://convertico.com/ to convert PNG to ICO manually on-line if you do not want to install image magick.

setlocal

set MAGICK_EXE=C:\Program Files\ImageMagick-7.1.2-Q16-HDRI\magick.exe

if not exist "%MAGICK_EXE%" (
  echo Image Magick executable not found at %MAGICK_EXE%
  echo Please install Image Magick and update the MAGICK_EXE path in this script.
  exit /b 1
)

set INPUT_IMAGE=front.jpg

if not "%1"=="" (
  set INPUT_IMAGE=%1
)

echo %INPUT_IMAGE%

:: Argument should contain path to any image file in any form. Normalize the path to full path.
for %%I in ("%INPUT_IMAGE%") do set "INPUT_IMAGE=%%~fI"

:: Get base directory and filename without extension
for %%I in ("%INPUT_IMAGE%") do ( (
  set "BASE_DIR=%%~dpI"
  set "FILE_NAME=%%~nI"
))

echo %INPUT_IMAGE%

:: Beware: do not add .ico extension to .jpg image (image.jpg.ico). Windows will not load it correctly as icon.

set OUTPUT_ICO_PATH=%BASE_DIR%%FILE_NAME%.ico
set TEMP_PNG=%BASE_DIR%%FILE_NAME%.temp.png

:: Print paths the script will use

echo Converting image: %INPUT_IMAGE%
echo Output directory: %BASE_DIR%
echo Output filename: %FILE_NAME%.ico
echo Temporary PNG file: %TEMP_PNG%
echo Output ICO file: %OUTPUT_ICO_PATH%

:: First make PNG image with proper size and transparency
"%MAGICK_EXE%" "%INPUT_IMAGE%" -resize 256x256^ -gravity center -background transparent -extent 256x256 "%TEMP_PNG%"

:: Convert PNG to ICO with multiple sizes. Sizes should be from largest to smallest.
"%MAGICK_EXE%" "%TEMP_PNG%" -define icon:auto-resize=256,128,64,48,32,16 "%OUTPUT_ICO_PATH%"

:: Other attempts
::"%MAGICK_EXE%" "%INPUT_IMAGE%.png" -bordercolor black -border 0 ^( -clone 0 -resize 256x256 ^) ^( -clone 0 -resize 128x128 ^) ^( -clone 0 -resize 64x64 ^) ^( -clone 0 -resize 48x48 ^) ^( -clone 0 -resize 16x16 ^) -delete 0 -alpha off -colors 256 "%OUTPUT_ICO%"

:: FFMPEG can convert images to icons as well.
::ffmpeg -i "%INPUT_IMAGE%.png" "%OUTPUT_ICO%"

:: winget install KevinBralten.Png2Ico
:: I do not know how to add multiple sizes with Png2Ico, so just create 256 size icon
::set OUTPUT_ICO_2=%BASE_DIR%%FILE_NAME%_2.ico
::%LocalAppData%\Png2Ico\Png2Ico.exe "%INPUT_IMAGE%.png" "%OUTPUT_ICO_2%" --size 256

:cleanup

if exist "%TEMP_PNG%" (
  del "%TEMP_PNG%"
)

endlocal
