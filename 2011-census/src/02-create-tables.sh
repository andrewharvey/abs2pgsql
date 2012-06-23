#!/bin/bash

source ./src/global-vars.sh

for profile in $* ; do
  echo "Creating tables for $profile..."
  for structure in ${h[$profile]} ; do
    echo "  ...Structure $structure"
    cat src/02-$profile-create-schema-template.sql | sed s/{structure}/$structure/g | psql -f -
  done
done
