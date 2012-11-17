# About
This is the loader for the ABS 2011 Census data, part of the abs2pgsql
project. The generic [abs2pgsql README is here](https://github.com/andrewharvey/abs2pgsql),
what follows is specific to the 2011 Census Data.

An Australian census was conducted by the ABS in 2011 and the results of
that are published under the umbrella term "Census of Population and Housing".

The results of the census are released in a series of "products" which are
[listed in full here](http://www.abs.gov.au/ausstats/abs@.nsf/lookup/2011.0.55.001Main%20Features1262011).

This loader is designed to load the DataPack DVD data, however it
shouldn't have a problem loading the DataPack downloads if you would prefer to
use them.

The target schema aims to be an object-relational schema whist trying to
be true to the original schema of the data as presented by the ABS. [See
below for more information](#target-postgresql-schema).

The DataPack DVD's consist of 7 individual DataPack profiles,
* Basic Community Profile (cat. no. 2069.0.30.008)
* Indigenous Profile (cat. no. 2069.0.30.008)
* Time Series Profile (cat. no. 2069.0.30.008)
* Place of Enumeration Profile (cat. no. 2069.0.30.009)
* Expanded Community Profile (cat. no. 2069.0.30.009)
* Working Population Profile (cat. no. 2069.0.30.009)
* Estimated Resident Population (cat. no. 2069.0.30.010)

There are also two additional products which aren't part of the DataPack DVD's.
* Mesh Block Counts
* Socio-Economic Indexes for Areas (SEIFA)

I plan to support them as well, when they are released,

To actually use these scripts to load the data, you first need the data. You
can either download it from my [DataPack DVD mirror](http://tianjara.net/data/abs/)
or purchase the physical disks from the ABS.

The DVD's starting from Release 2 (after I [expressed my disappointment over the rigour of licensing details in comic format](http://tianjara.net/hosted/letter-to-abs-re-census-dvd-license.png)
are clearly marked as CC BY 2.5 AU.

To create the files on my DataPack DVD mirror from the source DVD I used,

    ./src/00-repack-datapack-dvd.sh /media/cdrom

If you choose to use these repacks you will need to extract the .tar.xz into a directory named
`DataPacks` within the 2011-census directory from this repository.

If you choose to download the data from the ABS web site you will need to ensure you extract
that data into the same structure that you would get from extracting my repacked tar.xz.

# Target PostgreSQL Schema
These scripts don't to a straight load, if they did it would be much
simpler as you could just `COPY` from the source csv files. However my aim
was to produce an object-relational schema rather than the flat schema of
the source csv files.

It must be noted that this won't load the raw census data, that data
isn't released. It will only load the summary data which the ABS produces
in the form of "Community Profiles".

I had some guiding principles I tried to abide by when defining my target
PostgreSQL schema.

* [Database normalization](//en.wikipedia.org/wiki/Database_normalization).
  So don't include statistics that can be calculated from other available data.
  i.e. if Persons = Male + Female, then don't store persons data, just store
  male and female in the database.

  To quote Wikipedia,

      A standard piece of database design guidance is that the designer should
      create a fully normalized design; selective denormalization can
      subsequently be performed for performance reasons.

* Maintain the same terminology as the source schema.

## PostgreSQL Limitations
PostgreSQL imposes some limitations which in some cases prevented the
target schema matching the source data model. These have been noted in
the code and can be found with a global search for "PostgreSQL
Limitation". Most of these are abbreviations rather than the full name
due to the default NAMEDATALEN being 64.

## ABS Classifications
The ABS [publish a set of "Classifications"](http://www.abs.gov.au/AUSSTATS/abs@.nsf/ViewContent?readform&view=DirClassManualsbyTopic&Action=Expand&Num=6.1.4).
These are essentially hierarchical categories which allow census form
responses to be classified from their free form responses into rigid
classified categories. The complete census data coded to these
classifications is not freely available (as far as I am aware) and the
data is only released in summarised form in the form of profiles.
Although these profiles use these published classifications they often
take a subset or make arbitrary amalgamation of individual codes from the
classification. This makes it difficult to present the census data in
PostgreSQL with referential integrity to the classifications.

Currently I only model the profile versions of these classifications in
01-create-datatypes.sql. To produce a more elegant data model in this
PostgreSQL schema we could load the classifications into their own schema
and maintain faithful references to them from the profiles.

# Running the Scripts
The scripts are designed to be run via the Makefile as such a simple,

    make

will clean out any existing census_2011 schema, create the census_2011
schema and subsequently load the data.

You should ensure you have set your [PG environment variables](http://www.postgresql.org/docs/current/static/libpq-envars.html)
correctly prior to running the make command.

## Prerequisites
It is required to have a minimal asgs_2011 schema loaded first using
[asgs2pgsql](https://github.com/andrewharvey/asgs2pgsql).

The minimal asgs_2011 schema just contains the asgs_2011 types which are
included in stage2/03a-create-asgs-schema.sql and
stage2/10a-australia-hack.sql of asgs2pgsql.

If you have the full asgs_2011 schema loaded then full foreign key
relationships will be created to the underlying geometry of each
geographical area, otherwise they won't be.

This loader requires your PostgreSQL version to be 9.2 or greater. The loader
used to work with older versions, so if that is really important to you you can
use an older version.

You will also need the following Debian packages (or equivalent for your system),

    postgresql-client-9.2, quilt, libtext-csv-perl | libtext-csv-xs-perl,
    libdbd-pg-perl, bash (>= 4.0)

## Tweaking your PostgreSQL database
A fully loaded census_2011 schema will contain a lot of tables. The main
reason for so many tables is each DataPack Profile Table will be stored
as a PostgreSQL table once for each geographic structure for which there
is data released. This results in a lot of tables. As such you will
probably need to increase the `max_locks_per_transaction` option in your
postgresql.conf file.

# Using a DB Dump
Eventually I will publish a pg_dump of the loaded database, so if you
wish you can simply load the dump rather than build up and load the data
from source.

If the lack of this is holding you back, please email me and let me know.

# Copyright
## DataPack Metadata Tables
All .tsv files within DataPack-Metadata are works derived from the
[CC BY 2.5 AU](http://creativecommons.org/licenses/by/2.5/au/) licensed
Metadata/Metadata_2011_*_DataPack.xlsx files from the R2 DataPack DVD's.

They were created via a copy-paste out of LibreOffice.

I believe there is an error in the latest versions of these spreadsheets, hence
DataPack-Metadata/patches are patches I've created to fix this error
until the ABS makes a release with the fixes. This patch is applied
automatically during the build process.

Attribution for the original data goes to the [Australian Bureau of Statistics (ABS)](http://abs.gov.au/), Commonwealth of Australia.

Because these files are derived works of a CC BY work, these remixed
files are also licensed under the same CC BY 2.5 AU license.
