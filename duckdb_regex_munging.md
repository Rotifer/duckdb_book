
## Import the data

- Want the entire data for each row in a single column
- Need to stop DuckDB interpreting the tab-delimited values as columns
- Set the delimiter as an absent character does this.


```sql
CREATE OR REPLACE TABLE raw_table_data AS 
SELECT * 
FROM  read_csv('./output_files/reef1_tables_extracted.tsv', 
               DELIM ='|', 
			   HEADER=FALSE);
```

## Replace the terminal "\tNone\tNone.." to end of row

```sql
UPDATE raw_table_data 
SET column0 = regexp_replace(column0, '(\t(None)?)+$', '');
```

## Extract the table numbers and row numbers into separate columns


```sql
CREATE OR REPLACE TABLE analysis_ready(
  row_id INTEGER PRIMARY KEY,
  table_num INTEGER,
  table_row_num INTEGER,
  table_data VARCHAR
);
```


```sql
INSERT INTO analysis_ready(row_id, table_num, table_row_num, table_data)
SELECT
  ROW_NUMBER() OVER() row_id,
  CAST(regexp_extract(column0, '(\d+)$') AS INTEGER) table_num,
  CAST(regexp_extract(column0, '^(\d+)') AS INTEGER) + 1 table_row_num,
  TRIM(regexp_replace(regexp_replace(column0, '^\d+', ''), '\d+$', '')) table_data,
FROM raw_table_data;
```

## Extracting Values

```sql
SELECT 
  row_id, 
  regexp_extract(table_data, 'HBcrAg at baseline, log10 U/mL\t([^\s]+)', 1) 
  FROM (SELECT table_data FROM analysis_ready WHERE table_data LIKE '%HBcrAg%') sq;
```