#!/bin/bash
ffmpeg -i $1 -vf "scale=320:-2,fps=25" frames/c01_%04d.jpeg
ffmpeg -i $v -vf "fps=5" -q:v 5 -vsync vfr frames/c01_%04d.jpeg

mix="47"
#tmpA1=c01_0001.jpeg
tmpB2=brown.jpg

convert \( $tmpB2 -matte -channel a -evaluate set $mix% \) \
	\( $tmpA1 -gravity center \) \
	+swap -compose color-burn -composite new/x-temp.jpg;

for i in *jpeg;do convert -quality 100 \
\( $tmpB2 -matte -channel a -evaluate set $mix% \) \
	\( $i -gravity center \) \
	+swap -compose color-burn -composite new/$i;
done

#keyframes
ffmpeg -i video.webm -vf "select=eq(pict_type\,I)" -vsync vfr thumb%04d.jpg -hide_banner


ffmpeg -r 25 -i c01_%04d.jpeg -c:v libx264 -vf "fps=25,format=yuv420p" a_out.mp4
#-start_number 0

ffmpeg -i input-video.avi -vn -acodec copy output-audio.aac
ffmpeg -i $vid -map 0:a -acodec copy audio.aac

ffmpeg -i video.mp4 -i audio.aac -c copy -shortest output.mkv
ffmpeg -i video.mp4 -i audio.wav \
-c:v copy -c:a aac -strict experimental output.mp4
# https://superuser.com/questions/277642/how-to-merge-audio-and-video-file-in-ffmpeg

####
::<"@text"
E2BFBD
E5BCC0

mogrify -path /fullpath2/tmp2 -format png -fill "#BFBFBF" -opaque "#C0C0C0" *.png
#C0C0C0 TO BFBFBF
-fuzz $f% #threshold
out=$(echo tmpA1|cut -d. -f1)

#average color 
convert cat.png -resize 1x1 txt:-|grep -oE '#[A-Z0-9_.-]{6}'

convert $tmpA1 -fill "#C6937E" -opaque "#E2BFBD" -fuzz 20% new/$out-X.jpeg
@text
####

convert $tmpA1 \( +clone -fuzz 6% -fill "#C6937E" -opaque "#E2BFBD" \) \
-compose color-burn -composite new/$out-X.jpeg


ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=nw=1 input.avi
codec_name=mjpeg

ffmpeg -i input.avi -codec:v copy -bsf:v mjpeg2jpeg output_%03d.jpg
