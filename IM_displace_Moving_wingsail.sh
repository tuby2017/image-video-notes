#!/bin/bash
#replace frame ..15
is='422x286' #img size
ps=422 #plasma canvas size
plasma(){
rm p-noise/*
for i in {1..15};do
outimg="p-noise/p-$i"
convert -size "$ps"x"$ps" plasma:fractal \
	-channel G -separate \( +clone -spread 150 \) \
	-compose overlay -composite \
	-crop $is -colorspace Gray -blur 0x5 $outimg.jpg
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
composite s2.jpg mask/p-$i.jpg +swap -displace 5x5 dis/d-$i.jpg
done
convert -delay 20 dis/d-*.jpg dis/d.gif;mpv dis/d.gif
#cd dis/;ffmpeg -i d.gif d.mp4; rm d.gif
#debug
#composite s2.jpg p-noise/p-19.jpg +swap -displace 1x2.5 dis/d-1.jpg
}

#plasma 
#mask;
displace
#plasma;mask;displace
exit
