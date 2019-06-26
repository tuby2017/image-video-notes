#!/usr/bin/env bash
# edge detection (and watercolor, fred script) on image. 1(or 2) outputs
# usage: ./wnline.sh img.jpg #output: img-ln.jpg
rz=35 #resize or not by #
input="$1";
# check input
if [ ! -f "$input" ]; then echo "null file;nothing done";exit 1; fi
ex=".${input##*.}" #file extension
filename=$(basename -- "$input")
output="${filename%.*}"
a="$output"-wc$ex; b="$output"-ln$ex
tmpr="/tmp/resize".png
tmpf="/tmp/sharpen".png
shlgPath=~/Downloads/blueBloom/shadowhighlight 

trap "rm -f $tmpr $tmpf" 0 2 3 15 
imgWH=$(identify -format "%[fx:w]x%[fx:h]" $input)
[ -z $rz ] || convert -resize "$rz"% $input $tmpr;
[ ! -f $tmpr ] && tmpr=$input
echo -e 'sharpen \c';
$shlgPath -sa 60 -ha 60 -ma 70 $tmpr $tmpf;echo -e ' done; \c';
[ ! -f $tmpf ] && tmpf=$input; #if var not exist
#echo -e 'watercolor...\c'; ./watercolor -s 15 -e 5 -m 33 -c 5 $tmpf $a;echo $a' done'
convert $tmpf -colorspace gray -canny 0x1+10%+30% -negate $b;echo $b' done'
mogrify -resize "$imgWH" -filter triangle -posterize 24 -quality 75 $b 
exit

##end
##test
cd line; 
for i in ../mpv-*jpg;do ../wnline.sh $i;done
