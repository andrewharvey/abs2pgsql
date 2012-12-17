# This file is licensed CC0 by Andrew Harvey <andrew.harvey4@gmail.com>
#
# To the extent possible under law, the person who associated CC0
# with this work has waived all copyright and related or neighboring
# rights to this work.
# http://creativecommons.org/publicdomain/zero/1.0/

f=censuscounts_mb_2011_aust.csv

all : clean download create_schema load

clean :
	rm -f $f
	psql -c "DROP TABLE IF EXISTS census_2011.mb_counts;"

download :
	wget -O $f 'http://abs.gov.au/ausstats/subscriber.nsf/log?openagent&censuscounts_mb_2011_aust.csv&2074.0&Data%20Cubes&B573366A0A37265ACA257AD0000F1E5A&0&2011&11.12.2012&Latest'

create_schema :
	psql -f create-table.sql

load :
	cat $f | head --lines=-3 | psql -c "COPY census_2011.mb_counts FROM STDIN WITH (FORMAT csv, HEADER);"
