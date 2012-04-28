# About
This abs2pgsql project is devoted to providing a path for loading Australian
Bureau of Statistics (ABS) data releases into a PostgreSQL database.

Because many of the ABS datasets are not released in a machine readable format
this project also contains tabular based files of ABS data releases where I've
manually extracted the data from the Microsoft Excel spreadsheets provided by
the ABS.

In cases where ABS data is linked to the ASGS (Australian Statistical Geography
Standard) such fields reference the ASGS via the asgs schema as created by
[asgs2pgsql](https://github.com/andrewharvey/asgs2pgsql). For these data
releases you will need to have loaded the asgs schema into your database.

# Running the scripts

The folders within this repository are ABS catalogue numbers. Within that folder
you should be able to simply run,

    make

To control which PostgreSQL database (and hostname, port, username, etc.) is
used to load the data into, set the [PG* environment variables](http://www.postgresql.org/docs/current/static/libpq-envars.html)
prior to running the make command. e.g.

    export PGDATABASE=abs

The following ABS data releases require the ASGS schema to be loaded (see About):

* 8731.0

# License, Copyright and Attribution
## Non-Data files
All files not within a "data" directory aren't tainted by Commonwealth of
Australia copyright and are released by me, Andrew Harvey <andrew.harvey4@gmail.com>
under the Creative Commons Zero license (CC0).

    To the extent possible under law, the person who associated CC0
    with this work has waived all copyright and related or neighboring
    rights to this work.
    http://creativecommons.org/publicdomain/zero/1.0/

Database schemas defined in .sql files are partly derived from the schema used
for the original ABS data release. Refer to the ABS Attribution section below
for the attribution of original schemas.

## ABS License
Any and all files contained within a "data" folder contain data which is
Copyright © Commonwealth of Australia.

As per http://www.abs.gov.au/websitedbs/D3310114.nsf/Home/%C2%A9+Copyright?opendocument#from-banner=GB the data has been licensed by the ABS under the Creative Commons Attribution 2.5 Australia licence.

The files are not originals from the ABS, rather they are derived works from the
source XLS files produced by the ABS. They were created by a copy-paste from the
XLS file from the ABS web site using LibreOffice. A subsequent s/,//g was used
to remove commas from the numbers.

### ABS Attribution
#### 8731.0/data/Feb2012
Australian Bureau of Statistics
Building Approvals, Australia, February 2012
cat. no. 8731.0.
Issued 02/04/2012
http://www.abs.gov.au/AUSSTATS/abs@.nsf/DetailsPage/8731.0February%202012?OpenDocument
