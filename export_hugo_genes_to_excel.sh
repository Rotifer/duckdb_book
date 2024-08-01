#!/bin/bash

table_name=$1
excel_filename=$2

duckdb hugo_genes.ddb <<EOF
LOAD spatial;
COPY $table_name TO '$excel_filename' WITH (FORMAT GDAL, DRIVER 'xlsx');
EOF