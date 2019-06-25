#!/bin/bash
#replace frame ..15
is='540x360' #img size
ps=540 #plasma canvas size
list(){
ls "$1"*jpg|sort -s -t- -k2,2n > list.txt
}

plasma(){
rm p-noise/*
for i in {1..15};do
outimg="p-noise/p-$i"
convert -size "$ps"x"$ps" plasma:fractal \
	-channel G -separate \( +clone -spread 60 \) \
	-compose overlay -composite \
	-crop $is -colorspace Gray -blur 0x2 $outimg.jpg
done
#rm p-noise/p-*-[0,1].jpg
rm p-noise/p-*-1.jpg
rename 's/-0.jpg/.jpg/g' p-noise/p-*.jpg
echo done;
}
mask(){
rm mask/*
#applied to new mask, reuse without plasma
for i in {1..15};do outimg="p-$i.jpg";
convert p-noise/$outimg m2.jpg -compose multiply -composite mask/$outimg
done
echo Done;
}

displace(){
###### dis/
rm dis/*
for i in {1..15};do 
composite s2.jpg mask/p-$i.jpg +swap -displace 5x37 -background white dis/d-$i.jpg
done
#convert -delay 20 dis/d-*.jpg dis/d.gif;mpv dis/d.gif
#here
cd dis
list d;
sed -i "s/.*/file '&'/" list.txt
ffmpeg -r 5.5 -f concat -i list.txt -c:v libx264 -vf hflip,vflip -an -r 12 -y d.mp4;mpv d.mp4
}

#plasma;exit
#mask;
displace
#plasma;mask;displace
exit
##############
#replace frame ..22
is='540x360' #img size
ps=540 #plasma canvas size
key=3 #key frames
inb=5 #morph inbetween frames
plasma(){
rm p-noise/*
for i in $(seq 1 $key);do
outimg="p-noise/p-$i"
convert -size "$ps"x"$ps" xc:   +noise Random \
	-virtual-pixel tile  -blur 0x10 -auto-level -separate -background white \
	-compose ModulusAdd -flatten -channel R -combine +channel \
	-set colorspace HSB -colorspace RGB -crop $is $outimg.jpg
done
rm p-noise/p-*-1.jpg
rename 's/-0.jpg/.jpg/g' p-noise/p-*.jpg
echo done;
}
mask(){
rm -r mask/;mkdir mask
#applied to new mask, reuse without plasma
for i in $(seq 1 $key);do outimg="p-$i.jpg";
convert p-noise/$outimg m2.jpg -compose multiply -composite mask/$outimg
done
cd mask;mkdir t/;
list p;
echo p-1.jpg >> list.txt
convert @list.txt -morph $inb t/m.jpg
cd ../;
echo Done;
}

displace(){
###### dis/
rm dis/*
cd mask/t;
list m;
j=$(cat list.txt|wc -l)
j=$((j-3))
echo -e "\033[0;7m $j \033[0m"
cd ../ ;
for i in $(seq 1 $j);do 
composite ../s2.jpg t/m-$i.jpg +swap -displace -5x7 ../dis/d-$i.jpg
done
cd ../dis
list d;
sed -i "s/.*/file '&'/" list.txt
#convert -delay 12 @list.txt d.gif;
#ffmpeg -i d.gif d.mp4; rm d.gif;mpv d.mp4
ffmpeg -r 5.5 -f concat -i list.txt -c:v libx264 -an -r 12 -y d.mp4;mpv d.mp4
#cd dis/;
#debug
#composite s2.jpg p-noise/p-19.jpg +swap -displace 1x2.5 dis/d-1.jpg
}

all() {
plasma;mask;displace;
exit;
}

##manual
all
#plasma 
#mask;
displace
#plasma;mask;displace
exit;
exit;
convert -delay 22 p-1.jpg p-2.jpg p-3.jpg -morph 5 t/m.jpg
convert p-*.jpg -morph 5 t/m.jpg
convert ../s2.jpg t/t.gif -compose multiply -composite t/d.gif
composite s2.jpg t.gif +swap -displace -5x7 d.gif
