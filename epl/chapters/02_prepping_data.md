# Chapter 2 - Getting and Prepping the data for loading

One of the least appreciated and least enjoyable tasks is preparing the data files for upload into your database. The data we need is often scattered across multiple source files and the formats of those files may be incompatible. Our objective here is to collect all the data for English Premier League (EPL) football (aka soccer in some varieties of English) games from the first season, 1992-1993 to the season 2023-2024. I already gave some background on football in general and the EPL in particular in the introduction so I am assuming you know what I am talking about when I say "EPL" and "seasons".

This chapter uses some reasonably advanced shell scripting. Anyone who knows basic programming and has at least some shell programming experience should be able to follow along. If you aren't interested in this topic, you can skip ahead to the next chapter and load the files which have already been generated to DuckDB and are available in the repo in the directory _output_data_ and you will then be able to progress with the SQL. Also, if you are proficient in say Ruby or Python and prefer those tools to shell, by all means go ahead and use them instaed of shell if you prefer. To repeat what I said in the introduction, I like and value shell programming but many do not. 

## Before we start

I assuming the following:

- You have access to a Unix type terminal; it could be Mac OS X, Linux, Unix or a linux emulator on windows such as Wine or Windows Subsystem for Linux (WSL)
- You have checked out the GitHub repo

## The source data

### Seasons 1993-1994 to 2023-2024

I found all the data for seasons from 1993-1994 to 2013-2024 on the website [Football-Data.co.uk](https://www.football-data.co.uk/englandm.php). The site provides a guide to the data in a _notes.txt_ file at [this link](https://www.football-data.co.uk/notes.txt). Each EPL season's results has a link to a downloadable CSV file. Each season's CSV file is called __E0.csv__ so after downloading each one, I re-named them using the format season start year, followed by underscore, followed by the season end year followed by .csv; an example file name is _2003_2004.csv_.

Tip: Consistent file naming really helps to keep things organised and also makes processing of such files using shell scripts much easier as I will demonstrate below.

31 such files were downloaded, renamed and stored in the repo directory named _source_files_.

### Season 199-1993

Unfortunately, data for the very first EPL season was not avaialble on the website I refer to above. It seemed a shame to me to not have data for the very first EPL season so I located the it on Wikipedia, [1992–93 FA Premier League](https://en.wikipedia.org/wiki/1992%E2%80%9393_FA_Premier_League).

I located the match results in a section called unsurprisingly "Results". I created a a CSV file of this table using Google Sheets which provides a very handy function called _IMPORTHTML_. I entered the following formula in cell A1 of a new Google sheet. You may need to authorise the call.

`=IMPORTHTML("https://en.wikipedia.org/wiki/1992%E2%80%9393_FA_Premier_League", "table", 6)`

I then downloaded the sheet as a tab-delimited CSV file using the menu action:

`File->Download->Tab-separated values (.tsv)`

I saved the file as _season_1992_1993.tsv_ in the repo directory _source_data_


## Builing our shell script piece by piece

The final shell script