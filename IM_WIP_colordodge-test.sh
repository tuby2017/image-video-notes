#!/bin/bash
#blur color noise overlay > bw noise vividlight multiply > mask
is='397x264' #img size
#ps=$(echo $is|cut -dx -f1) #plasma canvas size
#psw=$(echo $is|cut -dx -f2)
ps=397;psw=264;
mask=../0-mask.jpg
pic=../0-pic.jpg
fps=7 #for mp4
total=11 #=2(x-1)+x, key=x,inb=2
#inb=1
#echo $((inb*(key-1)+key)) "=$total"
#key=$(((total+inb)/(inb+1))) #2x-2+x=3x-2=$total, total+2/3=x
#echo "a=305; b=15; if ( a%b ) a/b+1 else a/b" | bc
#key=$(echo "a=$((total+inb)); b=$((inb+1)); if ( a%b ) a/b+1 else a/b" | bc)
#keytotal=$((inb*(key-1)+key)) #this should always bigger or equal to $total

test(){
#for i in $(seq 1 $key);do
for i in $(seq 1 $total);do
outimg="r-$i"
#bw
convert -size "$ps"x"$ps" plasma:fractal \
	-channel R -separate \( +clone -spread 160 \) \
	-compose softlight -composite \
	-colorspace Gray \
	-gravity center -crop "$is"+0+0\! \
	$outimg.jpg
mogrify -motion-blur 2x8+351 $outimg.jpg  #+201 or 351 

#color
convert -size "$is" xc: +noise Random  \
          -virtual-pixel tile  -blur 0x10 -auto-level \
          -set colorspace HSB \
          -channel G -evaluate set 100% +channel \
          -colorspace RGB -colorspace gray \
          $outimg.jpeg

x="r2-$i.jpg";

composite $outimg.jpg $outimg.jpeg -compose vividlight $x
composite $x "$mask" -compose softlight $x
mogrify -fuzz 5% -fill "#494949" -opaque "#979797" $x 
mogrify -motion-blur 2x28+351 $x
convert $x -morphology erodeIntensity Octagon:4 $x
#composite $x "$pic" -compose colordodge d-$i.jpg
done;
ffmpeg -y -framerate "$fps" -i r2-%d.jpg -c:v mpeg4 -an d.mp4
echo Done
mpv d.mp4
exit;exit;

#ls r2*jpg >> mlist #not sorted
#convert @mlist -morph $inb m.jpg
#last frame blend to first one
lstf="r2-$total.jpg" #[[ $keytotal != $total ]] && 
composite -blend 50 -gravity center $lstf r2-1.jpg $lstf
#ls m-*jpg|sort -s -t- -k2,2n > dlist #number sorted
for i in r2-*jpg;do composite $i "$pic" -compose colordodge d$i;done
#rm [m]-[$total..$keytotal].jpg [dm]-[$total..$keytotal].jpg
} ;
test;exit

: << '@nouse'
b=$(convert $outimg.jpg -format "%[fx:image.mean]" info:| cut -c3) #brightness
[[ $b -gt 4 ]] && c=$(echo "0,-1,1,0.5") #is bright
[[ $b -lt 5 ]] && c=$(echo "0,1,1,-0.5") #is dark
convert $outimg.jpg -define compose:args="$c" $x

t2(){ 
convert $in \
          \( +clone -flop +clone \) +append \
          \( +clone -flip +clone \) -append \
          -gravity center -crop "$is"+0+0\! \
          $out
convert $in -set option:distort:viewport "$is"-$((ps/2))-$((psw/2)) \
          -virtual-pixel tile  -distort Arc '45 0 50' +repage \
          $out

convert flux_anim.gif -threshold 70% flux_thres_anim.gif
convert flux_anim.gif  \
          -sigmoidal-contrast 30x50% -solarize 50% -auto-level \
          -set delay 20 filaments_anim.gif
convert random_10.png -set colorspace HSB \
          -channel GB -evaluate set 100% +channel \
          -colorspace RGB random_hues_cyan.png                    };
