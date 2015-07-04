# This file is licensed CC0 by Andrew Harvey <andrew.harvey4@gmail.com>
#
# To the extent possible under law, the person who associated CC0
# with this work has waived all copyright and related or neighboring
# rights to this work.
# http://creativecommons.org/publicdomain/zero/1.0/

all : clean create_schema create_tables prepare_load load_metadata_table load_psql mb_counts

clean :
	psql -c "DROP SCHEMA IF EXISTS census_2011 CASCADE;"
	rm -f *.copy load-template

create_schema :
	psql -c "CREATE SCHEMA census_2011;"
	
	# create the datatypes used by my census_2011 schema
	psql -f src/01-create-datatypes.sql

create_tables :
	# create the tables for each of the products for each of the geographic
	# areas for which they are available.
	src/02-create-tables.sh bcp ip tsp

prepare_load :
	# push patches
	export QUILT_PATCHES=patches && cd DataPack-Metadata && quilt push -a && cd ../
	# expand load template and prepare it
	src/03-expand-template.pl < src/03-load-template.map | src/04-prepare-from-expansion.pl
	# pop patches
	export QUILT_PATCHES=patches && cd DataPack-Metadata && quilt pop -a && cd ../

load_metadata_table :
	psql -f src/04-create-metadata-schema.sql
	cat datapack-metadata.copy | psql -c "COPY census_2011.datapack_metadata FROM STDIN;"
	rm -f datapack-metadata.copy

# and finally actually load the ABS Census Data
load_psql :
	src/05-load.sh bcp ip tsp
	
	# clean up
	rm -f load-template

mb_counts :
	cd mb-counts && make -f Makefile
