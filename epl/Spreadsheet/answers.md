# Spreadsheet solutions

How many matches _do not_ have a match date, _mdate_, value?

`=COUNTBLANK(matches!C2:C12407)`

How many many matches _do_ have a match start time _mtime_?

`=COUNTA(matches!C2:C12407)`

How many games were played in each league season? 

`=QUERY(matches, "SELECT B,COUNT(A) GROUP BY B")`

How many clubs make up the EPL for each season?

```
=QUERY(
      UNIQUE(
        QUERY(matches, "SELECT B, E")
        ), 
   "SELECT Col1, COUNT(Col2) GROUP BY Col1")`
``````

How many clubs were represented in the first season 1992_1993 and also in season 2023_2024?

Which clubs have been represented in each of the 31 seasons?