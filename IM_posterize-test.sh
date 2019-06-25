#!/bin/bash
j1() {
convert "${1}" -filter triangle \
+dither -remap colortable.gif -posterize 8 \
-resize 640x262! \
-define jpeg:fancy-upsampling=off -strip -quality 75 \
"${2}";
}

[[ `pwd` =~ "frames" ]] && c=1||c=0 
[[ $c == 0 ]] && exit

x=1
for z in *jpeg;do
j$x $z ../scale/"${z%%.*}"-p.jpeg
done

cd ../scale
ffmpeg -hide_banner -i f%04d-p.jpeg -c:v libx264 -r 2 ../test-p.mp4
exit

#freds scripts
o='new'
for z in *-p.jpeg;do
#./noisecleaner $z $o/"${z%%.*}"-c0.jpeg
#convert -despeckle $o/"${z%%.*}"-c0.jpeg $o/"${z%%.*}"-sp.jpeg
./denoise -f 2 -s "20x20+203+152" -n 1 $o/"${z%%.*}"-sp.jpeg "${z%%.*}"-d3.jpeg ###
done
#rm new/*
#ffmpeg -hide_banner -i f%04d-p-d3.jpeg -c:v libx264 -r 2 ../test.mp4



##slightly blur
./noisecleaner $in $o-c0.jpeg
./denoise -f 2 -s "20x20+203+152" -n 1 $o-c0.jpeg $o-d3.jpeg
convert -despeckle $o-d3.jpeg $o-sp.jpeg ###
mv $o-sp.jpeg ./
rm new/n-*
