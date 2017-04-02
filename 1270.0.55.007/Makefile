all: australian_population_grid_2011_tif_format.zip unzip load clean

clean:
	rm -f australian_population_grid_2011_tif_format.zip
	rm -f Australian_Population_Grid_2011*

australian_population_grid_2011_tif_format.zip:
	# http://www.abs.gov.au/AUSSTATS/abs@.nsf/DetailsPage/1270.0.55.0072011?OpenDocument
	wget -O $@ "http://www.abs.gov.au/AUSSTATS/subscriber.nsf/log?openagent&$@&1270.0.55.007&Data%20Cubes&E0D7D30C837EFC26CA257DB10016122C&0&2011&18.12.2014&Latest"

unzip: australian_population_grid_2011_tif_format.zip
	unzip $<

load:
	raster2pgsql -d -I -M -t auto Australian_Population_Grid_2011.tif australian_population_grid_2011 | psql --quiet

