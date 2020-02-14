#!/bin/bash
####. func.sh;
a="v1.mp4"
e=${a##*.}
n="${a%.*}"
b=$n-cut.$e
# $a has spaces
[[ "$a" =~ \ |\' ]] &&  n="${n//[[:space:]]/_}"
###c=$n-$1.mp4
echo -e "$a\n$b\n$n.$e"
#exit
## function usage:
# mx 4
##		move $a_filename-cut.mp4 to $a_filename-4.mp4
# fx 1:30 6
##		cut $a vid from 1 min 30 to 1:36, 6 seconds
# fx2 1:30 1:36
##		same above, but auto calculate duration from second input (under 1hr only!) 
#  px
##		mpv play speeduped $a_filename-cut.mp4
# lx
##		list and sort "$a_filename-", lx>list output to file
# lx2
##		insert file ' ' to the list
# lx3
##		combine video from the list 
# lxAll
##		combine above lx
# rx
##		remove files '$a_filename-' except last result from ls.
# cx time_file
##		cut timestamps from a file, output to '$a_filename-##.mp4'
##		1:30 2:20
##		4:45 7:04
# cxy time_file
##		re-encode timestamps from a file, same format above.
 
mx(){ 
mv "$b" "$n-$1.$e"
}
fx(){
yes|ff c "$a" $1 $2
px
}

fx2(){
in_time=`date +%m%s -d "$1"`
out_time=`date +%m%s -d "$2"`
out_sec=$(( (out_time-in_time)/60))
yes|ff c "$a" $1 $out_sec
px
}

px(){
mpv --quiet --loop=inf --speed=2.5 --osd-level=3 "$b"
}
px0(){
echo hi
}
lx(){
lsg "$n-"|sort -V
}

lx2(){
[[ ! -f list ]] && return
sed -i "s/.*/file '&'/" list
}

lx3(){
ff l list "$n-z.$e"
}
lxAll(){
lx >list;lx2;lx3;}

rx(){
 lx|head -n-1
 read -p "Continue (y/n)?" choice
 case "$choice" in 
  0|y|Y ) echo "remove"; rm `lx|head -n-1`;echo 'done';;
  * ) echo "invalid";return;;
 esac
}
cx(){
[[ ! -f $1 ]] && return
f=/tmp/c1
sed '/^$/d' $1|tr -s ';' ':' > $f
cutnum=`cat $f |wc -l`
cutnum=$((cutnum-1))
[[ $cutnum -eq 0 ]] && return
mapfile -t s < <(cut -d' ' -f1 $f)
mapfile -t s1 < <(cut -d' ' -f1 $f|xargs -L1 date +%m%s -d)
mapfile -t s2 < <(cut -d' ' -f2 $f|xargs -L1 date +%m%s -d)

#b=`date --date="0:38" +%m%s`
#a=`date +%m%s -d "0:50"`
#echo $(( (a-b)/60))

for x in $(seq 0 $cutnum); do
 t=$(( (${s2[$x]}-${s1[$x]})/60))
 #echo "${s[$x]}" "$t"
 yes|ff c "$a" "${s[$x]}" "$t"
 
 sleep 1
 mv "$b" "$n-$x.$e" #&& sleep 1
done 
}

cxy(){
[[ ! -f $1 ]] && return
f=/tmp/c1
sed '/^$/d' $1|tr -s ';' ':' > $f
cutnum=`cat $f |wc -l`
cutnum=$((cutnum-1))
[[ $cutnum -eq 0 ]] && return
mapfile -t s < <(cut -d' ' -f1 $f)
mapfile -t t2 < <(cut -d' ' -f2 $f)

for x in $(seq 0 $cutnum); do
 #yes|ffmpeg -i $a -ss ${s[$x]} -to ${t2[$x]} -c copy $b #fix wrong duration
 yes| ffmpeg -i "$a" -ss ${s[$x]} -to ${t2[$x]} \
 -vf scale=640:-1 -threads 2 -map_metadata -1 \
 -c:v libx264 -b:v 1800k -c:a aac "$b"
 #[[ $x -eq 3 ]] && return

 sleep 1
 mv "$b" "$n-$x.$e" #&& sleep 1
done 
}

: << '@nouse'
 yes|ffmpeg -i $a -ss ${s[$x]} -strict -2 -t ${t} \
 -map_metadata -1 -c:v libx264 -b:v 800k \
 -vf mpdecimate,setpts=N/30/TB,scale=640:-1 \
 -c:a aac -async 1 -threads 2 $b
@nouse

#ffmpeg -i mp.mp4 -ss 8:53 -to 9:01 -vf scale=640:-1 -threads 2 -map_metadata -1 -c:v libx264 -b:v 1800k -c:a aac mp-throat.mp4
