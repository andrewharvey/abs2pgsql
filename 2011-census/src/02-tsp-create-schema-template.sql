-- This file defines the target PostgreSQL schema for the ABS 2011 Census
-- for the Time Series Profile product.

-- This file is licensed CC0 by Andrew Harvey <andrew.harvey4@gmail.com>
--
-- To the extent possible under law, the person who associated CC0
-- with this work has waived all copyright and related or neighboring
-- rights to this work.
-- http://creativecommons.org/publicdomain/zero/1.0/
--
-- This schema is partly derived from the ABS 2011 Census Datapack Samples
-- which are Copyright Australian Bureau of Statistics (ABS) http://abs.gov.au/,
-- Commonwealth of Australia and licensed under the CC BY 2.5 AU license
-- http://creativecommons.org/licenses/by/2.5/au/ by the ABS.
-- The datapack samples were retrieved from 
-- http://www.abs.gov.au/websitedbs/censushome.nsf/home/datapackssample?opendocument&navpos=250


-- T03
CREATE TABLE census_2011.tsp_population_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure}(code),
  age smallint REFERENCES census_2011.population_age_ranges(min),
  sex census_2011.sex,
  year census_2011.tsp_years,

  persons integer,

  PRIMARY KEY (asgs_code, age, sex, year)
);

-- T03
CREATE TABLE census_2011.tsp_overseas_visitors_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure}(code),
  sex census_2011.sex,
  year census_2011.tsp_years,

  persons integer,

  PRIMARY KEY (asgs_code, sex, year)
);
