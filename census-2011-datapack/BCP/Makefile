# Author: Andrew Harvey (http://andrewharvey4.wordpress.com/)
#
# To the extent possible under law, the person who associated CC0
# with this work has waived all copyright and related or neighboring
# rights to this work.
# http://creativecommons.org/publicdomain/zero/1.0/


all : clean create_schema load

clean :
	psql -c "DROP SCHEMA IF EXISTS census_2011 CASCADE;"

create_schema :
	psql -c "CREATE SCHEMA census_2011;"
	
	# create the database schema and _csv tables
	psql -f 01-bcp-create-datatypes.sql
	#mb sa1 sa2 sa3 sa4 gccsa state iloc iare ireg tr poa ssc ced sed add nrmr lga
	for s in aust ; \
	do \
		cat 02-bcp-create-schema-template.sql | sed s/{structure}/$$s/g | psql -f - ; \
	done

load :
	
