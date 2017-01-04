#!/bin/sh

for structure in BCP IP TSP PEP XCP WPP ERP; do
    unzip DataPacksOnline/2011_${structure}_ALL_for_AUST_sequential-header.zip "2011 Census ${structure} All Geographies for AUST/*" -d DataPacks/
    unzip -u DataPacksOnline/2011_${structure}_ALL_for_AUST_sequential-header.zip "Metadata/*"
done
