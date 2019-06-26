#!/usr/bin/env bash
# watercolor and edge detection on image. 2 outputs
rz=40
#sharpen=y
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
if [ ! -z $sharpen ];then
echo -e 'sharpen \c'; $shlgPath -sa 60 -ha 60 -ma 70 $tmpr $tmpf;echo -e ' done; \c';fi

[[ -f $tmpr && ! -f $tmpf ]] && tmpf=$tmpr
[ ! -f $tmpf ] && tmpf=$input; #if var not exist

#echo -e 'watercolor...\c'; ./watercolor -s 15 -e 5 -m 33 -c 5 $tmpf $a;echo $a' done'
convert $tmpf -colorspace gray -canny 0x1+10%+30% -negate $b;echo $b' done'
mogrify -resize "$imgWH" -filter triangle -posterize 24 -quality 75 $b 
exit

##end
##test
cd line; 
for i in ../b*jpeg;do ./wnline.sh $i;done
#smoke image
convert $z -evaluate subtract 30% -colorspace gray \
-sigmoidal-contrast 42x45% -monochrome \
x.jpg
mogrify -depth 2 -morphology open cross:2 x.jpg 
#vid
ffmpeg -i $v -vf "fps=6" -q:v 5 -vsync vfr frames/f%03d.jpeg
sn=1;fps=6;
bv=1000;
ffmpeg -y -framerate "$fps" -start_number $sn -i f%03d-ln.jpeg -c:v libx264 -q:v 2 -an -b:v "$bv"k d.mp4;mpv d.mp4

#kda
convert $z -colorspace gray -sigmoidal-contrast 41x21% -monochrome x.jpg
a=(41x45 41x11)
for i in {1..2};do
  for j in ../f*jpg;do
	filename=$(basename -- "$j"); output="${filename%.*}"
	convert $j -colorspace gray -sigmoidal-contrast "${a[i]}"% $output-$i.jpg
  done
done
mkdir new;cd new;
for i in ../f*jpg;do /home/sx/Downloads/Videos/wnline-2.sh $i;done
	#f0001-1-ln.jpg, f0001-2-ln.jpg
for i in *-1-ln.jpg;do
	j=$(echo $i|cut -d- -f1)
	s=$(echo $j|sed 's/$/-2-ln.jpg/g')
	o=$(echo $j|sed 's/$/-ln.jpg/g')
	convert $i $s -compose multiply -composite $o
done
convert $z -evaluate subtract 7% -colorspace gray -sigmoidal-contrast 3x65% -monochrome -filter triangle -quality 75 -strip x.jpg 
#jojo
convert $b   -morphology Thicken ConvexHull  $c
convert $z -resize 45% -evaluate subtract 7% -colorspace gray \
	-sigmoidal-contrast 3x65% \
	+dither -colors 6 -depth 4 -morphology close octagon:3 \
	-filter triangle -quality 75 -strip x.jpg
convert $z -resize 40% -monochrome -filter triangle -quality 75 -posterize 4 -strip  x.jpg
#shield hero
-resize 40%
convert $z -colorspace gray \
+dither -colors 12 -depth 4 -morphology close octagon:3 \
-filter triangle -quality 75 -strip x2.jpg

convert $z -evaluate multiply 3 +dither -colors 3 -depth 4 -monochrome -morphology close cross:2 x.jpeg

x=close
convert $z -evaluate subtract 10% +dither -colors 16 -depth 4 -morphology $x cross:2 -sigmoidal-contrast 9x45% -monochrome -filter triangle -quality 75 -strip x2.jpeg
	#9x60% x.jpeg
convert x.jpeg x2.jpeg -compose Mathematics -define compose:args='0,1,1,-0.5' -composite x2.jpg
