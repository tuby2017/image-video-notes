#!/bin/bash
shopt -s expand_aliases 
trap "pkill xgg;exit" 0
token="stream_key_string"
alias echo='echo -e'
editprog=featherpad #edit with nano, etc

stream() {
list=("$@")
	for i in "${list[@]}";do
j=$(echo "${i}");
#mpv --quiet -no-terminal --osd-scale-by-window=no --mute --loop=no "$j" &
ffmpeg -re -i "$j" -c copy -f flv 'rtmp://live-jfk.twitch.tv/app/'$token;
#pkill mpv;
	done
#--window-scale=0.5
}

vList=/tmp/new
loc="${1}"
nowDir="`pwd`"
[[ -z "${1}" ]] && loc=.;
#echo "${loc}"
cd "${loc}"
#ls
loc="`pwd`"
if [[ "$loc" == "$newDir" ]]; then loc=same_Dir;fi

yw='\033[0;7m'
NC='\033[0m'
echo "${yw}on current clipboard${NC}";
xsel -b
echo;echo;echo "${yw}current dir: ${NC}" "$loc";
#read -rsn1 -p"$(echo ${yw}" Press n,m,q to exit "$NC)" var;

echo "${yw}--Press--\n l, j${NC} to old/new loop"
echo " ${yw}e, a ${NC}to edit list or append from clipboard"
echo " ${yw}o,p,z ${NC}to Not use clipboard"
read -rsn1 -p"$(echo ${yw}" n,m,q to exit"$NC)" var;
var=$(echo $var |tr [:upper:] [:lower:] )
[[ $var = [qmn] ]] && exit 0;
echo '  ' $var;echo

case $var in
[opzli])
	[[ $var = [li] ]] && loop=1 #oldloop
	echo 'use old'
	;;
[ea])
	if [[ $var = [e] ]];then
		echo edit; $editprog $vList;
	else	
		echo append;sleep .5; echo ''>>$vList;
		xsel -b >> $vList;cat $vList;echo ''
	fi
	read -rsn1 -p'press to countinue' var2;
	var2=$(echo $var2 |tr [:upper:] [:lower:] )
	[[ $var2 = [qmn] ]] && exit 0;
	;;
*)
	[[ $var = [j] ]] && loop=1 #newloop
	echo newPaste; xsel -b > $vList;xsel -b ;
	;;
esac
echo
[[ -z $loop ]] && echo "${yw}noloop${NC}"||echo "${yw}loop${NC}"
sleep 1;
#exit
####
readarray -t list < $vList
declare -p list
#for i in "${list[@]}";do j=$(echo "${i}");echo "$j";done
echo
if [[ -z $loop ]]; then
	stream "${list[@]}";
	exit;
fi

while :;do stream "${list[@]}";done
exit
