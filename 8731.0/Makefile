all : clean load

clean :
	psql -c "DROP TABLE IF EXISTS abs_8731_0_staging;"
	psql -c "DROP TABLE IF EXISTS abs_8731_0_state;"
	psql -c "DROP TABLE IF EXISTS abs_8731_0_gccsa;"
	psql -c "DROP TABLE IF EXISTS abs_8731_0_sa4;"
	psql -c "DROP TABLE IF EXISTS abs_8731_0_sa3;"
	psql -c "DROP TABLE IF EXISTS abs_8731_0_sa2;"

load :
	psql -f create-staging-table.sql
	cat data/Feb2012/8-months-to-feb-2012-fytd | psql -c 'COPY abs_8731_0_staging FROM STDIN;'
	psql -f create-final-tables.sql
	psql -c "DROP TABLE abs_8731_0_staging;"

export :
	./export.sh

generate_classifications :
	../classify/generate-classifications.sh 5 'new_houses\/area' 'sa2' 'abs_8731_0'
