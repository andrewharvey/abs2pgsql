# About
This abs2pgsql project is devoted to providing a path for loading Australian
Bureau of Statistics (ABS) data releases into a PostgreSQL database.

In cases where ABS data is linked to the ASGS (Australian Statistical Geography
Standard) such fields reference the ASGS via the asgs schema as created by
[asgs2pgsql](https://github.com/andrewharvey/asgs2pgsql). For these data
releases you will need to have loaded the asgs schema into your database.

# Preparation
All scripts expect you to set up PG* environment variables. These are used to
control which PostgreSQL database, hostname, port, username, etc. is used to
load the data into. Refer to the [PostgreSQL documentation](http://www.postgresql.org/docs/current/static/libpq-envars.html)
for help. So for example in your terminal window before running the scripts,
first run:

    export PGDATABASE=abs

# ABS Product Releases
* 8731.0 - Building Approvals, Australia, March 2012
* 2069.0.30.008 - Basic, Aboriginal and Torres Strait Islander Peoples and Time
  Series Census DVD DataPacks , 2011 First Release

# License, Copyright and Attribution
The licensing of this repository is slightly more complicated than usual. For
this reason I use a [DEP-5 style copyright file](http://dep.debian.net/deps/dep5/)
called `copyright`.

The short version is this repository is licensed under the Creative Commons
Attribution 3.0 Unported license, with some minor exceptions as noted in the
`copyright` file.

As per the [advice given by Creative Commons](http://wiki.creativecommons.org/Frequently_Asked_Questions#Can_I_combine_two_different_Creative_Commons_licensed_works.3F_Can_I_combine_a_Creative_Commons_licensed_work_with_another_non-CC_licensed_work.3F)
I can't license works derived from CC-BY works under CC0. Since the ABS works
are licensed under the Creative Commons Attribution 2.5 Australia licence and
because this whole repository is a derived work of those ABS works, I choose the
CC-BY license for this repository.

Unfortunately this conflicts with the advice also given by Creative Commons with
regards to [using the Creative Commons licenses for software](http://wiki.creativecommons.org/FAQ#Can_I_apply_a_Creative_Commons_license_to_software.3F).

However since all the code is not really very portable and is intended for sole
use with the ABS data, I don't think there is much need for a portable software
license.


### ABS Attribution
Any and all files contained within a "data" folder contain data which is
Copyright © Commonwealth of Australia.

As per http://www.abs.gov.au/websitedbs/D3310114.nsf/Home/%C2%A9+Copyright?opendocument#from-banner=GB the data has been licensed by the ABS under the Creative Commons Attribution 2.5 Australia licence.

The files are not originals from the ABS, rather they are derived works from the
source XLS files produced by the ABS. They were created by a copy-paste from the
XLS file from the ABS web site using LibreOffice. A subsequent s/,//g was used
to remove commas from the numbers.
#### 8731.0/data/Feb2012
Australian Bureau of Statistics
Building Approvals, Australia, February 2012
cat. no. 8731.0.
Issued 02/04/2012
http://www.abs.gov.au/AUSSTATS/abs@.nsf/DetailsPage/8731.0February%202012?OpenDocument


# Running the scripts

The folders within this repository are ABS catalogue numbers. Within that folder
you should be able to simply run,

    make


The following ABS data releases require the ASGS schema to be loaded (see About):

* 8731.0

In addition to loading the data, the Makefiles also contain other targets.

To export the loaded data to a CSV file use,

    make export

To generate a quantile classification of the data use,

    make generate_classifications


Because many of the ABS datasets are not released in a machine readable format
this project also contains tabular based files of ABS data releases where I've
manually extracted the data from the Microsoft Excel spreadsheets provided by
the ABS. This doesn't apply to the Census 2011 products which.
