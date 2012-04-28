-- create a staging table with a structure the same as the source text file
-- (which was created by copy pasting from the XLS file)
CREATE TABLE abs_8731_0_staging
(
  "code" character varying(11) PRIMARY KEY,
  "name" text,
  "new_houses" integer,
  "new_other_residential_building" integer,
  "total_dwellings" integer,

  "value_of_new_houses" numeric(10,1),
  "value_of_new_other_residential_building" numeric(10,1),
  "value_of_alterations_and_additions_to_residential_buildings" numeric(10,1),
  "value_of_total_residential_building" numeric(10,1),
  "value_of_nonresidential_building" numeric(10,1),
  "value_of_total_building" numeric(10,1)
);

