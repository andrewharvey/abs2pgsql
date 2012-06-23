-- This file defines the target PostgreSQL schema for the ABS 2011 Census
-- for the Basic Community Profile product.

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


-- B02
CREATE TABLE census_2011.bcp_selected_medians_and_averages_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},

  median_age_of_persons integer,
  median_mortgage_repayment_monthly integer,
  median_total_personal_income_weekly integer,
  median_rent_weekly integer,
  median_total_family_income_weekly integer,
  average_number_of_persons_per_bedroom integer,
  median_total_household_income_weekly integer,
  average_household_size integer,

  PRIMARY KEY (asgs_code)
);

-- B03
CREATE TABLE census_2011.bcp_place_of_usual_residence_on_census_night_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},
  age text REFERENCES census_2011.age(range),
  place_of_usual_residence census_2011.place_of_usual_residence,

  visitor_from_different_sa2_state_code asgs_2011.ste_code REFERENCES asgs_2011.ste(code),

  persons integer,

  PRIMARY KEY (asgs_code, age, place_of_usual_residence)
);

-- B04
CREATE TABLE census_2011.bcp_age_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},
  age text REFERENCES census_2011.age(range),
  sex census_2011.sex,

  persons integer,

  PRIMARY KEY (asgs_code, age, sex)
);

-- B05
CREATE TABLE census_2011.bcp_registered_marital_status_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},
  age text REFERENCES census_2011.age(range),
  sex census_2011.sex,
  registered_marital_status census_2011.registered_marital_status,

  persons_aged_15_years_and_over integer,

  PRIMARY KEY (asgs_code, age, sex, registered_marital_status)
);

-- B06
CREATE TABLE census_2011.bcp_social_marital_status_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},
  age text REFERENCES census_2011.age(range),
  sex census_2011.sex,
  social_marital_status census_2011.social_marital_status,

  persons_aged_15_years_and_over integer,

  PRIMARY KEY (asgs_code, age, sex, social_marital_status)
);

-- B07
CREATE TABLE census_2011.bcp_indigenous_status_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},
  age text REFERENCES census_2011.age(range),
  sex census_2011.sex,
  indigenous census_2011.yes_no_notstated,

  persons integer,

  PRIMARY KEY (asgs_code, age, sex, indigenous)
);

-- B08
CREATE TABLE census_2011.bcp_ancestry_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},
  parent_birthplace_combination census_2011.parent_birthplace_combination,
  ancestry census_2011.ancestry,

  persons integer,

  PRIMARY KEY (asgs_code, parent_birthplace_combination, ancestry)
);

-- B09
CREATE TABLE census_2011.bcp_country_of_birth_of_person_by_sex_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},
  sex census_2011.sex,
  country_of_birth census_2011.birthplace,

  persons integer,

  PRIMARY KEY (asgs_code, sex, country_of_birth)
);

-- B10
CREATE TABLE census_2011.bcp_country_of_birth_of_person_by_year_of_arrival_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},
  year_of_arrival smallint REFERENCES census_2011.year_of_arrival,
  country_of_birth census_2011.birthplace,

  persons_born_overseas integer,

  PRIMARY KEY (asgs_code, year_of_arrival, country_of_birth)
);

-- B11
CREATE TABLE census_2011.bcp_proficiency_in_spoken_english_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},
  year_of_arrival smallint REFERENCES census_2011.year_of_arrival_b,
  sex census_2011.sex,
  proficiency serial REFERENCES census_2011.english_proficiency,

  persons_born_overseas integer,

  PRIMARY KEY (asgs_code, year_of_arrival, sex, proficiency)
);

-- B12
CREATE TABLE census_2011.bcp_proficiency_in_spoken_english_of_parents_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},
  child_age text REFERENCES census_2011.age(range),
  proficiency_male_parent serial REFERENCES census_2011.english_proficiency,
  proficiency_female_parent serial REFERENCES census_2011.english_proficiency,

  dependent_children_in_couple_families integer,

  PRIMARY KEY (asgs_code, child_age, proficiency_male_parent, proficiency_female_parent)
);

