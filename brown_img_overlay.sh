#!/bin/bash
#./ff all burn 9
# brown.jpg = #CF7831
a=$1
b=all
p=0.9 #p=0.47
f=$2
m=$(echo $a\_mode)
o=$(echo $b\_opacity)
d=-.$3

ffmpeg -hide_banner -loglevel panic -i ../temp.png \
-i ../b2.jpg \
-filter_complex "[1:0] setsar=sar=1,format=rgba,colorchannelmixer=aa=0.47 [1sared]; [0:0]format=rgba,setsar=sar=1 [0rgbd]; [1sared][0rgbd] \
blend=$m=$f \
:repeatlast=1: \
$o=$p \
,format=yuva422p10le [out]" -map "[out]" -y o3.jpg
convert o3.jpg ../temp-2.jpg +append o3.jpg
timeout 1.3 mpv --no-terminal o3.jpg

exit 1
####
ffmpeg -hide_banner -i ../brown.jpg -vf "movie=../temp.png [fix]; [in] setsar=sar=1,format=rgba [inf]; [inf][fix] \
blend=$m=$f \
:$o=$p [out]" -y o3.jpg;
timeout 1.4 mpv o3.jpg

: << '@nouse'
ffmpeg -i ../temp.png -i ../brown.jpg \
-filter_complex "[1]setsar=sar=1,format=rgba,colorchannelmixer=aa=0.5[a];[0][a]overlay" -y o3.jpg;

ffmpeg -i video.mp4 -f lavfi -i "color=red:s=1280x720" \
-filter_complex "[0:v]setsar=sar=1/1[s];\
[s][1:v]blend=shortest=1:all_mode=overlay:all_opacity=0.7[out]" \
-map [out] -map 0:a output.mp4

##this one
ffmpeg -i ../temp.png -i ../brown.jpg \
-filter_complex "[1:0] setsar=sar=1,format=rgba,colorchannelmixer=aa=0.47 [1sared]; [0:0]format=rgba,setsar=sar=1 [0rgbd]; [0rgbd][1sared]blend=all_mode='burn':repeatlast=1:all_opacity=0.47,format=yuva422p10le " -y o3.jpg

@nouse
