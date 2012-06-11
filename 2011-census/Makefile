# This file is licensed CC0 by Andrew Harvey <andrew.harvey4@gmail.com>
#
# To the extent possible under law, the person who associated CC0
# with this work has waived all copyright and related or neighboring
# rights to this work.
# http://creativecommons.org/publicdomain/zero/1.0/

all : clean create_schema create_tables prepare_load load_metadata_table

clean :
	psql -c "DROP SCHEMA IF EXISTS census_2011 CASCADE;"
	rm -f *.copy

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
	
	# details of which products are avaliable for which geographic areas
	# was obtained from http://www.abs.gov.au/ausstats/abs@.nsf/lookup/2011.0.55.001Main%20Features1202011
	
	# Basic Community Profile & Place of Enumeration Profile
	echo "creating tables for BCP, PEP..."
	for s in aust state sa4 sa3 sa2 sa1 gccsa sua sos sosr ucl ra sla lga ssc poa ced sed; \
	do \
		cat src/02-bcp-create-schema-template.sql | sed s/{structure}/$$s/g | psql -f - ; \
		cat src/02-pep-create-schema-template.sql | sed s/{structure}/$$s/g | psql -f - ; \
	done
	
	# Indigenous Profile
	echo "creating tables for IP..."
	for s in aust state sa4 sa3 sa2 gccsa ireg iare iloc ra sla lga; \
	do \
		cat src/02-ip-create-schema-template.sql | sed s/{structure}/$$s/g | psql -f - ; \
	done
	
	# Time Series Profile & Estimated Resident Population Profile
	echo "creating tables for TSP, ERPP..."
	for s in aust state sa4 sa3 sa2 gccsa sla lga; \
	do \
		cat src/02-tsp-create-schema-template.sql | sed s/{structure}/$$s/g | psql -f - ; \
		cat src/02-erpp-create-schema-template.sql | sed s/{structure}/$$s/g | psql -f - ; \
	done
	
	# Working Population Profile
	echo "creating tables for WPP..."
	for s in aust state sa4 sa3 sa2 gccsa lga; \
	do \
		cat src/02-wpp-create-schema-template.sql | sed s/{structure}/$$s/g | psql -f - ; \
	done
	
	# Expanded Community Profile
	echo "creating tables for ECP..."
	for s in aust state sa4 sa3 sa2 gccsa sua sla lga; \
	do \
		cat src/02-ecp-create-schema-template.sql | sed s/{structure}/$$s/g | psql -f - ; \
	done
	
	# Socio-Economic Indexes for Areas
	echo "creating tables for SEIFA..."
	for s in state sa4 sa3 sa2 sa1 sla lga ssc poa ced; \
	do \
		cat src/02-seifa-create-schema-template.sql | sed s/{structure}/$$s/g | psql -f - ; \
	done

prepare_load :
	src/03-expand-template.pl < src/03-load-template.map | src/04-prepare-from-expansion.pl
	cat age.copy | sort | uniq | psql -c "COPY census_2011.age FROM STDIN;"
	rm -f age.copy

load_metadata_table :
	psql -f src/04-create-metadata-schema.sql
	cat datapack-metadata.copy | psql -c "COPY census_2011.datapack_metadata FROM STDIN;"
	rm -f datapack-metadata.copy

load :

