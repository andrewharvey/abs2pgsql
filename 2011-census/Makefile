# This file is licensed CC0 by Andrew Harvey <andrew.harvey4@gmail.com>
#
# To the extent possible under law, the person who associated CC0
# with this work has waived all copyright and related or neighboring
# rights to this work.
# http://creativecommons.org/publicdomain/zero/1.0/

all : clean create_schema create_tables prepare_load load_metadata_table

clean :
	psql -c "DROP SCHEMA IF EXISTS census_2011 CASCADE;"
	rm -f *.copy load-template

create_schema :
	psql -c "CREATE SCHEMA census_2011;"
	
	# create the datatypes used by my census_2011 schema
	psql -f src/01-create-datatypes.sql

create_tables :
	# test for asgs_2011 schema
	# if the process fails on the next line you need to first load the
	# asgs_2011 schema from https://github.com/andrewharvey/asgs2pgsql
	psql -c "SELECT table_schema FROM information_schema.tables WHERE table_schema = 'asgs_2011' LIMIT 1;" | grep '1 row'
	
	# create the tables for each of the products for each of the geographic
	# areas for which they are available.
	src/02-create-tables.sh

prepare_load :
	src/03-expand-template.pl < src/03-load-template.map | src/04-prepare-from-expansion.pl
	cat age.copy | sort | uniq | psql -c "COPY census_2011.age FROM STDIN;"
	rm -f age.copy

load_metadata_table :
	psql -f src/04-create-metadata-schema.sql
	cat datapack-metadata.copy | psql -c "COPY census_2011.datapack_metadata FROM STDIN;"
	rm -f datapack-metadata.copy

# and finally actually load the ABS Census Data
load :
	# Basic Community Profile & Place of Enumeration Profile
	echo "creating tables for BCP, PEP..."
	for s in aust state sa4 sa3 sa2 sa1 gccsa sua sos sosr ucl ra sla lga ssc poa ced sed; \
	do \
		src/05-load.pl $s BCP < load-template ; \
		src/05-load.pl $s PEP < load-template ; \
	done
	
	# Indigenous Profile
	echo "creating tables for IP..."
	for s in aust state sa4 sa3 sa2 gccsa ireg iare iloc ra sla lga; \
	do \
		src/05-load.pl $s IP < load-template ; \
	done
	
	# Time Series Profile & Estimated Resident Population Profile
	echo "creating tables for TSP, ERP..."
	for s in aust state sa4 sa3 sa2 gccsa sla lga; \
	do \
		src/05-load.pl $s TSP < load-template ; \
		src/05-load.pl $s ERP < load-template ; \
	done
	
	# Working Population Profile
	echo "creating tables for WPP..."
	for s in aust state sa4 sa3 sa2 gccsa lga; \
	do \
		src/05-load.pl $s WPP < load-template ; \
	done
	
	# Expanded Community Profile
	echo "creating tables for XCP..."
	for s in aust state sa4 sa3 sa2 gccsa sua sla lga; \
	do \
		src/05-load.pl $s XCP < load-template ; \
	done
	
	# Socio-Economic Indexes for Areas
	echo "creating tables for SEIFA..."
	for s in state sa4 sa3 sa2 sa1 sla lga ssc poa ced; \
	do \
		src/05-load.pl $s SEIFA < load-template ; \
	done
	
	# clean up
	rm -f load-template
