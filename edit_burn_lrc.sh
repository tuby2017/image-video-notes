sed '/^$/d' file #remove blank
input=filename;
output=out_filename;
t=($(cat $input.lrc|sed '1d;2d'|cut -d']' -f1|sed 's/$/]/' ))
#readarray arrName < file 
readarray ar1 < $input-pin.txt
cat $input.lrc|sed '1d;2d'|cut -d']' -f2 >> /tmp/jx2
readarray ar2 < /tmp/jx2
readarray ar3 < $input-en2.txt

outfile=$input-xout.lrc
rm $outfile
n=0
for i in "${ar1[@]}";do
echo ${t[n]}${i}'[]'${ar2[n]}'[]'${ar3[n]};
n=$((n+1))
done > $outfile

ffmpeg -i $outfile ${outfile%%.*}.srt
sed -i 's/ [][]]/\\N/g' $outfile

ffmpeg -i $input.mp4 -c:a copy -vn -sn $output.m4a
ffmpeg -i $output.m4a -acodec copy $output.aac
-c:a aac -strict -2
#ocenaudio mp3 128k joint stereo, medium low
ffmpeg -loop 1 -i black.jpg -i $output.mp3 -c:v libx264 -c:a copy -shortest $output.mp4

ffmpeg -sub_charenc ISO-8859-16 -i $output.mp4 -c:v libx264 -c:a copy -vf subtitles=$input-xout.srt:force_style='FontSize=25' -an $output2.mp4

