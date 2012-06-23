#!/bin/bash

# details of which products are avaliable for which geographic areas
# was obtained from http://www.abs.gov.au/ausstats/abs@.nsf/lookup/2011.0.55.001Main%20Features1202011
declare -A h
h=( [bcp]="aust state sa4 sa3 sa2 sa1 gccsa sua sos sosr ucl ra sla lga ssc poa ced sed" \
    [pep]="aust state sa4 sa3 sa2 sa1 gccsa sua sos sosr ucl ra sla lga ssc poa ced sed" \
    [ip]="aust state sa4 sa3 sa2 gccsa ireg iare iloc ra sla lga" \
    [tsp]="aust state sa4 sa3 sa2 gccsa sla lga" \
    [erp]="aust state sa4 sa3 sa2 gccsa sla lga" \
    [wpp]="aust state sa4 sa3 sa2 gccsa lga" \
    [xcp]="aust state sa4 sa3 sa2 gccsa sua sla lga" \
    [seifa]="state sa4 sa3 sa2 sa1 sla lga ssc poa ced" )

for profile in bcp ; do
  echo "Creating tables for $profile..."
  for structure in ${h[$profile]} ; do
    echo "  Structure $structure"
    cat src/02-$profile-create-schema-template.sql | sed s/{structure}/$structure/g | psql -f - ; \
  done
done
