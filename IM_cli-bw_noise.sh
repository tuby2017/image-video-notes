#!/bin/bash
#leftdown mask noise, attempt. not eye, no sine
#mkdir th/
is='500x300' #img size
ps=500 #plasma canvas size
key=12
f=0; # for eyerandc and eyej2
#https://gist.github.com/adsr303/8710833
# apply to bright: -define compose:args='0,-1,1,0.5' -composite
# apply to dark: compose:args='0,1,1,-0.5' -composite
#https://www.imagemagick.org/discourse-server/viewtopic.php?t=11304
# for i in r2-*jpg;do echo "";convert $i -colorspace Gray -format "%[fx:image.mean]" info:| cut -c3-4;done

test(){
b="0,-1,1,0.5"
i=2;
convert rc.jpg r2-"$i".jpg \
\( -compose mathematics -define compose:args="$b" \) -composite \
r3-"$i".jpg
#echo done;
}

#t2;t3
#test;exit

#[[ ! -d "th" ]] && exit
[[ $(pwd|grep jh) ]] || cd jh/;

eyedis0() {
for i in $(seq 1 $key); do
composite ../blurleftdown.jpg \( -gravity southwest r3-$i.jpg \) +swap -compose multiply d-$i.jpg
composite r2-"$i".jpg d-$i.jpg +swap -compose linearlight d-$i.jpg
done
exit ##
}
eyedis() {
for i in $(seq 1 $key); do
#convert r-$i.jpg -motion-blur 30x20+135 r2-$i.jpg 
b=$(convert r2-$i.jpg -format "%[fx:image.mean]" info:| cut -c3) #brightness
[[ $b -gt 4 ]] && c=$(echo "0,-1,1,0.5") #is bright
[[ $b -lt 5 ]] && c=$(echo "0,1,1,-0.5") #is dark

convert rc-"$i".jpg r2-"$i".jpg \
\( -compose mathematics -define compose:args="$c" \) -composite \
r3-"$i".jpg 
#composite rc.jpg r2-$i.jpg -compose softlight r3-$i.jpg
composite ../blurleftdown.jpg \( -gravity southwest r3-$i.jpg \) +swap -compose multiply d-$i.jpg
composite \( -gravity southwest r2-"$i".jpg \) d-$i.jpg +swap -compose softlight d-$i.jpg
done
exit ##
}

eyegif(){
ls d-*jpg|shuf > dlist
convert -delay 13 @dlist 0.gif
#exit
sed "s/.*/file '&'/" dlist > list.txt
ffmpeg -y -f concat -i list.txt -r 12 d.mp4; mpv d.mp4
exit
}

eyegif0(){
ls d*jpg|sort -s -t- -k2,2n > dlist
convert -delay 15 @dlist 0.gif
#ls d-*jpg|sort -s -t- -k2,2n > list.txt
sed "s/.*/file '&'/" dlist > list.txt
ffmpeg -y -f concat -i list.txt -r 12 d.mp4; mpv d.mp4
exit
}

eyerandjpg(){
for i in $(seq 1 $key);do
outimg="r-$i"
convert -size "$ps"x"$ps" plasma:fractal \
	-channel G -separate \( +clone -spread 360 \) \
	-compose softlight -composite \
	-colorspace Gray \
	-gravity center -crop 640x360+0+0\! \
	-motion-blur 25x45+135 $outimg.jpg

convert -size "$is" xc: +noise Random  \
          -channel G -threshold 5% -negate \
          -channel RG -separate +channel \
          -compose CopyOpacity -composite  \
          -virtual-pixel tile  -blur 0x3  -auto-level \
          $outimg.png
composite $outimg.jpg $outimg.png -compose overlay r2-$i.jpg
done;          
echo Done
} ;

calf(){
[[ $((key%4)) -eq 0 ]] && f=$((key/4)) || f=$((key/4+1))
echo $f
return $f
}

eyerandc(){
echo $f;
for i in $(seq 1 $f);do
convert -size "$is" xc:   +noise Random \
	-virtual-pixel tile  -blur 0x10 -auto-level -separate -background white \
	-compose ModulusAdd -flatten -channel R -combine +channel \
	-set colorspace HSB -colorspace RGB -colorspace gray random_c-$i.png
done
}

eyej2(){
for i in $(seq 1 $f);do
../polarblur -r 25 -a 10 random_c-$i.png rc0-$i.jpg
../zoomblur -a 1.2 rc0-$i.jpg rc1-$i.jpg
convert rc1-$i.jpg -blur 3x12 rc1-$i.jpg
#convert random_c.png -motion-blur 30x50+135 rc.jpg 
done
#rotate or flip
n=1
for i in $(seq 1 $f);do
mv rc1-$i.jpg rc-$n.jpg
convert rc-$n.jpg -rotate 180 rc-$((n+1)).jpg
convert rc-$n.jpg -flip rc-$((n+2)).jpg
convert rc-$n.jpg -flip -rotate 180 rc-$((n+3)).jpg 
n=$((n+4))
done
}

#cli
[[ -z "$1" ]] && exit
f=$(calf)
[[ "$1" -eq '2' ]] && eyerandc;
[[ "$1" -eq '3' ]] && eyedis;
case "$1" in
j|22)
	eyej2 ;;
1|z)
	eyerandjpg ;;	
23|b)
	eyerandjpg;eyedis ;;		
a|123)
	eyerandjpg;eyerandc;eyej2;eyedis  ;;	
[4gm])
	eyegif ;;
*)
	exit
	;;	
esac
exit