-- B13
CREATE TABLE census_2011.bcp_language_spoken_at_home_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},
  sex census_2011.sex,
  language census_2011.language,

  persons integer,

  PRIMARY KEY (asgs_code, sex, language)
);

-- B14
CREATE TABLE census_2011.bcp_religious_affiliation_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},
  sex census_2011.sex,
  religious_affiliation serial REFERENCES census_2011.religious_affiliation,

  persons integer,

  PRIMARY KEY (asgs_code, sex, religious_affiliation)
);

-- B15
CREATE TABLE census_2011.bcp_type_of_educational_institution_attending_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},
  sex census_2011.sex,
  educational_institution serial REFERENCES census_2011.educational_institution,

  persons_attending_an_educational_institution integer,

  PRIMARY KEY (asgs_code, sex, educational_institution)
);

-- B16
CREATE TABLE census_2011.bcp_highest_year_of_school_completed_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},
  sex census_2011.sex,
  age text REFERENCES census_2011.age(range),
  school_year census_2011.school_year,

  -- PostgreSQL Limitation
  -- persons_aged_15_years_and_over_who_are_no_longer_attending_primary_or_secondary_school integer,
  persons_aged_15_yrs_and_over_no_longer_attd_prim_or_sec_school integer,

  PRIMARY KEY (asgs_code, sex, age, school_year)
);

-- B17
CREATE TABLE census_2011.bcp_total_personal_income_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},
  age text REFERENCES census_2011.age(range),
  sex census_2011.sex,
  income_band smallint REFERENCES census_2011.income_band(code),

  persons_aged_15_years_and_over integer,

  PRIMARY KEY (asgs_code, age, sex, income_band)
);

-- B18
CREATE TABLE census_2011.bcp_core_activity_need_for_assistance_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},
  age text REFERENCES census_2011.age(range),
  sex census_2011.sex,
  need_assistance census_2011.yes_no_notstated,

  persons integer,

  PRIMARY KEY (asgs_code, age, sex, need_assistance)
);

-- B19
CREATE TABLE census_2011.bcp_voluntary_work_for_an_organisation_or_group_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},
  age text REFERENCES census_2011.age(range),
  sex census_2011.sex,
  volunteered census_2011.yes_no_notstated,

  persons integer,

  PRIMARY KEY (asgs_code, age, sex, volunteered)
);

-- B20
CREATE TABLE census_2011.bcp_unpaid_domestic_work_number_of_hours_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},
  age text REFERENCES census_2011.age(range),
  sex census_2011.sex,
  unpaid_domestic_work_amount smallint REFERENCES census_2011.unpaid_domestic_work(code),

  persons_aged_15_years_and_over integer,

  PRIMARY KEY (asgs_code, age, sex, unpaid_domestic_work_amount)
);

-- B21
CREATE TABLE census_2011.bcp_unpaid_assistance_to_a_person_with_a_disability_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},
  age text REFERENCES census_2011.age(range),
  sex census_2011.sex,
  provided_assistance census_2011.yes_no_notstated,

  persons_aged_15_years_and_over integer,

  PRIMARY KEY (asgs_code, age, sex, provided_assistance)
);

-- B22
CREATE TABLE census_2011.bcp_unpaid_child_care_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},
  age text REFERENCES census_2011.age(range),
  sex census_2011.sex,
  child_care census_2011.child_care,

  persons_aged_15_years_and_over integer,

  PRIMARY KEY (asgs_code, age, sex, child_care)
);

-- B23
CREATE TABLE census_2011.bcp_relationship_in_household_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},
  age text REFERENCES census_2011.age(range),
  sex census_2011.sex,
  household_relationship census_2011.household_relationship,

  persons_in_occupied_private_dwellings integer,

  PRIMARY KEY (asgs_code, age, sex, household_relationship)
);

