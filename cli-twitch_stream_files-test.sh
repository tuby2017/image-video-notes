#!/bin/bash
token="stream_key_string"
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
echo -e "${yw}on current clipboard${NC}";
xsel -b
echo;echo;echo -e "${yw}current dir: ${NC}" "$loc";
read -rsn1 -p"$(echo -e ${yw}" Press n,m,q to exit "$NC)" var;
var=$(echo $var |tr [:lower:] [:upper:])
[[ $var = [qmn] ]] && exit
if [[ $var = [opz] ]];then
echo 'use old'
else;
sleep .3;
echo
xsel -b > /tmp/new
xsel -b
fi

readarray -t list < /tmp/new
declare -p list
#for i in "${list[@]}";do j=$(echo "${i}");echo "$j";done
echo

list=("$@")
	for i in "${list[@]}";do
j=$(echo "${i}");
mpv --quiet -no-terminal --osd-scale-by-window=no --mute --loop=no "$j" &
ffmpeg -re -i "$j" -c copy -f flv 'rtmp://live-jfk.twitch.tv/app/'$token;
	done
#--window-scale=0.5
#pkill ffmpeg
exit
