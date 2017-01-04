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


-- T02
CREATE TABLE census_2011.tsp_selected_medians_and_averages_{structure}
(
  asgs_code asgs.{structure}_code REFERENCES asgs_2011.{structure},
  year census_2011.tsp_years,

  median_age_of_persons integer,
  median_mortgage_repayment_monthly integer,
  median_total_personal_income_weekly integer,
  median_rent_weekly integer,
  median_total_family_income_weekly integer,
  average_number_of_persons_per_bedroom real,
  median_total_household_income_weekly integer,
  average_household_size real,

  PRIMARY KEY (asgs_code, year)
);

-- T03
CREATE TABLE census_2011.tsp_age_{structure}
(
  asgs_code asgs.{structure}_code REFERENCES asgs_2011.{structure},
  age census_2011.age,
  sex census_2011.sex,
  year census_2011.tsp_years,

  persons integer,

  PRIMARY KEY (asgs_code, age, sex, year)
);

-- T03
CREATE TABLE census_2011.tsp_overseas_visitors_{structure}
(
  asgs_code asgs.{structure}_code REFERENCES asgs_2011.{structure},
  sex census_2011.sex,
  year census_2011.tsp_years,

  persons integer,

  PRIMARY KEY (asgs_code, sex, year)
);

-- T04
CREATE TABLE census_2011.tsp_registered_marital_status_{structure}
(
  asgs_code asgs.{structure}_code REFERENCES asgs_2011.{structure},
  age census_2011.age,
  sex census_2011.sex,
  registered_marital_status serial REFERENCES census_2011.registered_marital_status,
  year census_2011.tsp_years,

  persons_aged_15_years_and_over integer,

  PRIMARY KEY (asgs_code, age, sex, registered_marital_status, year)
);

-- T05
CREATE TABLE census_2011.tsp_social_marital_status_{structure}
(
  asgs_code asgs.{structure}_code REFERENCES asgs_2011.{structure},
  age census_2011.age,
  sex census_2011.sex,
  social_marital_status serial REFERENCES census_2011.social_marital_status,
  year census_2011.tsp_years,

  persons_aged_15_years_and_over integer,

  PRIMARY KEY (asgs_code, age, sex, social_marital_status, year)
);

-- T06
CREATE TABLE census_2011.tsp_indigenous_status_{structure}
(
  asgs_code asgs.{structure}_code REFERENCES asgs_2011.{structure},
  age census_2011.age,
  sex census_2011.sex,
  indigenous census_2011.yes_no_notstated,
  year census_2011.tsp_years,

  persons integer,

  PRIMARY KEY (asgs_code, age, sex, indigenous, year)
);

-- TODO T07

-- T08
CREATE TABLE census_2011.tsp_country_of_birth_of_person_{structure}
(
  asgs_code asgs.{structure}_code REFERENCES asgs_2011.{structure},
  sex census_2011.sex,
  country_of_birth serial REFERENCES census_2011.birthplace,
  year census_2011.tsp_years,

  persons integer,

  PRIMARY KEY (asgs_code, sex, country_of_birth, year)
);

-- T09
CREATE TABLE census_2011.tsp_ancestry_{structure}
(
  asgs_code asgs.{structure}_code REFERENCES asgs_2011.{structure},
  ancestry serial REFERENCES census_2011.ancestry,
  birthplace_of_parents serial REFERENCES census_2011.parent_birthplace_combination,
  year census_2011.tsp_years,

  persons integer,

  PRIMARY KEY (asgs_code, ancestry, birthplace_of_parents, year)
);

-- T10
CREATE TABLE census_2011.tsp_language_spoken_at_home_{structure}
(
  asgs_code asgs.{structure}_code REFERENCES asgs_2011.{structure},
  sex census_2011.sex,
  language serial REFERENCES census_2011.language_tsp,
  year census_2011.tsp_years,

  persons integer,

  PRIMARY KEY (asgs_code, sex, language, year)
);

-- T13
CREATE TABLE census_2011.tsp_type_of_educational_institution_attending_{structure}
(
  asgs_code asgs.{structure}_code REFERENCES asgs_2011.{structure},
  sex census_2011.sex,
  educational_institution serial REFERENCES census_2011.educational_institution,
  year census_2011.tsp_years,

  persons_attending_an_educational_institution integer,

  PRIMARY KEY (asgs_code, sex, educational_institution, year)
);

-- T14
-- PostgreSQL Limitation
-- census_2011.tsp_dwelling_structure_by_household_composition_and_family_composition_{structure}
CREATE TABLE census_2011.tsp_dwelling_structure_by_household_comp_and_fam_comp_{structure}
(
  asgs_code asgs.{structure}_code REFERENCES asgs_2011.{structure},
  household_composition census_2011.household_type_simple,
  family_composition serial REFERENCES census_2011.family_type,
  dwelling_structure serial REFERENCES census_2011.dwelling_structure_extended_full,
  year census_2011.tsp_years,

  occupied_private_dwellings integer,

  PRIMARY KEY (asgs_code, household_composition, family_composition, dwelling_structure, year)
);

-- T15
-- PostgreSQL Limitation
-- census_2011.tsp_dwelling_structure_by_number_of_persons_usually_resident_{structure}
CREATE TABLE census_2011.tsp_dwelling_structure_by_num_persons_usually_resident_{structure}
(
  asgs_code asgs.{structure}_code REFERENCES asgs_2011.{structure},
  number_of_persons_usually_resident census_2011.number_of_persons_usually_resident,
  dwelling_structure serial REFERENCES census_2011.dwelling_structure_extended_full,
  year census_2011.tsp_years,

  occupied_private_dwellings integer,

  PRIMARY KEY (asgs_code, number_of_persons_usually_resident, dwelling_structure, year)
);

-- TODO do rest
