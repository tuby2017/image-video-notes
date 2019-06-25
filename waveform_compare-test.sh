#!/bin/bash
## ./waveform_diff.sh input.aac in2.wav #same length
[[ -z $1 ]] && exit 1;
alias temp_file='mktemp /tmp/this.XXX.jpg'
trap "rm -f /tmp/this*.jpg" 0 2 3 15
for i in {1..4};do
eval "a$i=$(temp_file)"
done

ffmpeg -i "${1}" -filter_complex showwavespic -frames:v 1 "$a1"
ffmpeg -i "${2}" -filter_complex showwavespic -frames:v 1 "$a2"


#rm -- "${a[@]}"

height=$(identify -ping -format '%h' "$a1")
height=$(( height * 2))
composite $a1 $a2 -compose difference $a3

convert -pointsize 40 -fill white \( $a1 -gravity NorthWest -annotate +15+15 'Original' \) \
\( $a2 -gravity SouthWest -annotate +15+15 'Equalize' \) \
-append  -write mpr:a4 +delete \
mpr:a4 \( $a3 -resize x$height! -background black -gravity center -extent x$height -gravity North -annotate +0+$((height/4)) 'Difference' \) +append -quality 85 $a4
cp $a4 a4-test.jpg
