#!/bin/bash
inp="${1}"
outp="${2}"
crp='crop=iw:ih-40'
x1(){
ffmpeg -i "${inp}" \
-filter_complex \
"[0:v]$crp,transpose=2,vflip[a]; \
[0:v]$crp,transpose=3,vflip[b]; \
[a][b]hstack,split[u][n]; \
[n]vflip[j]; \
[u][j]vstack,transpose[v]" \
-map "[v]" -y "${outp}.jpg"
}
#crp='crop=iw:ih-13'
x2(){
ffmpeg -i "${inp}" \
-filter_complex \
"[0:v]$crp,transpose=2,vflip[a]; \
[0:v]$crp,transpose=3,vflip[b]; \
[b][a]hstack,split[u][n]; \
[n]vflip[j]; \
[u][j]vstack,transpose[v]" \
-map "[v]" -y "${outp}.jpg"
}
x3(){
ffmpeg -i "${inp}" \
-filter_complex \
"[0:v]$crp,transpose=1,vflip[a]; \
[0:v]$crp,transpose=2,vflip[b]; \
[b][a]hstack,split[u][n]; \
[n]vflip[j]; \
[u][j]vstack,transpose[v]" \
-map "[v]" -y "${outp}.jpg"
}
x4(){
ffmpeg -i "${inp}" -filter_complex \
"[0:v]$crp,transpose=1,vflip[a]; \
[0:v]$crp,transpose=2,vflip[b]; \
[b][a]hstack,split[u][n]; \
[n]vflip[j]; \
[u][j]hstack,vflip[v]" \
-map "[v]" -y "${outp}.jpg"
}
x5(){
ffmpeg -i "${inp}" -filter_complex \
"[0:v]$crp,split[a][b]; \
[a][b]hstack,split[u][n]; \
[n]hflip,vflip[j]; \
[u][j]vstack[v]" \
-map "[v]" -y "${outp}.jpg"
}

j2(){
echo "${inp} ${outp}.j"
}
crp='crop=iw-125:ih-140'
crp='crop=iw-280:ih-210'
#crp='crop=iw-150:ih-200'
z3x(){
ffmpeg -i "${inp}" \
-filter_complex \
"[0:v]$crp,hflip[a]; \
[0:v]$crp,vflip[b]; \
[b][a]hstack,split[u][n]; \
[n]vflip[j]; \
[u][j]vstack[v]" \
-map "[v]" -y "${outp}.jpg"
}
z3(){
ffmpeg -i "${inp}" -filter_complex \
"[0:v]$crp,transpose=2,vflip[a]; \
[0:v]$crp,transpose=3,vflip[b]; \
[b][a]hstack,split[u][n]; \
[n]vflip[j]; \
[u][j]vstack,transpose[v]" \
-map "[v]" -y "${outp}.jpg"
}

z4(){
ffmpeg -i "${inp}" -filter_complex \
"[0:v]$crp,transpose=1,vflip[a]; \
[0:v]$crp,transpose=2[b]; \
[b][a]hstack,split[u][n]; \
[u][n]hstack,vflip[v]" \
-map "[v]" -y "${outp}.jpg"
}

z5x(){
ffmpeg -i "${inp}" -filter_complex \
"[0:v]$crp,transpose=1,hflip[a]; \
[0:v]$crp,transpose=2,hflip[b]; \
[b][a]hstack,split[u][n]; \
[n]hflip[j]; \
[u][j]hstack,vflip[v]" \
-map "[v]" -y "${outp}.jpg"
}
z5(){
ffmpeg -i "${inp}" -filter_complex \
"[0:v]$crp,transpose=3[a]; \
[0:v]$crp,transpose=2[b]; \
[a][b]hstack,split[u][n]; \
[u][n]hstack,vflip[v]" \
-map "[v]" -y "${outp}.jpg"
}

##manual cli
#todir='br2-1'
todir='.'
#inp=dss; outp="$todir/2"; j2 $inp ${outp} ## dss br1/2.j; exit
u=5
#for u in {3..5};do
inp=mpv-shot0006.jpg
outp="$todir/xpv-6"
z$u $inp $outp;
#done
timeout 3 mpv $outp.jpg;
exit
####

inp=mpv-shot0006.jpg

for k in {1..5};do
outp="$todir/xpv-$k"
#echo $outp-$k.jpg
#touch $o-$k.txt
x$k $inp $outp
#sleep 1;
done
ls $todir;

exit
####
