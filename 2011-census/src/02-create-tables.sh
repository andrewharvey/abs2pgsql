#!/bin/bash

source ./src/global-vars.sh

for profile in $* ; do
  echo "Creating tables for $profile..."
  for structure in ${h[$profile]} ; do
    echo "  ...Structure $structure"
    if [ $structure == 'sa1' ] ; then
      cat src/02-$profile-create-schema-template.sql | sed s/{structure}/$structure/g | \
      sed "s/sa1_code/sa1_code_7digit/g" | \
      sed "s/REFERENCES asgs_2011.sa1,/REFERENCES asgs_2011.sa1 (code_7digit),/g" | \
      psql -f -
    else
      cat src/02-$profile-create-schema-template.sql | sed s/{structure}/$structure/g | psql -f -
    fi
  done
done
