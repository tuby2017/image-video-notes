#!/bin/bash
: << '@nouse'
###eyelist
ffprobe -v error -count_frames -select_streams v:0 -show_entries stream=nb_read_frames -of default=nokey=1:noprint_wrappers=1 input.mkv

rm frame
for i in e*mp4;do z=$(ffprobe -v error -count_frames -select_streams v:0 -show_entries stream=nb_read_frames -of default=nokey=1:noprint_wrappers=1 $i);
f=$(echo $i|cut -d'.' -f1)
echo $f $z >> frame
done

total=0; for i in $( awk '{ print $2; }' frame );\
do total=$(echo $total+$i | bc ); 
done;echo $total

ffmpeg -i input.mp4 -vf "fade=in:0:25,fade=out:975:25:alpha=1" -acodec copy out.mp4

###gimp grayscale zoom blur normal-plasma linearlight( or soft/hardlight, hardmix,grain extract) over
#same zoom blur color-plasma, multiply over blured white mask(blurleftdown.jpg)

exit
###pound-st-c
# convert c9.jpg -crop 0x360+0+145 ca/cc.jpg
for i in c*.jpg;do
convert $i -crop 0x360+0+145 ca/$i
done
cd ca/;
ls c*jpg|sort -s -tc -k2,2n > clist
convert -delay 13 @clist 0.gif
ffmpeg -i 0.gif -r 12 0.mp4

exit
###eye
#convert r-2.jpg p-6.jpg -compose ModulusAdd -flatten -channel R -combine +channel -set colorspace HSB -colorspace RGB 0.jpg
#convert ../e-mask.jpg r-2.jpg -compose multiply -radial-blur 25 -motion-blur 12x5 -composite 0.jpg
test(){
convert -size 500x1000 -gravity center gradient: -rotate 90 -alpha set \
          -virtual-pixel Transparent +distort Polar 180 +repage \
          -transverse -radial-blur 50 -background black gradient_angle_masked.png
#          -radial-blur
convert gradient_angle_masked.png -gravity center -extent 540x360 -blur 35x30 -background black  em-c.jpg
timeout 1 mpv em-c.jpg
}
t2(){
for i in {1..11};do
angle=$((i*32))
convert -rotate $angle gradient_angle_masked.png -gravity center -extent 540x360 -blur 35x30 -background black  em-c$i.jpg
done
}
#t2;echo test;exit
@nouse
#####start
eyegif0() {
#using eclipse blur mask
mc=0
mx=11
for i in {0..11};do
mc=$((mc+1)); [[ $mc -gt $mx ]] && mc=1;
convert em-c$mc.jpg r-$i.jpg -compose multiply -composite r2-$i.jpg
composite ../E1.jpg r2-$i.jpg +swap -displace -13x15 d-$i.jpg
done
ls d*jpg|sort -s -t- -k2,2n > dlist
convert -delay 20 @dlist d.gif;mpv d.gif
#ffmpeg -i d.gif -r 12 d.mp4
exit
}

eyegif0() {
#using randcolor sine
for i in {0..11};do
convert ../e-mask.jpg r-$i.jpg -compose multiply -blur 5x3 -composite r2-$i.jpg
convert r2-$i.jpg p-63.jpg -compose multiply -flatten -channel R -combine +channel -set colorspace HSB -colorspace RGB r3-$i.jpg 
composite ../E1.jpg r3-$i.jpg +swap -displace -13x5 d-$i.jpg
#composite ../E1.jpg r2-$i.jpg +swap -displace -13x5 d-$i.jpg
done
convert -delay 20 @dlist d.gif;mpv d.gif
exit
}

eyegif() {
#using mask or not
#composite ../E1.jpg r-2.jpg +swap -displace -2x3 d.jpg
for i in {0..11};do
#composite ../E1.jpg r-$i.jpg +swap -displace -13x1 d-$i.jpg #no mask applied
convert ../e-mask.jpg r-$i.jpg -compose multiply -composite -blur 1x2 r2-$i.jpg
composite ../E1.jpg r2-$i.jpg +swap -displace -7x5 d-$i.jpg
done
ls d*jpg|sort -s -t- -k2,2n > dlist
convert -delay 20 @dlist d.gif;mpv d.gif
#ffmpeg -i d.gif -r 12 d.mp4
exit
}
eyerand(){
convert -size 540x360 xc:   +noise Random   random.png
convert random.png -virtual-pixel tile  -blur 0x10 -auto-level random_10.png
convert random_10.png  -channel G  -separate   random_10_gray.png
#convert random_10_gray.png  -function Sinusoid 1,90   ripples_1.png
}
eyerand0(){
convert -size 540x360 xc:   +noise Random \
	-virtual-pixel tile  -blur 0x10 -auto-level -separate -background white \
	-compose ModulusAdd -flatten -channel R -combine +channel \
	-set colorspace HSB -colorspace RGB -spread 70 random_10_gray.png
}

eyejpg(){
for i in `seq 0 30 359`; do
#    convert random_10_gray.png -function Sinusoid 3.5,${i} miff:-
# -channel R -sigmoidal-contrast 10,50% -level 55%
    convert random_10_gray.png -function Sinusoid 10.5,${i} miff:-
  done |
#    convert miff:- -set delay 15 -loop 0 ripples_anim.gif
#    convert miff:- -radial-blur 90 r.jpg
#    convert miff:- -swirl 180 -blur 0x5 r.jpg
#	convert miff:- -blur 0x5 -swirl 80 -flip r.jpg
convert miff:- -radial-blur 10 -blur 2x5 -colorspace gray r.jpg

}
#eyerand
[[ -z "$1" ]] && exit
[[ "$1" -eq '1' ]] && eyerand
[[ "$1" -eq '2' ]] && eyejpg
[[ "$1" -eq '3' ]] && eyegif
case "$1" in
12|z)
	eyerand;eyejpg ;;	
23|b)
	eyejpg;eyegif ;;		
a|123)
	eyerand;eyejpg;eyegif  ;;	
*)
	exit
	;;	
esac

#eyegif    
#eyejpg
exit
######


#woman
#ls w*jpg|sort -s -tw -k1,1n > wlist.txt
convert -delay 11 @wlist.txt 1.gif
ffmpeg -i 1.gif -filter:v "minterpolate='mi_mode=mci:me_mode=bilat:vsbmc=1:fps=12'" -y 1.mp4
exit

#montain
convert -delay 11 @list2 0.gif
ffmpeg -i 0.gif -filter:v "minterpolate='mi_mode=mci:me=fss:fps=12" -y 0.mp4
mpv 0.mp4
exit

rm t/*;
convert @list -morph 20 t/m.jpg
cd t/;
ls m-*jpg|sort -s -t- -k2,2n > list.txt
sed -i "s/.*/file '&'/" list.txt
#convert -delay 14 
ffmpeg -f concat -i list.txt -c:v libx264 -an -r 5.5 -y 0.mp4;mpv 0.mp4
#cd ..
exit
#640x317
#640x360
tac list|xsel -b
