#!/bin/bash

source ./src/global-vars.sh

for profile in $* ; do
  echo "Loading data for $profile..."
  for structure in ${h[$profile]} ; do
    echo "  ...Structure $structure"
    src/05-load.pl $structure $profile < load-template
  done
done
