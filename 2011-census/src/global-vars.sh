#!/bin/sh

# details of which products are avaliable for which geographic areas
# was obtained from http://www.abs.gov.au/ausstats/abs@.nsf/lookup/2011.0.55.001Main%20Features1202011
declare -A h
h=( [bcp]="aust ste sa4 sa3 sa2 sa1 gccsa sua ucl sos sosr ra lga ssc poa ced sed" \
    [pep]="aust ste sa4 sa3 sa2 sa1 gccsa sua ucl sos sosr ra lga ssc poa ced sed" \
    [ip]="aust ste sa4 sa3 sa2 gccsa ireg iare iloc ra lga" \
    [tsp]="aust ste sa4 sa3 sa2 gccsa lga" \
    [xcp]="aust ste sa4 sa3 sa2 gccsa sua lga" \
    [wpp]="aust ste sa4 sa3 sa2 gccsa lga" \
    [erp]="aust ste sa4 sa3 sa2 gccsa ireg ra lga" \
    [seifa]="sa4 sa3 sa2 sa1 lga ssc poa ced sed" )

# which DataPack release to use
release=3
