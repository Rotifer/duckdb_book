# Miscellaneous Code Notes

- Copy a table to a tab-separated file

```sql
COPY (SELECT * FROM hugo_gene_sample) TO 'hugo_gene_sample.tsv' (HEADER, DELIMITER '\t');
```

 - Sample 10 rows and a predetermined set of columns from a table

```sql
CREATE TABLE hugo_gene_sample AS
SELECT symbol, location, alias_symbol, date_modified, entrez_id
FROM (SELECT * FROM hugo_genes)
USING SAMPLE 10 ROWS
```


## Getting example data into a DuckDB database

On the command line, create a DuckDB database by issuing the following command:

```sh
duckdb sample.ddb
```

The __D__ prompt should appear, to import the sample data, issue the following command

```sql
CREATE TABLE hugo_gene_sample AS
SELECT *
FROM
  read_csv('https://raw.githubusercontent.com/Rotifer/duckdb_book/main/hugo_gene_sample.tsv?token=GHSAT0AAAAAACSJMVLN4NV7LYQUWQJ6YFYQZVLVFHQ',
delim='\t',
header=true);
```

View the newly created table and its 10 rows:

```sql
SELECT *
FROM
  hugo_gene_sample;
```
