-- create the final tables with the ideal schema
-- and load the date from the staging table

CREATE TABLE abs_8731_0_state
(
  "code" asgs_2011.state_code PRIMARY KEY REFERENCES asgs_2011.state(code),

  "new_houses" integer,
  "new_other_residential_building" integer,
  "total_dwellings" integer,

  "value_of_new_houses" bigint,
  "value_of_new_other_residential_building" bigint,
  "value_of_alterations_and_additions_to_residential_buildings" bigint,
  "value_of_total_residential_building" bigint,
  "value_of_nonresidential_building" bigint,
  "value_of_total_building" bigint
);

WITH selection AS (
  SELECT
    code::asgs_2011.state_code,
    new_houses,
    new_other_residential_building,
    total_dwellings,
    value_of_new_houses * 1000 as value_of_new_houses,
    value_of_new_other_residential_building * 1000 as value_of_new_other_residential_building,
    value_of_alterations_and_additions_to_residential_buildings * 1000 as value_of_alterations_and_additions_to_residential_buildings,
    value_of_total_residential_building * 1000 as value_of_total_residential_building,
    value_of_nonresidential_building * 1000 as value_of_nonresidential_building,
    value_of_total_building * 1000 as value_of_total_building
   FROM
     abs_8731_0_staging
   WHERE
     asgs_2011.match_abs_structure_code(code) = 'state'
) INSERT INTO abs_8731_0_state SELECT * from selection;


CREATE TABLE abs_8731_0_gccsa
(
  "code" asgs_2011.gccsa_code PRIMARY KEY REFERENCES asgs_2011.gccsa(code),

  "new_houses" integer,
  "new_other_residential_building" integer,
  "total_dwellings" integer,

  "value_of_new_houses" bigint,
  "value_of_new_other_residential_building" bigint,
  "value_of_alterations_and_additions_to_residential_buildings" bigint,
  "value_of_total_residential_building" bigint,
  "value_of_nonresidential_building" bigint,
  "value_of_total_building" bigint
);

WITH selection AS (
  SELECT
    code::asgs_2011.gccsa_code,
    new_houses,
    new_other_residential_building,
    total_dwellings,
    value_of_new_houses * 1000 as value_of_new_houses,
    value_of_new_other_residential_building * 1000 as value_of_new_other_residential_building,
    value_of_alterations_and_additions_to_residential_buildings * 1000 as value_of_alterations_and_additions_to_residential_buildings,
    value_of_total_residential_building * 1000 as value_of_total_residential_building,
    value_of_nonresidential_building * 1000 as value_of_nonresidential_building,
    value_of_total_building * 1000 as value_of_total_building
   FROM
     abs_8731_0_staging
   WHERE
     asgs_2011.match_abs_structure_code(code) = 'gccsa'
) INSERT INTO abs_8731_0_gccsa SELECT * from selection;


CREATE TABLE abs_8731_0_sa4
(
  "code" asgs_2011.sa4_code PRIMARY KEY REFERENCES asgs_2011.sa4(code),

  "new_houses" integer,
  "new_other_residential_building" integer,
  "total_dwellings" integer,

  "value_of_new_houses" bigint,
  "value_of_new_other_residential_building" bigint,
  "value_of_alterations_and_additions_to_residential_buildings" bigint,
  "value_of_total_residential_building" bigint,
  "value_of_nonresidential_building" bigint,
  "value_of_total_building" bigint
);

WITH selection AS (
  SELECT
    code::asgs_2011.sa4_code,
    new_houses,
    new_other_residential_building,
    total_dwellings,
    value_of_new_houses * 1000 as value_of_new_houses,
    value_of_new_other_residential_building * 1000 as value_of_new_other_residential_building,
    value_of_alterations_and_additions_to_residential_buildings * 1000 as value_of_alterations_and_additions_to_residential_buildings,
    value_of_total_residential_building * 1000 as value_of_total_residential_building,
    value_of_nonresidential_building * 1000 as value_of_nonresidential_building,
    value_of_total_building * 1000 as value_of_total_building
   FROM
     abs_8731_0_staging
   WHERE
     asgs_2011.match_abs_structure_code(code) = 'sa4'
) INSERT INTO abs_8731_0_sa4 SELECT * from selection;


CREATE TABLE abs_8731_0_sa3
(
  "code" asgs_2011.sa3_code PRIMARY KEY REFERENCES asgs_2011.sa3(code),

  "new_houses" integer,
  "new_other_residential_building" integer,
  "total_dwellings" integer,

  "value_of_new_houses" bigint,
  "value_of_new_other_residential_building" bigint,
  "value_of_alterations_and_additions_to_residential_buildings" bigint,
  "value_of_total_residential_building" bigint,
  "value_of_nonresidential_building" bigint,
  "value_of_total_building" bigint
);

WITH selection AS (
  SELECT
    code::asgs_2011.sa3_code,
    new_houses,
    new_other_residential_building,
    total_dwellings,
    value_of_new_houses * 1000 as value_of_new_houses,
    value_of_new_other_residential_building * 1000 as value_of_new_other_residential_building,
    value_of_alterations_and_additions_to_residential_buildings * 1000 as value_of_alterations_and_additions_to_residential_buildings,
    value_of_total_residential_building * 1000 as value_of_total_residential_building,
    value_of_nonresidential_building * 1000 as value_of_nonresidential_building,
    value_of_total_building * 1000 as value_of_total_building
   FROM
     abs_8731_0_staging
   WHERE
     asgs_2011.match_abs_structure_code(code) = 'sa3'
) INSERT INTO abs_8731_0_sa3 SELECT * from selection;


CREATE TABLE abs_8731_0_sa2
(
  "code" asgs_2011.sa2_code PRIMARY KEY REFERENCES asgs_2011.sa2(code),

  "new_houses" integer,
  "new_other_residential_building" integer,
  "total_dwellings" integer,

  "value_of_new_houses" bigint,
  "value_of_new_other_residential_building" bigint,
  "value_of_alterations_and_additions_to_residential_buildings" bigint,
  "value_of_total_residential_building" bigint,
  "value_of_nonresidential_building" bigint,
  "value_of_total_building" bigint
);

WITH selection AS (
  SELECT
    code::asgs_2011.sa2_code,
    new_houses,
    new_other_residential_building,
    total_dwellings,
    value_of_new_houses * 1000 as value_of_new_houses,
    value_of_new_other_residential_building * 1000 as value_of_new_other_residential_building,
    value_of_alterations_and_additions_to_residential_buildings * 1000 as value_of_alterations_and_additions_to_residential_buildings,
    value_of_total_residential_building * 1000 as value_of_total_residential_building,
    value_of_nonresidential_building * 1000 as value_of_nonresidential_building,
    value_of_total_building * 1000 as value_of_total_building
   FROM
     abs_8731_0_staging
   WHERE
     asgs_2011.match_abs_structure_code(code) = 'sa2'
) INSERT INTO abs_8731_0_sa2 SELECT * from selection;
