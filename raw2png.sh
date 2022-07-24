#!/bin/bash

#Ignore these...
#convert -size "1824x940" -depth 16 gray:sn37758-after-all-tests.raw -define sample:offset=25    -sample 50% -set colorspace Gray C0.png
#convert -size "1824x940" -depth 16 gray:sn37758-after-all-tests.raw -define sample:offset=75x24 -sample 50% -set colorspace Gray C1.png
#convert -size "1824x940" -depth 16 gray:sn37758-after-all-tests.raw -define sample:offset=25x75 -sample 50% -set colorspace Gray C2.png
#convert -size "1824x940" -depth 16 gray:sn37758-after-all-tests.raw -define sample:offset=75    -sample 50% -set colorspace Gray C3.png

# This script makes assumptions about the color filter array used in the sensor. Make adjustments as necessary.

#Arguments:
#           $1 = width 
#           $2 = height
#           $3 = bits per sample
#           $4 = filename

convert -size "$1x$2" -depth $3 gray:"$4" .tmp-gray.tiff

exiftool \
-DNGVersion=1.4.0.0 \
-EXIF:SubfileType='Full-resolution Image' \
-PhotometricInterpretation='Color Filter Array' \
-IFD0:CFARepeatPatternDim='2 2' \
-IFD0:CFAPattern2='2 1 1 0' \
-Orientation=Horizontal \
-BitsPerSample=16 \
-SamplesPerPixel=1 \
-o .tmp.dng \
.tmp-gray.tiff

rm .tmp-gray.tiff

dcraw -T .tmp.dng

rm .tmp.dng

convert .tmp.tiff $4.png

rm .tmp.tiff