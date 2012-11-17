#!/bin/bash

source ./src/global-vars.sh

# test for asgs_2011 schema
# if it doesn't exist, then don't try to add foreign keys to the asgs_2011 schema
psql -c "SELECT schema_name FROM information_schema.schemata WHERE schema_name = 'asgs_2011' LIMIT 1;" | grep '1 row'
asgs_exists=$?
if [ $asgs_exists -ne 0 ] ; then
  echo "asgs_2011 schema not found. It must be present (though the actual loaded"
  echo "geometries is optional) See https://github.com/andrewharvey/asgs2pgsql"
  exit 1
fi

for profile in $* ; do
  echo "Creating tables for $profile..."
  for structure in ${h[$profile]} ; do
    echo "  ...Structure $structure"

    # if the asgs geometry table doesn't exist, then drop all the REFERENCES to it
    psql -c "SELECT table_name FROM information_schema.tables WHERE table_schema = 'asgs_2011' AND table_name = '$structure' LIMIT 1;" | grep '1 row'
    asgs_geom_exists=$?
    if [ $asgs_geom_exists -ne 0 ] ; then
      echo "asgs_2011 geometry table for $structure not found, so we won't include foreign keys to it."
      fk_script="s/ REFERENCES asgs_2011\.[^,]*//g"
    fi

    # pipe the create schema DDL
    #   adjust for the precense or lack of the asgs schema
    #   replace the templated asgs structure markers
    #   pass to psql for execution
    cat src/02-$profile-create-schema-template.sql | \
      sed -e "$fk_script" | \
      sed "s/{structure}/$structure/g" | \
      psql -f -
  done
done