shimmer(){
 -f ... frames ... number of frames to generate in the animation; integer>0; default=15
-d ... delay .... animation delay between frames; integer>0; default=5
-r ... rate ..... rate of change in chirp wavelength; integer>0; default=3
-a ... amount ... displacement amount; integer>0; default=10
-F ... fcolor ... fade color for the reflection; any valid opaque IM color is
................. allowed; default=no fade; typical color is white.

for ((k=0; k convert $tmp1A -write mpr:img \
\( -size 1x${hh} xc: -fx "0.5*sin($k*2*pi/$frames+2*pi*(j/(0.5*h))^$rate)+0.5" -scale ${ww}x${hh}! \) \
-define compose:args=0,$amount -compose displace -composite -flip \
mpr:img +swap -append miff:-
done
) | convert -delay $delay - -loop 0 "$outfile"
exit
convert $in \( -size "$is" xc: -fx "0.5*sin(2*pi+2*pi*(j/(0.5*h))^3)+0.5" \) -define compose:args=0,$amount +swap -compose $z -composite $out
}
mesmerize(){
-s round -m normal -D out -c "red,blue" 
 -s diamond -m normal -D out -f 2 -c "red,blue" 
  -s diamond -m normal -D out -f 1 -c "red,blue" 
./mesmerize -s round -m normal -D in -i 27 -t 60 -c "black,pink" ap-grass.jpg mz1.gif && mpv mz1.gif 
-t 100 
}
t3(){composite $in.jpg $in.jpeg -compose vividlight x.jpg
composite x.jpg ../0-mask.jpg -compose softlight x-2.jpg
convert $in -morphology erodeIntensity Octagon:7 -motion-blur 12x40+351 $out
composite x-2.jpg ../0-pic.jpg -compose colordodge x-3.jpg
}

echo nnnnn
@nouse

gengif() {
# composite "$pic".jpg r-2.jpg +swap -displace -2x3 d.jpg
for i in $(seq 0 $key);do
x="r-$i.jpg";s="r2-$i.jpg"
#composite $x $z +swap -compose softlight $s
#mogrify +contrast +contrast $s
composite $x "$mask" -compose softlight $s
convert $s -morphology erodeIntensity Octagon:7 -motion-blur 3x18+351 $s
composite $s "$pic" -compose colordodge d-$i.jpg
done;          
ffmpeg -y -framerate "$fps" -i d-%d.jpg -c:v mpeg4 -an d.mp4;mpv d.mp4
##ffmpeg -y -framerate 6 -i d-%d.jpg d.webm
exit
}

genrand(){
input="random_10_gray"
convert -size "$ps"x"$ps" plasma:fractal \
	-channel R -separate \( +clone -spread 160 \) \
	-compose softlight -composite \
	-colorspace Gray \
	-gravity center -crop "$is"+0+0\! \
	$input.png
mogrify -motion-blur 2x8+351 $input.png

#color
convert -size "$is" xc: +noise Random  \
          -virtual-pixel tile  -blur 0x10 -auto-level \
          -set colorspace HSB \
          -channel G -evaluate set 100% +channel \
          -colorspace RGB -colorspace gray \
          $input-2.png

#composite $input.png $input-2.png -compose vividlight $input.png
          
}

genjpg(){
input="random_10_gray"
x=r
toEnd=$((key*50));
#for i in {1..2};do
for i in `seq 0 30 $toEnd`; do
  convert $input.png -channel R -level 9% -function Sinusoid 4.5,${i} miff:-
  done |
#    -radial-blur 90 -swirl 180 -blur 0x5 r.jpg
#	-blur 0x5 -swirl 80 -flip
convert miff:- $x.jpg
#input="$input-2";x=r2;done
}

### exec start here
[[ -z "$1" ]] && exit
[[ "$1" -eq '1' ]] && genrand
[[ "$1" -eq '2' ]] && genjpg
[[ "$1" -eq '3' ]] && gengif
case "$1" in
12|z)
	genrand;genjpg ;;	
23|b)
	genjpg;gengif ;;		
a|123)
	genrand;genjpg;gengif  ;;	
*)
	exit
	;;	
esac

exit

#https://en.wikibooks.org/wiki/FFMPEG_An_Intermediate_Guide/image_sequence
# https://unix.stackexchange.com/questions/168476/convert-a-float-to-the-next-integer-up-as-opposed-to-the-nearest
