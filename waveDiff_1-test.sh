#!/bin/bash
## ./waveform_diff.sh input.aac in2.wav #same length
[[ -z $1 ]] && exit 1;
shopt -s expand_aliases
alias temp='mktemp /tmp/this.XXX.jpg'
outputfile='/tmp/a-diff.jpg' #./a4-diff.jpg
yw='\033[0;7m'
NC='\033[0m'

trap "rm -f /tmp/this*.jpg" 0 2 3 15
for i in {1..4};do
#eval "a$i=$(mktemp /tmp/this.XXX.jpg)"
eval "a$i=$(temp)"
done
#exit
echo 'ffmpeg ...'
alias ff='ffmpeg -hide_banner -loglevel panic -y'
ff -i "${1}" -filter_complex showwavespic -frames:v 1 "$a1"
ff -i "${2}" -filter_complex showwavespic -frames:v 1 "$a2" && echo -e "${yw}ffmpeg output Waveform Complete${NC}"

height=$(identify -ping -format '%h' "$a1")
height=$(( height * 2))
composite $a1 $a2 -compose difference $a3

convert -pointsize 40 -fill white \( $a1 -gravity NorthWest -annotate +15+15 'First' \) \
\( $a2 -gravity SouthWest -annotate +15+15 'Second' \) \
-append  -write mpr:a4 +delete \
mpr:a4 \( $a3 -resize x$height! -background black -gravity center -extent x$height -gravity North -annotate +0+$((height/4)) 'Difference' \) +append -quality 85 $a4

yes|cp $a4 "${outputfile}" && printf "output:${yw} "${outputfile}"${NC}\ntemp files removed\n"
#timeout 4 mpv --quiet --fullscreen "${outputfile}" &
feh -ZF "${outputfile}" &
exit
