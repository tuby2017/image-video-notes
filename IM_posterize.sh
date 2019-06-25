#!/bin/bash
export MAGICK_THREAD_LIMIT=2
st=1
nb=50
pt() {
convert "${1}" \
+dither -remap colortable.mpc -posterize 8 \
-strip -define jpeg:fancy-upsampling=off \
-despeckle \
"${2}";
}

dir=scale
outdir=posterize

cd ~/Downloads/Videos/spidy/$dir
[[ `pwd` =~ "$dir" ]] && c=1||c=0 
[[ $c == 0 ]] && exit

convert colortable.gif colortable.mpc
count=$st
#1670
for x in $(seq $st $nb); do
z=$(printf "f%04d.jpeg" "$x")
#echo "${z}"
wait;
pt $z ../$outdir/"${z}"
#echo $count;count=$((count+1));
echo $x
done
rm colortable.mpc colortable.cache
exit

alias ff='ffmpeg -hide_banner -y -i posterize/f%04d-p.jpeg -c:v libx264 -threads 2'
ff -r 23 -preset slow -crf 20 "test-p23.mp4"