-- B24
CREATE TABLE census_2011.bcp_number_of_children_ever_born_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},
  age_of_parent text REFERENCES census_2011.age(range),
  number_of_children_ever_born census_2011.number_of_children,

  females_aged_15_years_and_over integer,

  PRIMARY KEY (asgs_code, age_of_parent, number_of_children_ever_born)
);

-- B25
CREATE TABLE census_2011.bcp_family_composition_families_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},
  family_type census_2011.family_type,
  children_under_15 boolean,
  dependent_students boolean,
  non_dependent_children boolean,

  families integer,

  PRIMARY KEY (asgs_code, family_type, children_under_15, dependent_students, non_dependent_children)
);

CREATE TABLE census_2011.bcp_family_composition_persons_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},
  family_type census_2011.family_type,
  children_under_15 boolean,
  dependent_students boolean,
  non_dependent_children boolean,

  persons integer,

  PRIMARY KEY (asgs_code, family_type, children_under_15, dependent_students, non_dependent_children)
);

-- B26
CREATE TABLE census_2011.bcp_total_family_income_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},
  family_type census_2011.family_type,
  income_range census_2011.family_income_band,

  families integer,

  PRIMARY KEY (asgs_code, family_type, income_range)
);

-- B27
CREATE TABLE census_2011.bcp_family_blending_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},
  blended_family_type census_2011.blended_family_type,
  other_children_present boolean,

  families integer,

  PRIMARY KEY (asgs_code, blended_family_type, other_children_present)
);

-- B28
CREATE TABLE census_2011.bcp_total_household_income_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},
  income_range census_2011.family_income_band,
  family_household boolean,

  occupied_private_dwellings integer,

  PRIMARY KEY (asgs_code, income_range, family_household)
);

-- B29
CREATE TABLE census_2011.bcp_number_of_motor_vehicles_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},
  number_of_motor_vehicles census_2011.number_of_motor_vehicles,

  occupied_private_dwellings integer,

  PRIMARY KEY (asgs_code, number_of_motor_vehicles)
);

-- B30
CREATE TABLE census_2011.bcp_household_composition_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},
  number_of_persons_usually_resident census_2011.number_of_persons_usually_resident,
  family_household boolean,

  persons integer,

  PRIMARY KEY (asgs_code, number_of_persons_usually_resident, family_household)
);

-- B31
CREATE TABLE census_2011.bcp_dwelling_structure_dwellings_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},
  dwelling_structure serial REFERENCES census_2011.dwelling_structure_extended_full,

  dwellings integer,

  PRIMARY KEY (asgs_code, dwelling_structure)
);

CREATE TABLE census_2011.bcp_dwelling_structure_persons_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},
  dwelling_structure serial REFERENCES census_2011.dwelling_structure_extended_full,

  persons integer,

  PRIMARY KEY (asgs_code, dwelling_structure)
);

-- B32
CREATE TABLE census_2011.bcp_tenure_type_and_landlord_type_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},
  dwelling_structure census_2011.dwelling_structure_simple,
  tenure_landlord_type census_2011.tenure_landlord_type,

  occupied_private_dwellings integer,

  PRIMARY KEY (asgs_code, dwelling_structure, tenure_landlord_type)
);

-- B33
CREATE TABLE census_2011.bcp_mortgage_repayment_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},
  income_range census_2011.income_band,
  dwelling_structure census_2011.dwelling_structure_simple,

  occupied_private_dwellings_being_purchased integer,

  PRIMARY KEY (asgs_code, income_range, dwelling_structure)
);

-- B34
CREATE TABLE census_2011.bcp_rent_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},
  rent_band census_2011.rental_payment_band,
  landlord_type census_2011.landlord_type,

  occupied_private_dwellings_being_rented integer,

  PRIMARY KEY (asgs_code, rent_band, landlord_type)
);

