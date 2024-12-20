#!/usr/bin/bash


OUTPUT_DIR="../output_data/"
INPUT_DIR="../source_data/"

if [[ -f ${OUTPUT_DIR}seasons_1993_2023.tsv ]]; then
  rm ${OUTPUT_DIR}seasons_1993_2023.tsv 
fi

for FILE in ${INPUT_DIR}{1993..2019}*.csv
do
  sed '1d' $FILE | \
    awk -v f=$(basename $FILE | sed 's/.csv//') \
      'BEGIN{FS=","; OFS="\t"}{print f,$2,"\t",$3,$4,$5,$6}' \
         >>seasons_1993_2019.tsv
done

for FILE in ${INPUT_DIR}{2020..2023}*.csv
do
  sed '1d' $FILE | \
    awk -v f=$(basename $FILE | sed 's/.csv//') \
      'BEGIN{FS=","; OFS="\t"}{print f,$2,$3,$4,$5,$6,$7}' \
         >>seasons_2020_2024.tsv
done

echo "season,match_date,match_time,home_club_name,\
        away_club_name,home_club_goals,away_club_goals" | \
     awk 'BEGIN{FS="," ; OFS="\t"}{print $1,$2,$3,$4,$5,$6,$7}' \
       >seasons_1993_2023.tsv
cat seasons_1993_2019.tsv seasons_2020_2024.tsv \
      >>seasons_1993_2023.tsv
mv seasons_1993_2023.tsv ${OUTPUT_DIR}
rm seasons_1993_2019.tsv
rm seasons_2020_2024.tsv
echo "Script finished, see file '${OUTPUT_DIR}seasons_1993_2023.tsv'"
