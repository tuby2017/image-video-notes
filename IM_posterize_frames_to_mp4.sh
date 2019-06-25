#!/bin/bash
shopt -s expand_aliases 
f=12
## -limit memory 1mb -limit map 2mb
export MAGICK_THREAD_LIMIT=2
j1() {
convert "${1}" \
-filter triangle \
+dither -remap colortable.mpc -posterize 8 \
-resize 640x262! \
-define jpeg:fancy-upsampling=off -strip -quality 75 \
"${2}";
}
cd ~/Downloads/Videos/spidy/final
[[ `pwd` =~ "final" ]] && c=1||c=0 
[[ $c == 0 ]] && exit
#ffmpeg -i ../s2.mp4 -vf "fps=$f" -q:v 4 -vsync vfr f%04d.jpeg
x=1
count=1905
for z in f{1905..1919}.jpeg;do #2897}.jpeg;do 
#for z in *jpeg;do 
j$x $z new/"${z%%.*}"-p.jpeg
echo $count;count=$((count+1));
done
exit
alias ff='ffmpeg -hide_banner -y -i new/f%04d-p.jpeg -c:v libx264 -threads 2'
ff -r 7 -crf 20 $f ../"test-p.mp4"
ff -vf sab -r 7 -preset slow -crf 20 ../"test-p24.mp4"

exit
