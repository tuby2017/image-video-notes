#!/usr/bin/env bash
# usage: ./paperEmboss.sh input_file
exposure=10% # bigger value for more contrast, but grayer. 
shlgPath=~/Downloads/shadowhighlight  #'full_path/shadow'
input="$1";
# check input
if [ ! -f "$input" ]; then echo "null file;nothing done";exit 1; fi
filename=$(basename -- "$input")
ex=".${filename##*.}" #file extension
output="${filename%.*}-emboss$ex" 
# output to current_dir/filename-emboss.original_extension

 #a=ts;b=twc;c=t-edge;d=t-edge2;e=tshb;f=t-whiteEmboss
fname=(ts t-edge t-edge2 tshb t-whiteEmboss)
# export files to /tmp/
ct=-1;for i in {a..e};do ct=$ct+1; eval "$i=/tmp/${fname[$ct]}$ex";done

## start here
# check shadowhighligh, in bin, current folder, or $shlgPath.
shlg=shadowhighlight;
for p in $shlg ./$shlg $shlgPath; do 
 if which "$p" >/dev/null; then
 	xp="$p"; echo 'use '$xp
	$xp -sa 60 -ha 60 -ma 70 $input $a 	# sharpen, fred script;	
	break;
 fi
done
[ -z $xp ] && a=$input; #if not, skip 
# edge detect
convert $a -colorspace gray -canny 0x1+10%+30% $b 
# thicker edge
convert $b \
          \( -clone 0 -roll +1+0 -clone 0 -compose difference -composite \) \
          \( -clone 0 -roll +0+1 -clone 0 -compose difference -composite \) \
          -delete 0  -compose screen -composite $c
# add blur shadding
convert $c  -blur 0x2 -shade   90x75   $d
# emboss like looks
convert $d $c \
          -alpha Off -compose CopyOpacity -composite \
          -evaluate subtract "$exposure" $e
# if transparent, flatten
picinfo=$(identify -format '%[channels]\n' $e)
[[ $picinfo =~ "a" ]] && mogrify -flatten -background white $e;
# move image to current folder
mv $e $output; echo "output filename: $output "
exit
