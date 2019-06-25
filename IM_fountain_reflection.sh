#!/bin/bash
pic="w2.jpg"
fps=6
input="p-noise"
x=test/r
key=11
toEnd=$((key*30));
lvl="-level 9%"
lvl=" "
#lvl="-sigmoidal-contrast 15,50%"
disv="-23x37"
#convert $input.jpg -blur 0x5 $x$input.jpg;input=$x$input;echo $input

#for i in {1..2};do
for i in `seq 0 30 $toEnd`; do
  convert $input.jpg $lvl -function Sinusoid 4.5,${i} miff:-
  done |
#    -radial-blur 90 -swirl 180 -blur 0x5 r.jpg
#	-blur 0x5 -swirl 80 -flip
# -morphology erodeIntensity Octagon:2
convert miff:- -morphology erodeIntensity Octagon:1 -blur 0x5 -swirl 90 "$x".jpg
#exit


#key=$((key-1))
for i in $(seq 0 $key);do
composite "$pic" "$x"-$i.jpg +swap -displace "$disv" "$x"d-$i.jpg #10x-13
done
#ffmpeg -y -framerate "$fps" -i "$x"d-%d.jpg -c:v mpeg4 -an d.mp4;mpv d.mp4
ffmpeg -y -framerate "$fps" -i "$x"d-%d.jpg -c:v libx264 -q:v 2 -an d.mp4;mpv d.mp4
##ffmpeg -y -framerate 6 -i d-%d.jpg d.webm
exit
###
# for i in rd-*jpg;do convert "$i" -gravity north -crop 630x165+0+0\! 2$i;done
# ls 2rd*|sort -V > list
# d=14;rsz=50%; 
# convert -delay "$d" @list -resize "rsz" d.gif;mpv d.gif
#copy: https://pastebin.com/raw/6SBdRiB7


#reupload orginial img
https://i.imgur.com/3Of9WF7.jpg 
#crop and slight color edit
https://i.imgur.com/AOgmhxq.jpg 
#perlin noise with fred script
https://i.imgur.com/g8gUZQU.jpg 
