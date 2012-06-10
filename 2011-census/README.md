# About
These scripts are intended to load the 2011 Census data into a PostgreSQL
database. The target schema aims to be an object-relational schema whist
trying to be true to the original schema of the data as presented by the
ABS.

The actual census data that these scripts load hasn't been released yet,
so the code is based on the sample products.

The census was conducted by the ABS in 2011 and the results of which are
published under the umbrella term "Census of Population and Housing".
The products which this consists of are [listed in full here](http://www.abs.gov.au/ausstats/abs@.nsf/lookup/2011.0.55.001Main%20Features1262011).

These scripts intend to load the DataPack DVD, Mesh Block Counts, and
Socio-Economic Indexes for Areas (SEIFA) products.

The DataPack DVD's consist of 7 individual DataPack profiles,
* Basic Community Profile (cat. no. 2069.0.30.008)
* Indigenous Profile (cat. no. 2069.0.30.008)
* Time Series Profile (cat. no. 2069.0.30.008)
* Place of Enumeration Profile (cat. no. 2069.0.30.009)
* Expanded Community Profile (cat. no. 2069.0.30.009)
* Working Population Profile (cat. no. 2069.0.30.009)
* Estimated Resident Population (cat. no. 2069.0.30.010)

To actually use these scripts to load the data, you need the data. You
can either download it from my DataPack DVD mirror (tba) or purchase the
physical disks from the ABS.

# Target PostgreSQL Schema
These scripts don't to a straight load, if they did it would be much
simpler as you could just COPY from the source csv files. However my aim
was to produce an object-relational schema rather than the flat schema of
the source csv files.

In must be noted that this won't load the raw census data, that data
isn't released. It will only load the summary data which the ABS produces
in the form of "Community Profiles".

I had some guiding principles I tried to abide by when defining my target
PostgreSQL schema.

* Don't include statistics that can be calculated from other available data.
  i.e. if Persons = Male + Female, then don't store persons data, just store
  male and female in the database.
* Try to maintain the same terminology as the source schema.

# Running the Scripts
Although there is no data to load yet. You can still create the schema
and potentially load some sample data.

The scripts are designed to be run via the Makefile as such a simple,

    make

will clean out any existing census_2011 schema, create the census_2011
schema and subsequently load the data.

You should ensure you have set your [PG environment variables](http://www.postgresql.org/docs/current/static/libpq-envars.html)
correctly prior to running the make command.

# Using a DB Dump
Eventually I will publish a pg_dump of the loaded database, so if you
wish you can simply load the dump rather than build up and load the data
from source.

# Copyright
## DataPack Metadata Tables
All files within DataPack-Metadata are works derived from the
[CC BY 2.5 AU](http://creativecommons.org/licenses/by/2.5/au/) licensed
Metadata/Metadata_2011_*_DataPack.xlsx files from within [the samples here](http://www.abs.gov.au/websitedbs/censushome.nsf/home/datapackssample?opendocument&navpos=250).

They were created via a copy-paste out of LibreOffice.

Attribution for the original data goes to the [Australian Bureau of Statistics (ABS)](http://abs.gov.au/), Commonwealth of Australia.

Because these files are derived works of a CC BY work, these remixed
files are also licensed under the same CC BY 2.5 AU license.
