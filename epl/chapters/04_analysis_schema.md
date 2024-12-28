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

## Macros

```sql
CREATE SCHEMA macros;
USE macros;
CREATE MACRO get_club_code(p_club_name) AS TABLE
  SELECT club_code 
  FROM main.clubs 
  WHERE club_given_name = p_club_name
  LIMIT 1;
```

## Create the _matches_ table

We want a table that records details of matches where match_id is unique

```sql
CREATE TABLE matches(
  match_id VARCHAR PRIMARY KEY,
  season VARCHAR,
  match_date DATE,
  match_time TIME
);
```

### Make the data to append using a view

- We need the rows for _matches_ from both the 1992-1993 season and all the other seasons in one table or view that we can append to the _matches_ table created above.

CREATE TABLE staging.epl_matches_1992_2024 AS
WITH matches_temp AS(
  SELECT
    '1992_1993' season,
    NULL match_date,
    NULL match_time,
    home_club_code,
    away_club_code,
    home_club_score,
    away_club_score
  FROM season_1992_1993_ready
  UNION
  SELECT
    season,
    STRPTIME(match_date, '%d/%m/%Y') match_date,
    CASE
      WHEN match_time = 'NA' THEN NULL
      ELSE CAST(match_time AS TIME)
    END match_time,
    (SELECT club_code 
     FROM macros.get_club_code(home_club_name)) home_club_code,
    (SELECT club_code 
     FROM macros.get_club_code(away_club_name)) away_club_code,
    home_club_goals,
    away_club_goals
  FROM seasons_1993_2023_raw
  WHERE home_club_name IS NOT NULL
)
SELECT
  ROW_NUMBER() OVER() match_id, *
FROM  matches_temp;