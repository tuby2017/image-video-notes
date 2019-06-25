#!/bin/bash
r1() {
ffmpeg -hide_banner -y -i "${1}" -vf scale=640:261 -crf 28 "${2}";}
r2() {
#smartresize() {
	convert -filter Triangle -define filter:support=2 -thumbnail 640x -unsharp 0.25x0.08+8.3+0.045 -dither None -posterize 136 -quality 82 -define jpeg:fancy-upsampling=off -define png:compression-filter=5 -define png:compression-level=9 -define png:compression-strategy=1 -define png:exclude-chunk=all -interlace none -colorspace sRGB "${1}" "${2}"
# smartresize inputfile.png 300 outputdir/
}
r3() { #best quailty but not filesize
convert "${1}" -resize 640x -unsharp 0x0.55+0.55+0.008 -quality 90% "${2}";}

s1() {
convert -strip -resize 640x -interlace Plane -gaussian-blur 0.05 -quality 85% "${1}" "${2}";}
s2() { #second best
convert "${1}" -resize 640x -sampling-factor 4:2:0 -strip -quality 85 -interlace JPEG -colorspace RGB "${2}";}
s3() {
convert -quality 97% -resize 640x -filter Lanczos -interlace Plane -gaussian-blur 0.05 "${1}" "${2}";}
s4() {
convert -strip -interlace Plane -gaussian-blur 0.05 -quality 60% -adaptive-resize 640x "${1}" "${2}";}
s5() {
convert "${1}" -resize 640x -define jpeg:extent=10kb "${2}";}

in="${1}"
i2=$(echo $in|cut -d. -f1)
outdir=../scale/$i2

[[ `pwd` =~ "frames" ]] && c=1||c=0 
[[ $c == 0 ]] && exit

for x in {1..3}; do
r$x $in $outdir-r$x.jpeg && echo r$x
done


for x in {1..5}; do
s$x $in $outdir-s$x.jpeg && echo s$x
done 
exit

: << '@nnouse'
@nnouse
