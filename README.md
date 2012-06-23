# About
This project exists to provide a means for loading [Australian Bureau of
Statistics (ABS)](http://www.abs.gov.au/) data into a PostgreSQL
database.

In many cases the ABS only publish Microsoft Excel spreadsheets
summarising statistics they have collected in a report style. While this
caters for a large component of users, it leaves other users who would
like the data delivered in the form of machine readable statistics (
either for use in a database directly or for building other applications
on top of) out in the dark. This project is designed to help out these
users of the data.

The technical implementation of such a project involves firstly obtaining
the statistics from the ABS, defining the structure of that data in the
database, and finally writing programs to actually transform and load
the data. I suppose this is an [extract, transform and load](https://en.wikipedia.org/wiki/Extract,_transform,_load)
operation.

## Design Principles
Currently this project has some fixed constraints limiting the scope of
the project and some guiding principles to adhere to.

* Code written mostly in shell (bash flavoured) and Perl.
* Targeting the PostgreSQL database.
* Code covers the whole process as much as possible, i.e. the user should
  be able to simply run make and all the data will be downloaded from the
  ABS (or a mirror), transformed and loaded with minimal intervention.
* Eventually target schemas will be released as stable versions to allow
  third parties to rely on the schema.
* Terminology should be kept consistent with the source statistics.

## ASGS
In cases where ABS data is linked to the ASGS (Australian Statistical
Geography Standard) such fields reference the ASGS via the asgs schema as
created by [asgs2pgsql](https://github.com/andrewharvey/asgs2pgsql).

## Development Status
Currently everything should be considered under active development and
unstable. Please don't let that stop you from either using or helping out
though.

Please fork and send a pull request (or email your patch if you prefer)
any contributions you would like to make. This isn't a one person
project.

## Comments and Feedback
Please use the bug tracker for any bugs, feature requests or
questions. Or if you would prefer, you can email the maintainer.

# ABS Product Releases
This project is actually a meta-project. It contains code for the
following ABS releases,
* 8731.0 - Building Approvals, Australia, March 2012
* 2011-census - Census of Population and Housing, 2011 (cat no. 2001.0,
  2002.0, 2003.0, 2069.0.30.008)

# Preparation
All scripts expect you have set up PG* environment variables. These are
used to control which PostgreSQL database, hostname, port, username, etc.
is used to load the data into. Refer to the [PostgreSQL documentation](http://www.postgresql.org/docs/current/static/libpq-envars.html)
for help.

For example in your terminal window before running the scripts first run,

    export PGDATABASE=abs

# License, Copyright and Attribution
The licensing of this repository is slightly more complicated than usual.
For this reason I use a [DEP-5 style copyright file](http://dep.debian.net/deps/dep5/)
called `copyright`.

The short version is this repository is licensed under the Creative Commons
Zero 1.0 license, with some minor exceptions as noted in the `copyright` file.

I am seeking advise with regards to the licensing of this project.
Ideally I would like to use the CC0 license however I need to consider
the validity of this where much of this project is derived from ABS
copyrighted works. Particularly the [advice given by Creative Commons](http://wiki.creativecommons.org/Frequently_Asked_Questions#Can_I_combine_two_different_Creative_Commons_licensed_works.3F_Can_I_combine_a_Creative_Commons_licensed_work_with_another_non-CC_licensed_work.3F)
which says I can't license works derived from CC-BY works under CC0.
Since the ABS works are licensed under the Creative Commons Attribution
2.5 Australia licence and because this whole repository is a derived work
of those ABS works, I may need to choose the CC-BY license for this
repository in order for it all to be valid. I'm okay with that, but only
in the case that I can't use the CC0 license.

Unfortunately this conflicts with the advice also given by Creative
Commons with regards to [using the Creative Commons licenses for software](http://wiki.creativecommons.org/FAQ#Can_I_apply_a_Creative_Commons_license_to_software.3F).

However since all the code is not really very portable and is intended
for sole use with the ABS data, I don't think there is much need for a
portable software license.

I welcome advice with respect to this.

### ABS Attribution
The file 8731.0/data/Feb2012/8-months-to-feb-2012-fytd contains data
which is Copyright © Commonwealth of Australia.

As per http://www.abs.gov.au/websitedbs/D3310114.nsf/Home/%C2%A9+Copyright?opendocument#from-banner=GB
the data has been licensed by the ABS under the Creative Commons
Attribution 2.5 Australia licence.

This file is not an original from the ABS, rather a derived work from the
source XLS file produced by the ABS. It was created by a copy-paste from
the XLS file from the ABS web site using LibreOffice. A subsequent s/,//g
was used to remove commas from the numbers.

In the future this attribution will move into a DEP-5 style copyright
file.

#### 8731.0/data/Feb2012
Australian Bureau of Statistics
Building Approvals, Australia, February 2012
cat. no. 8731.0.
Issued 02/04/2012
http://www.abs.gov.au/AUSSTATS/abs@.nsf/DetailsPage/8731.0February%202012?OpenDocument


# Running the scripts

Refer to the README within each of the separate loaders within this
repository for specific help and instructions for that product.
