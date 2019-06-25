#!/bin/bash
#jpegtran used in a for-loop
vid=$1
f=$2 #fps
out=$3
DIRECTORY=frames
audio=audio.aac
alias ffmpeg='ffmpeg -hide_banner -loglevel panic'
echo "$vid $f $out"
read -n 1 -s -r -p "Press any key to continue"

if [ ! -f "$audio" ]; then
ffmpeg -i $vid -map 0:a -acodec copy $audio
fi

#r1:: https://video.stackexchange.com/questions/7903/how-to-losslessly-encode-a-jpg-image-sequence-to-a-video-in-ffmpeg
if [ ! -d "$DIRECTORY" ]; then
  # Control will enter here if $DIRECTORY doesn't exist.
  mkdir -p frames/filter/opt
  echo "create frames/"
fi

#extract frames
ffmpeg -i $vid -vf "fps=$f" -q:v 3 -vsync vfr frames/c01_%04d.jpeg

#filter/
cd frames
mix="47"
tmpB2=../brown.jpg

for i in *jpeg;do convert -quality 100 \
\( $tmpB2 -matte -channel a -evaluate set $mix% \) \
	\( $i -gravity center \) \
	+swap -compose color-burn -composite filter/$i;
done
#echo '';echo "filtering complete!!"

#opt/
cd filter;
mkdir overlay;

for x in *.jpeg;do convert -quality 100 ../$x \( $x -matte -channel a -evaluate set 50% \) -compose over -composite "overlay/$x";done

for x in *.jpeg; do jpegtran -optimize -copy none -perfect -v "overlay/$x" > "opt/$x"; done
#echo '';echo "Optimizing complete!!"

#pics to video
cd opt;
ffmpeg -framerate $f -i c01_%04d.jpeg -c:v libx264 -pix_fmt yuv420p $out\_1.mp4;
mv $out\_1.mp4 ../../../;

#video with sound
cd ../../../;
ffmpeg -i $out\_1.mp4 -i $audio -c copy -shortest $out\_2.mkv;

read -n 1 -s -r -p "Press any key to remove frames/"
rm -rf frames/*;rm -rf frames/
echo '';echo done
exit 1
