#!/bin/bash

source ./src/global-vars.sh

for profile in $* ; do
  echo "Loading data for $profile..."
  for structure in ${h[$profile]} ; do
    echo "  ...Structure $structure"
    # load the data
    src/05-load.pl $structure $profile < load-template
    # run ANALYZE on those tables which we added data to as per advice at http://www.postgresql.org/docs/current/static/populate.html#POPULATE-ANALYZE
    cat load-template | cut -d' ' -f3 | sort | uniq | grep "^$profile" | sed "s/$/_$structure/" | sed "s/^/ANALYZE census_2011./" | sed "s/$/;/" | psql -f -
  done
done
