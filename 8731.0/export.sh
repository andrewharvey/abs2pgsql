#!/bin/sh

mkdir -p "export"

for dataset in gccsa sa2 sa3 sa4 state
do
  psql --no-align --field-separator=',' -c "SELECT * FROM abs_8731_0_$dataset;" | head  --lines=-1 > export/$dataset.csv
done
