#!/bin/bash
####. func.sh;
a="v2.mp4"
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
# cxz time_file
##		cut timestamps from a file, auto convert timestamp format to H:M:S.N
# fcx time_file
##		timestamp formate like fx() in seconds
##		1:30 16
##		4:45 6

 
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
out_sec=$(( (10#$out_time-10#$in_time)/60))
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
[[ ! -f $1 ]] && return
sed -i "s/.*/file '&'/" $1
}

lx3(){
ff l $1 "$n-z.$e"
}
lxAll(){
rm "$n-z.$e"
vidlist=$1
lx > $vidlist;lx2 $1;lx3 $1;}

rx(){
 lx|head -n-1
 read -p "Continue (y/n)?" choice
 case "$choice" in 
  0|y|Y ) echo "remove"; rm `lx|head -n-1`;echo 'done';;
  * ) echo "invalid";return;;
 esac
}

readTime(){
#check/convert timestamp format H:M:S.N
cut -d' ' -f$1 $2| while read t1;do 
t1c=`echo "$t1" |grep -o ":"|wc -l`;
[[ $t1c -eq 1 ]] && t1="0:$t1"
#[[ $(echo $tl |grep "\.") ]] || t1=$t1.0
date +%s%1N -d "$t1"
done
}

cxz(){
#https://stackoverflow.com/questions/6741967/how-can-i-count-the-occurrences-of-a-string-within-a-file
#https://stackoverflow.com/questions/24917812/insert-a-character-4-chars-before-end-of-string-in-bash
#https://stackoverflow.com/questions/14309032/bash-script-difference-in-minutes-between-two-times
#https://askubuntu.com/questions/217570/bc-set-number-of-digits-after-decimal-point
#https://stackoverflow.com/questions/41793634/subtracting-two-timestamps-in-bash-script
[[ ! -f $1 ]] && return; f=/tmp/c1
sed '/^$/d' $1|tr -s ';' ':' > $f
cutnum=`cat $f |wc -l`; cutnum=$((cutnum-1)); [[ $cutnum -eq 0 ]] && return
mapfile -t s < <(cut -d' ' -f1 $f)

mapfile -t s1 < <(readTime 1 $f)
mapfile -t s2 < <(readTime 2 $f)

for x in $(seq 0 $cutnum); do
 t=$(echo "scale=1; (${s2[$x]}-${s1[$x]})/10"|bc)

 #echo $t |sed 's/.\{1\}$/.&/' ##insert . in second last # 
 #echo "scale=1; ($b-$a)/10"|bc
 sleep .2;
 #echo "${s[$x]}" "$t"
 yes|ff c "$a" "${s[$x]}" "$t"
 sleep 1
 mv "$b" "$n-$x.$e" #&& sleep 1
done 
}

readMS(){
IFS=:; while read m s ; do echo $((m * 60 + 10#$s)); 
done <<< $(cut -d' ' -f$1 $2)
}

cx(){
[[ ! -f $1 ]] && return
f=/tmp/c1
sed '/^$/d' $1|tr -s ';' ':' > $f
cutnum=`cat $f |wc -l`
cutnum=$((cutnum-1))
[[ $cutnum -eq 0 ]] && return
mapfile -t s < <(cut -d' ' -f1 $f)
#mapfile -t s1 < <(cut -d' ' -f1 $f|xargs -L1 date +%m%s -d)
#mapfile -t s2 < <(cut -d' ' -f2 $f|xargs -L1 date +%m%s -d)

mapfile -t s1 < <(readMS 1 $f)
mapfile -t s2 < <(readMS 2 $f)
#https://stackoverflow.com/questions/16414632/how-to-convert-a-date-hh-mm-ss-in-second-with-bash
#IFS=: read -r h m s <<<"$time_hhmmss"
#time_s=$(((h * 60 + m) * 60 + s))

#printf '%s\n' "${s2[@]}"
#b=`date --date="0:38" +%m%s`
#a=`date +%m%s -d "0:50"`
#echo $(( (a-b)/60))

#return
for x in $(seq 0 $cutnum); do
 #t=$(( (${s2[$x]}-${s1[$x]})/60))
 t=$(( ${s2[$x]}-${s1[$x]} ))
 sleep .2;
 #echo "${s[$x]}" "$t"
 yes|ff c "$a" "${s[$x]}" "$t"
 
 sleep 1
 mv "$b" "$n-$x.$e" #&& sleep 1
done 
}

fcx(){
[[ ! -f $1 ]] && return
f=/tmp/c1
sed '/^$/d' $1|tr -s ';' ':' > $f
cutnum=`cat $f |wc -l`
cutnum=$((cutnum-1))
[[ $cutnum -eq 0 ]] && return
mapfile -t s < <(cut -d' ' -f1 $f)
mapfile -t s2 < <(cut -d' ' -f2 $f)

for x in $(seq 0 $cutnum); do
#echo "${s[$x]}" "${s2[$x]}" 
 yes|ff c "$a" "${s[$x]}" "${s2[$x]}" 
 
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
#mapfile -t s < <(cut -d' ' -f1 $f)
#mapfile -t t2 < <(cut -d' ' -f2 $f)
mapfile -t s < <(readMS 1 $f)
mapfile -t t2 < <(readMS 2 $f)

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