-- B35
CREATE TABLE census_2011.bcp_type_of_internet_connection_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},
  dwelling_structure census_2011.dwelling_structure_simple,
  internet_connection census_2011.internet_connection,

  occupied_private_dwellings integer,

  PRIMARY KEY (asgs_code, dwelling_structure, internet_connection)
);

-- B36
CREATE TABLE census_2011.bcp_dwelling_structure_by_number_of_bedrooms_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},
  dwelling_structure serial REFERENCES census_2011.dwelling_structure_extended_minimal,
  number_of_bedrooms census_2011.number_of_bedrooms,

  occupied_private_dwellings integer,

  PRIMARY KEY (asgs_code, dwelling_structure, number_of_bedrooms)
);


-- B38
CREATE TABLE census_2011.bcp_place_of_usual_residence_1_year_ago_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},
  sex census_2011.sex,
  previous_place_of_usual_residence census_2011.previous_place_of_usual_residence,

  different_usual_address_different_sa2_state_code asgs_2011.ste_code REFERENCES asgs_2011.ste(code),

  persons integer,

  PRIMARY KEY (asgs_code, sex, previous_place_of_usual_residence)
);

-- B39
CREATE TABLE census_2011.bcp_place_of_usual_residence_5_years_ago_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},
  sex census_2011.sex,
  previous_place_of_usual_residence census_2011.previous_place_of_usual_residence,

  different_usual_address_different_sa2_state_code asgs_2011.ste_code REFERENCES asgs_2011.ste(code),

  persons integer,

  PRIMARY KEY (asgs_code, sex, previous_place_of_usual_residence)
);

-- B40
CREATE TABLE census_2011.bcp_non_school_qualification_level_of_education_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},
  age text REFERENCES census_2011.age(range),
  sex census_2011.sex,
  non_school_level_of_education census_2011.non_school_level_of_education,

  persons_aged_15_years_and_over_with_a_qualification integer,

  PRIMARY KEY (asgs_code, age, sex, non_school_level_of_education)
);

-- B41
CREATE TABLE census_2011.bcp_non_school_qualification_field_of_study_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},
  age text REFERENCES census_2011.age(range),
  sex census_2011.sex,
  field_of_study census_2011.field_of_study,

  persons_aged_15_years_and_over_with_a_qualification integer,

  PRIMARY KEY (asgs_code, age, sex, field_of_study)
);

-- B42
CREATE TABLE census_2011.bcp_labour_force_status_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},
  age text REFERENCES census_2011.age(range),
  sex census_2011.sex,
  employment_status census_2011.employment_status,

  employed_persons_aged_15_years_and_over integer,

  PRIMARY KEY (asgs_code, age, sex, employment_status)
);

-- B43
CREATE TABLE census_2011.bcp_industry_of_employment_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},
  age text REFERENCES census_2011.age(range),
  sex census_2011.sex,
  industry census_2011.industry,

  employed_persons_aged_15_years_and_over integer,

  PRIMARY KEY (asgs_code, age, sex, industry)
);

-- B44
CREATE TABLE census_2011.bcp_industry_of_employment_by_occupation_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},
  industry census_2011.industry,
  occupation census_2011.occupation,

  employed_persons_aged_15_years_and_over integer,

  PRIMARY KEY (asgs_code, industry, occupation)
);

-- B45
CREATE TABLE census_2011.bcp_occupation_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},
  age text REFERENCES census_2011.age(range),
  sex census_2011.sex,
  occupation census_2011.occupation,

  employed_persons_aged_15_years_and_over integer,

  PRIMARY KEY (asgs_code, age, sex, occupation)
);

-- B46
CREATE TABLE census_2011.bcp_method_of_travel_to_work_{structure}
(
  asgs_code asgs_2011.{structure}_code REFERENCES asgs_2011.{structure},
  sex census_2011.sex,
  method_of_travel census_2011.method_of_travel,

  employed_persons_aged_15_years_and_over integer,

  PRIMARY KEY (asgs_code, sex, method_of_travel)
);
