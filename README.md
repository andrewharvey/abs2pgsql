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
* Use a normalised database model.

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
## PostgreSQL Environment Variables
All scripts expect you have set up PG* environment variables. These are
used to control which PostgreSQL database, hostname, port, username, etc.
is used to load the data into. Refer to the [PostgreSQL documentation](http://www.postgresql.org/docs/current/static/libpq-envars.html)
for help.

For example in your terminal window before running the scripts first run,

    export PGDATABASE=abs

## PostgreSQL Performance Tweaks
There are several ways you can speed up this initial load (assuming you
want to "build from source" rather than using a pre-made dump as the
pre-made dump will always be faster). These suggestions are based on the
fact that you are loading existing data and you don't need durability.
That is, if the server crashes part way though the load you are happy to
just start the load from the start again.

I would recommend you follow the advice for [non-durable settings](http://www.postgresql.org/docs/current/static/non-durability.html) at least for the time you are actually loading the data.

# License
The licensing of this repository is slightly more complicated than usual.
For this reason I use a [DEP-5 style copyright file](http://dep.debian.net/deps/dep5/)
called `copyright`.

The short version is the contents of this repository are licensed under the 
[Creative Commons Zero 1.0](http://creativecommons.org/publicdomain/zero/1.0/)
license, except for some select files which contain
almost verbatim copied data from copyrighted works. Again refer to the
`copyright` file for details.

Although not required, I would prefer you give Attribution to the project
if you distribute it and release derived works or modifications under the same
CC0 license.

    To the extent possible under law, the person who associated CC0
    with this work has waived all copyright and related or neighboring
    rights to this work.
    http://creativecommons.org/publicdomain/zero/1.0/

# Running the scripts
Refer to the README within each of the separate loaders within this
repository for specific help and instructions for that product.
