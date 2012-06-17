-- This file defines the target PostgreSQL schema for the ABS 2011 Census
-- for the Aboriginal and Torres Strait Islander Peoples (Indigenous)
-- Profile product.

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


-- I02
CREATE TABLE census_2011.ip_indigenous_status_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure}(code),
  sex census_2011.sex,
  indigenous_status census_2011.indigenous_status,

  persons integer,

  PRIMARY KEY (asgs_code, sex, indigenous_status)
);

-- I03
CREATE TABLE census_2011.ip_age_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure}(code),
  age text REFERENCES census_2011.age(range),
  sex census_2011.sex,
  indigenous_status census_2011.yes_no_notstated,

  persons integer,

  PRIMARY KEY (asgs_code, age, sex, indigenous_status)
);

-- I04
CREATE TABLE census_2011.ip_selected_medians_and_averages_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure}(code),
  indigenous boolean, -- true: Indigenous_persons_households_with_Indigenous_persons, false: Non_Indigenous_persons_other_households

  median_age_of_persons integer,
  median_total_personal_income_weekly integer,
  median_total_household_income_weekly integer,
  median_mortgage_repayment_monthly integer,
  median_rent_weekly integer,
  average_number_of_persons_per_bedroom integer,
  average_household_size integer,
  proportion_of_dwellings_that_need_1_or_more_extra_bedrooms integer,

  PRIMARY KEY (asgs_code, indigenous)
);

-- I05
CREATE TABLE census_2011.ip_type_of_educational_institution_attending_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure}(code),
  sex census_2011.sex,
  educational_institution serial REFERENCES census_2011.indigenous_educational_institution,
  indigenous_status census_2011.yes_no_notstated,

  persons_attending_an_educational_institution integer,

  PRIMARY KEY (asgs_code, sex, educational_institution)
);

-- I06
CREATE TABLE census_2011.ip_highest_year_of_school_completed_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure}(code),
  sex census_2011.sex,
  school_year census_2011.school_year,
  indigenous_status census_2011.yes_no_notstated,

  -- PostgreSQL Limitation
  -- persons_aged_15_years_and_over_who_are_no_longer_attending_primary_or_secondary_school integer,
  persons_aged_15_yrs_and_over_no_longer_attd_prm_or_sec_school integer,

  PRIMARY KEY (asgs_code, sex, school_year, indigenous_status)
);

-- I07
CREATE TABLE census_2011.ip_personal_income_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure}(code),
  sex census_2011.sex,
  income_band smallint REFERENCES census_2011.indigenous_income_band(code),

  indigenous_persons_aged_15_years_and_over integer,

  PRIMARY KEY (asgs_code, sex, income_band)
);

-- I08
CREATE TABLE census_2011.ip_core_activity_need_for_assistance_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure}(code),
  age text REFERENCES census_2011.age(range),
  sex census_2011.sex,
  need_assistance census_2011.yes_no_notstated,

  indigenous_persons integer,

  PRIMARY KEY (asgs_code, age, sex, need_assistance)
);

-- I09
CREATE TABLE census_2011.ip_unpaid_assistance_to_a_person_with_a_disability_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure}(code),
  age text REFERENCES census_2011.age(range),
  sex census_2011.sex,
  provided_assistance census_2011.yes_no_notstated,

  indigenous_persons_aged_15_years_and_over integer,

  PRIMARY KEY (asgs_code, age, sex, provided_assistance)
);

-- I10
CREATE TABLE census_2011.ip_tenure_type_and_landlord_type_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure}(code),
  dwelling_structure census_2011.dwelling_structure_indigenous,
  tenure_landlord_type census_2011.tenure_landlord_type,
  indigenous_household boolean,

  occupied_private_dwellings integer,

  PRIMARY KEY (asgs_code, dwelling_structure, tenure_landlord_type, indigenous_household)
);

-- I11
CREATE TABLE census_2011.ip_internet_connection_type_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure}(code),
  indigenous_household boolean,
  internet_connection census_2011.internet_connection,

  occupied_private_dwellings integer,

  PRIMARY KEY (asgs_code, indigenous_household, internet_connection)
);

-- I12
CREATE TABLE census_2011.ip_household_composition_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure}(code),
  indigenous_household boolean,
  household_type census_2011.household_type,
  number_of_persons_usually_resident census_2011.number_of_persons_usually_resident,

  occupied_private_dwellings integer,

  PRIMARY KEY (asgs_code, indigenous_household, household_type, number_of_persons_usually_resident)
);

-- I13
CREATE TABLE census_2011.ip_household_income_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure}(code),
  indigenous_household boolean,
  income_range census_2011.indigenous_household_income_band,

  occupied_private_dwellings integer,

  PRIMARY KEY (asgs_code, indigenous_household, income_range)
);

-- I15
CREATE TABLE census_2011.ip_non_school_qualification_level_of_education_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure}(code),
  age text REFERENCES census_2011.age(range),
  sex census_2011.sex,
  indigenous_status census_2011.yes_no_notstated,
    
  non_school_level_of_education serial REFERENCES census_2011.non_school_level_of_education_simple,

  persons_aged_15_years_and_over_with_a_qualification integer,

  PRIMARY KEY (asgs_code, age, sex, indigenous_status, non_school_level_of_education)
);

-- I16
CREATE TABLE census_2011.ip_labour_force_status_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure}(code),
  age text REFERENCES census_2011.age(range),
  sex census_2011.sex,
  employment_status census_2011.employment_status_simple,

  indigenous_persons_aged_15_years_and_over integer,

  PRIMARY KEY (asgs_code, age, sex, employment_status)
);
