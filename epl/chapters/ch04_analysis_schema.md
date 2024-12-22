# Chapter 4 - Creation of the analysis schema

## Clubs table

Source data prepared in Google Sheets

### Table creation and population

```sql
CREATE TABLE clubs(
  club_code VARCHAR PRIMARY KEY,
  club_name VARCHAR,
  club_given_name VARCHAR);
```

Populating the table

```sql
INSERT INTO clubs(club_code,
                  club_name, 
                  club_given_name) 
SELECT 
  club_code, 
  club_name, 
  given_name 
FROM '../source_data/clubs.tsv';

```