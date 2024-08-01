#!/bin/bash

URL="https://g-a8b222.dd271.03c0.data.globus.org/pub/databases/genenames/hgnc/tsv/hgnc_complete_set.txt"
start=$(date +%s)
duckdb hugo_genes.ddb <<EOF
DROP TABLE IF EXISTS hugo_genes;
CREATE TABLE hugo_genes AS 
SELECT *  
FROM 
  read_csv('${URL}', delim='\t', header=true);
SELECT 
  count(*) AS row_count 
FROM
  hugo_genes;
EOF
end=$(date +%s)
seconds=$(echo "$end - $start" | bc)
printf "Operation took %d seconds.\n" $seconds
