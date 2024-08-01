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
