#!/usr/bin/env bash
# usage: ./script.sh #apply effect on all jpeg from parent directory
# cd frames/new/; ls ../ # f0030.jpeg f0031 ...
export MAGICK_THREAD_LIMIT=2
s='-resize 40%'
s2='-resize 75%'
mx='close'
ad='-evaluate multiply 3'
jz=Zresize.jpeg
trap "rm -f Zresize.jpeg" 0 2 3 15 
  for j in ../*.jpeg;do
	filename=$(basename -- "$j"); #output="${filename%.*}"
	imgWH=$(identify -format "%[fx:w]x%[fx:h]" "$j");
b=$(convert $j -colorspace hsb  -resize 1x1 -format "%[fx:floor(100*b)]" info:-)
if [[ $b -gt 50 ]];then
#convert $j $s $ad $filename
#70> 10 60, 80> 20 60, 
 [[ $b -lt 80 ]] && es=10||es=20
 [[ $b -lt 70 ]] && es=30
 # possible fix for darker bright image
 [[ $es -eq 30 ]] && es2=$ad||es2='-evaluate subtract 60% -sigmoidal-contrast 9x60%'
	convert $s2 $j $jz
	convert \( $jz -evaluate subtract "$es"% -sigmoidal-contrast 9x45% -monochrome \) \
	\( $jz $es2 -monochrome \) \
	$s -compose Mathematics -define compose:args='0,1,1,-0.5' -composite \
	-morphology "$mx" cross:3 \
	-strip $filename;
	
	mogrify +dither -quality 75 -resize "$imgWH" $filename;
	echo $filename ' done';
#fi;done;exit
else 
	#[[ $b -gt 10 ]] && ad='-evaluate multiply 1.2'||ad='-evaluate multiply 3'
	convert $s $j $ad +dither -colors 3 -depth 4 -monochrome \
	-morphology "$mx" cross:3 -posterize 24 -filter triangle -quality 75 \
	$filename;
	mogrify -resize "$imgWH" $filename;
fi
echo $filename ' done';
  done
#exit
  for j in ../*.jpeg;do /home/sx/Downloads/Videos/wnline-2.sh $j;  done
  for j in f*-ln.jpeg;do
i="${j%-ln.*}.jpeg"
convert $i $j -compose multiply -composite z$i
  done
exit
######end

sn=1;fps=12;
bv=550;
ffmpeg -y -framerate "$fps" -start_number $sn -i f%04d.jpeg -c:v libx264 -q:v 2 -an -b:v "$bv"k d.mp4;mpv d.mp4

exit
86 f0016.jpg
76 f0017.jpg
76 f0019.jpg
80 f0030.jpg
95 f0031.jpg
87 f0032.jpg
80 f0033.jpg
77 f0034.jpg
87 f0035.jpg
78 f0036.jpg
87 f0038.jpg
99 f0039.jpg
88 f0040.jpg
87 f0041.jpg
99 f0042.jpg
84 f0043.jpg

#previous filters, discard
#dark
	convert $ad \( $j  -colors 2 -depth 4 -monochrome \) \
	\( $j +dither -colors 3 -depth 4 -monochrome \) \
	-compose Mathematics -define compose:args='0,1,1,-0.5' -composite \
	-morphology open octagon:2 \
	-posterize 24 -filter triangle -quality 75 \
	-strip $filename	
#bright
 convert \( $j -evaluate subtract "$es"% -sigmoidal-contrast 9x45% -monochrome \) \
\( $j -evaluate subtract 60% -sigmoidal-contrast 9x60% -monochrome \) \
$s -compose Mathematics -define compose:args='0,1,1,-0.5' -composite \
-morphology "$mx" cross:3 -posterize 24 -filter triangle -quality 75 \
-strip $filename

es2='-evaluate subtract 2% -sigmoidal-contrast 9x60%'

#v=videopath;ffmpeg -i $v -vf "fps=6" -q:v 5 -vsync vfr frames/f%05d.jpeg
#  for j in ../f{363..370}.jpeg;do
