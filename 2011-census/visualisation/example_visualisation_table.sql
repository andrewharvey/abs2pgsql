CREATE SCHEMA abs;
CREATE TABLE
    abs.bcp_selected_medians_and_averages_sa1
AS
    SELECT
        spatial.geom, 
        spatial.oid,
        nonspatial.*
    FROM
        census_2011.bcp_selected_medians_and_averages_sa1 nonspatial
        ,
        asgs_2011.sa1 spatial
    WHERE spatial.code = nonspatial.asgs_code
;

