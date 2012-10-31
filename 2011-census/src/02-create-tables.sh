#!/bin/bash

source ./src/global-vars.sh

# test for asgs_2011 schema
# if it doesn't exist, then don't try to add foreign keys to the asgs_2011 schema
psql -c "SELECT table_schema FROM information_schema.tables WHERE table_schema = 'asgs_2011' LIMIT 1;" | grep '1 row'
asgs_exists=$?
if [ $asgs_exists -eq 0 ] ; then
  asgs_ref=" REFERENCES asgs_2011.{structure}"
else
  asgs_ref=""
fi

for profile in $* ; do
  echo "Creating tables for $profile..."
  for structure in ${h[$profile]} ; do
    echo "  ...Structure $structure"
    if [ $structure == 'sa1' ] ; then
      cat src/02-$profile-create-schema-template.sql | \
      sed s/ REFERENCES asgs_2011\.\{structure\}/$asgs_ref/g | \
      sed s/{structure}/$structure/g | \
      sed "s/sa1_code/sa1_code_7digit/g" | \
      sed "s/REFERENCES asgs_2011.sa1,/REFERENCES asgs_2011.sa1 (code_7digit),/g" | \
      psql -f -
    else
      cat src/02-$profile-create-schema-template.sql | sed s/{structure}/$structure/g | psql -f -
    fi
  done
done
