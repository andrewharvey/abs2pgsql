--
-- # About
--
-- This file defines target PostgreSQL data types and reference tables
-- for the ABS Census 2011 products. These definitions provide the
-- classifications used by the various profiles which we load.

--
-- # Census Dictionary
--
-- Although there is a 2011 Census Dictionary product which details
-- the official classifications of the raw data, I'm not aware of free
-- products released to this classification, rather the profiles which
-- are released are trimed down versions of the classifications provided
-- in the Census Dictionary.

--
-- # Copyright
--
-- This file is licensed CC0 by Andrew Harvey <andrew.harvey4@gmail.com>
--
-- To the extent possible under law, the person who associated CC0
-- with this work has waived all copyright and related or neighboring
-- rights to this work.
-- http://creativecommons.org/publicdomain/zero/1.0/
--
-- This schema is partly derived from the ABS Census 2011 Datapack Samples,
-- which are Copyright Australian Bureau of Statistics (ABS) http://abs.gov.au/,
-- Commonwealth of Australia and licensed under the CC BY 2.5 AU license
-- http://creativecommons.org/licenses/by/2.5/au/ by the ABS.
-- The datapack samples were retrieved from http://www.abs.gov.au/websitedbs/censushome.nsf/home/datapackssample/$file/2011_BCP_AU_for_AUST_short-header.zip
--
-- This schema also contains data derived from the ABS Census Dictionary, 2011
-- (cat. no. 2901.0, released 23/05/2011) which is Copyright Australian Bureau
-- of Statistics (ABS) http://abs.gov.au/, Commonwealth of Australia and
-- licensed under the CC BY 2.5 AU license http://creativecommons.org/licenses/by/2.5/au/ by the ABS.
--
-- As per the statement at http://www.abs.gov.au/websitedbs/D3310114.nsf/Home/%C2%A9+Copyright?opendocument#from-banner=GB

--
-- # TODO
--
-- FIXME the serial types declared here can be updated to smallserial
-- this will create a dependence on PostgreSQL >= 9.2


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------


--
-- Census Dictionary, 2011 Classifications
--
-- http://www.abs.gov.au/ausstats/abs@.nsf/Lookup/2901.0Chapter99992011
--

-- "Arrays of domains are not yet supported." in PostgreSQL. Ideally
-- these would be declared as base types then where they are used the []
-- is added to make them arrays.

CREATE DOMAIN census_2011.dict_englp AS char(1)[];
CREATE DOMAIN census_2011.dict_relp AS varchar(4)[];
CREATE DOMAIN census_2011.dict_typp AS char(2)[];
CREATE DOMAIN census_2011.dict_typp_i AS char(1)[];
CREATE DOMAIN census_2011.dict_stup AS char(1)[];
CREATE DOMAIN census_2011.dict_strd AS char(2)[];
CREATE DOMAIN census_2011.dict_qallp AS varchar(3)[];

-- Originally I planned to just have min, max where the primary keys is
-- (min,max) and use max=NULL to indicate min or more however in
-- PostgreSQL the primary key cannot consist of a NULL value.
-- We need the table to have a primary key so it can be used as part of
-- the primary key of the tables which reference this age type.
-- If only I could make the max a union type of smallint | boolean and
-- only use the boolean for "or more" and the smallint otherwise, then I
-- could avoid using NULL and hence make it a primary key.
--
-- In lieu of this I use the text code as the primary key.
CREATE TABLE census_2011.age
(
  range text PRIMARY KEY,
  min smallint NOT NULL,
  max smallint -- use NULL to indicate "{min} years and over"
);


CREATE TYPE census_2011.sex AS ENUM (
  'male',
  'female'
);


-- generic Yes, No, Not_Stated type
CREATE TYPE census_2011.yes_no_notstated AS ENUM (
  'yes',
  'no',
  'not_stated'
);


CREATE TYPE census_2011.place_of_usual_residence AS ENUM (
  'counted_at_home',
  'visitor_from_same_sa2',
  'visitor_from_different_sa2_nsw',
  'visitor_from_different_sa2_vic',
  'visitor_from_different_sa2_qld',
  'visitor_from_different_sa2_sa',
  'visitor_from_different_sa2_wa',
  'visitor_from_different_sa2_tas',
  'visitor_from_different_sa2_nt',
  'visitor_from_different_sa2_act',
  'visitor_from_different_sa2_oth'
);


CREATE TYPE census_2011.registered_marital_status AS ENUM (
  'married',
  'separated',
  'divorced',
  'widowed',
  'never_married'
);


CREATE TYPE census_2011.social_marital_status AS ENUM (
  'married_in_a_registered_marriage',
  'married_in_a_de_facto_marriage',
  'not_married'
);


CREATE TYPE census_2011.ancestry AS ENUM (
  'Australian',
  'Australian_Aboriginal',
  'Chinese',
  'Croatian',
  'Dutch',
  'English',
  'Filipino',
  'French',
  'German',
  'Greek',
  'Hungarian',
  'Indian',
  'Irish',
  'Italian',
  'Korean',
  'Lebanese',
  'Macedonian',
  'Maltese',
  'Maori',
  'New_Zealander',
  'Polish',
  'Russian',
  'Scottish',
  'Serbian',
  'Sinhalese',
  'South_African',
  'Spanish',
  'Turkish',
  'Vietnamese',
  'Welsh',
  'Other',
  'Ancestry_not_stated'
);


CREATE TYPE census_2011.parent_birthplace_combination AS ENUM (
  'both_parents_born_overseas',
  'father_only_born_overseas',
  'mother_only_born_overseas',
  'both_parents_born_in_australia',
  'birthplace_not_stated'
);


CREATE TYPE census_2011.birthplace AS ENUM (
  'Australia',
  'Bosnia_and_Herzegovina',
  'Cambodia',
  'Canada',
  'China_excl_SARs_and_Taiwan',
  'Croatia',
  'Egypt',
  'Fiji',
  'Former_Yugoslav_Republic_of_Macedonia_FYROM',
  'Germany',
  'Greece',
  'Hong_Kong_SAR_of_China',
  'India',
  'Indonesia',
  'Iraq',
  'Ireland',
  'Italy',
  'Japan',
  'Korea_Republic_of_South',
  'Lebanon',
  'Malaysia',
  'Malta',
  'Netherlands',
  'New_Zealand',
  'Philippines',
  'Poland',
  'Singapore',
  'South_Africa',
  'South_Eastern_Europe_nfd',
  'Sri_Lanka',
  'Thailand',
  'Turkey',
  'United_Kingdom_Channel_Islands_and_Isle_of_Man',
  'United_States_of_America',
  'Vietnam',
  'Born_elsewhere'
);


CREATE TABLE census_2011.year_of_arrival
(
  id smallint PRIMARY KEY,
  min smallint,
  max smallint
);

INSERT INTO census_2011.year_of_arrival (id, min, max) VALUES
(0, NULL, 1940), -- Before 1941
(1, 1941, 1950),
(2, 1951, 1960),
(3, 1961, 1970),
(4, 1971, 1980),
(5, 1981, 1990),
(6, 1991, 2000),
(7, 2001, 2005),
(8, 2006, 2006),
(9, 2007, 2007),
(10, 2008, 2008),
(11, 2009, 2009),
(12, 2010, 2010),
(13, 2011, 2011),
(14, NULL, NULL); -- NotStated


CREATE TABLE census_2011.year_of_arrival_b
(
  id smallint PRIMARY KEY,
  min smallint,
  max smallint
);

INSERT INTO census_2011.year_of_arrival_b (id, min, max) VALUES
(0, NULL, 1995), -- Before 1996
(1, 1996, 2000),
(2, 2001, 2005),
(3, 2006, 2006),
(4, 2007, 2007),
(5, 2008, 2008),
(6, 2009, 2009),
(7, 2010, 2010),
(8, 2011, 2011),
(9, NULL, NULL); -- NotStated


CREATE TABLE census_2011.english_proficiency
(
  id serial PRIMARY KEY,
  long text,
  englp census_2011.dict_englp
);

INSERT INTO census_2011.english_proficiency (long, englp) VALUES
('speaks_english_only', ARRAY[1]),
('speaks_other_language_and_speaks_english_very_well_or_well', ARRAY[2, 3]),
('speaks_other_language_and_speaks_engilsh_not_well_or_not_at_all', ARRAY[4, 5]),
('speaks_other_language_and_speaks_engilsh_proficiency_in_english_not_stated', ARRAY['&']); -- FIXME is this 6 or &


CREATE TYPE census_2011.language AS ENUM (
  'english_only',
  'arabic',
  'assyrian',
  'australian_indigenous_languages',
  'chinese_languages_cantonese',
  'chinese_languages_mandarin',
  'chinese_languages_other',
  'croatian',
  'dutch',
  'french',
  'german',
  'greek',
  'hungarian',
  'indo_aryan_languages_bengali',
  'indo_aryan_languages_hindi',
  'indo_aryan_languages_punjabi',
  'indo_aryan_languages_sinhalese',
  'indo_aryan_languages_urdu',
  'indo_aryan_languages_other',
  'iranic_languages_dari',
  'iranic_languages_persian_excluding_dari',
  'iranic_languages_other',
  'italian',
  'japanese',
  'khmer',
  'korean',
  'macedonian',
  'maltese',
  'polish',
  'portuguese',
  'russian',
  'samoan',
  'serbian',
  'southeast_asian_austronesian_languages_filipino',
  'southeast_asian_austronesian_languages_indonesian',
  'southeast_asian_austronesian_languages_tagalog',
  'southeast_asian_austronesian_languages_other',
  'spanish',
  'tamil',
  'thai',
  'turkish',
  'vietnamese',
  'other',
  'not_stated'
);


CREATE TYPE census_2011.language_tsp AS ENUM (
  'english_only',
  'arabic_includes_lebanese',
  'assyrian',
  'australian_indigenous_languages',
  'chinese_languages_cantonese',
  'chinese_languages_mandarin',
  'chinese_languages_other',
  'croatian',
  'dutch',
  'french',
  'german',
  'greek',
  'hindi',
  'indonesian',
  'italian',
  'japanese',
  'khmer',
  'korean',
  'macedonian',
  'maltese',
  'persian_includes_dari',
  'polish',
  'portuguese',
  'punjabi',
  'russian',
  'samoan',
  'serbian',
  'sinhalese',
  'spanish',
  'tagalog_includes_filipino',
  'tamil',
  'thai',
  'turkish',
  'vietnamese',
  'other',
  'not_stated'
);


CREATE TABLE census_2011.religious_affiliation
(
  id serial PRIMARY KEY,
  long text,
  relp census_2011.dict_relp
);

INSERT INTO census_2011.religious_affiliation (long, relp) VALUES
('Buddhism', ARRAY[1]),
('Christianity_Anglican', ARRAY[201]),
('Christianity_Assyrian_Apostolic', ARRAY[222]),
('Christianity_Baptist', ARRAY[203]),
('Christianity_Brethren', ARRAY[205]),
('Christianity_Catholic', ARRAY[207]),
('Christianity_Churches_of_Christ', ARRAY[211]),
('Christianity_Eastern_Orthodox', ARRAY[223]),
('Christianity_Jehovahs_Witnesses', ARRAY[213]),
('Christianity_Latter_day_Saints', ARRAY[215]),
('Christianity_Lutheran', ARRAY[217]),
('Christianity_Oriental_Orthodox', ARRAY[221]),
('Christianity_Other_Protestant', ARRAY[28]),
('Christianity_Pentecostal', ARRAY[24]),
('Christianity_Presbyterian_and_Reformed', ARRAY[225]),
('Christianity_Salvation_Army', ARRAY[227]),
('Christianity_Seventh_day_Adventist', ARRAY[231]),
('Christianity_Uniting_Church', ARRAY[233]),
('Christianity_Christian_nfd', ARRAY[200]),
('Christianity_Other_Christian', ARRAY[29]),
('Hinduism', ARRAY[3]),
('Islam', ARRAY[4]),
('Judaism', ARRAY[5]),
('Other_Religions_Australian_Aboriginal_Traditional_Religions', ARRAY[601]),
('Other_Religions_Other_religious_groups', ARRAY[603, 605, 607, 611, 613, 615, 617, 699]),
('No_Religion', ARRAY[7]),
('Other_religious_affiliation', ARRAY['0002']), -- FIXME double check with ABS
('Religious_affiliation_not_stated', ARRAY['&&&&']);


-- TYPP
CREATE TABLE census_2011.educational_institution
(
  id serial PRIMARY KEY,
  long text,
  typp census_2011.dict_typp,
  stup census_2011.dict_stup,
  age text -- FIXME would like to use "REFERENCES census_2011.age(range)" but values haven't been loaded yet
           -- the fix is to split up the file, load the age table, fill it, then run the rest of these. but
           -- that is a significant architectural change for little benifit. since this problem won't occur
           -- when the age type is modified to use the range type from PostgreSQL 9.2 I think I'll just wait it out
);

INSERT INTO census_2011.educational_institution (long, typp, stup, age) VALUES
('pre_school', ARRAY[10], NULL, NULL),
('infants_primary_government', ARRAY[21], NULL, NULL),
('infants_primary_catholic', ARRAY[22], NULL, NULL),
('infants_primary_other_non_government', ARRAY[23], NULL, NULL),
('secondary_government', ARRAY[31], NULL, NULL),
('secondary_catholic', ARRAY[32], NULL, NULL),
('secondary_other_non_government', ARRAY[33], NULL, NULL),
('technical_or_further_educational_institution_full_time_student_aged_15_24_years', ARRAY[40], ARRAY[2], '15-24'),
('technical_or_further_educational_institution_full_time_student_aged_25_years_and_over', ARRAY[40], ARRAY[2], '25+'),
('technical_or_further_educational_institution_part_time_student_aged_15_24_years', ARRAY[40], ARRAY[3], '15-24'),
('technical_or_further_educational_institution_part_time_student_aged_25_years_and_over', ARRAY[40], ARRAY[3], '25+'),
('technical_or_further_educational_institution_full_part_time_student_status_not_stated', ARRAY[40], ARRAY[4], NULL),
('university_or_tertiary_institution_full_time_student_aged_15_24_years', ARRAY[50], ARRAY[2], '15-24'),
('university_or_tertiary_institution_full_time_student_aged_25_years_and_over', ARRAY[50], ARRAY[2], '25+'),
('university_or_tertiary_institution_part_time_student_aged_15_24_years', ARRAY[50], ARRAY[3], '15-24'),
('university_or_tertiary_institution_part_time_student_aged_25_years_and_over', ARRAY[50], ARRAY[3], '25+'),
('university_or_tertiary_institution_full_part_time_student_status_not_stated', ARRAY[50], ARRAY[4], NULL),
('other_type_of_educational_institution_full_time_student', ARRAY[60], ARRAY[2], NULL),
('other_type_of_educational_institution_part_time_student', ARRAY[60], ARRAY[3], NULL),
('other_type_of_educational_institution_full_part_time_student_status_not_stated', ARRAY[60], ARRAY[4], NULL);


CREATE TABLE census_2011.indigenous_educational_institution
(
  id serial PRIMARY KEY,
  long text,
  typp census_2011.dict_typp_i,
  stup census_2011.dict_stup,
  age text -- REFERENCES census_2011.age(range)
);

INSERT INTO census_2011.indigenous_educational_institution (long, typp, stup, age) VALUES
('pre_school', ARRAY[1], NULL, NULL),
('infants_primary', ARRAY[2], NULL, NULL),
('secondary', ARRAY[3], NULL, NULL),
('technical_or_further_educational_institution_full_time_student_aged_15_24_years', ARRAY[4], ARRAY[2], '15-24'),
('technical_or_further_educational_institution_full_time_student_aged_25_years_and_over', ARRAY[4], ARRAY[2], '25+'),
('technical_or_further_educational_institution_part_time_student_aged_15_24_years', ARRAY[4], ARRAY[3], '15-24'),
('technical_or_further_educational_institution_part_time_student_aged_25_years_and_over', ARRAY[4], ARRAY[3], '25+'),
('technical_or_further_educational_institution_full_part_time_student_status_not_stated', ARRAY[4], ARRAY[4], NULL),
('university_or_other_tertiary_institution_full_time_student_aged_15_24_years', ARRAY[5], ARRAY[2], '15-24'),
('university_or_other_tertiary_institution_full_time_student_aged_25_years_and_over', ARRAY[5], ARRAY[2], '25+'),
('university_or_other_tertiary_institution_part_time_student_aged_15_24_years', ARRAY[5], ARRAY[3], '15-24'),
('university_or_other_tertiary_institution_part_time_student_aged_25_years_and_over', ARRAY[5], ARRAY[3], '25+'),
('university_or_other_tertiary_institution_full_part_time_student_status_not_stated', ARRAY[5], ARRAY[4], NULL),
('other_type_of_educational_institution', ARRAY[6], NULL, NULL),
('type_of_educational_institution_not_stated', ARRAY['&'], NULL, NULL);


CREATE TYPE census_2011.school_year AS ENUM (
  'year_12_or_equivalent',
  'year_11_or_equivalent',
  'year_10_or_equivalent',
  'year_9_or_equivalent',
  'year_8_or_below',
  'did_not_go_to_school',
  'highest_year_of_school_not_stated'
);


CREATE TABLE census_2011.income_band
(
  code smallint PRIMARY KEY,
  min smallint,
  max smallint
);

INSERT INTO census_2011.income_band (code, min, max) VALUES
(0, 0, 0), -- NegativeNil
(1, 1, 199),
(2, 200, 299),
(3, 300, 399),
(4, 400, 599),
(5, 600, 799),
(6, 800, 999),
(7, 1000, 1249),
(8, 1250, 1499),
(9, 1500, 1999),
(10, 2000, NULL), --2000+
(11, NULL, NULL); -- NotStated


CREATE TABLE census_2011.indigenous_income_band
(
  code smallint PRIMARY KEY,
  min smallint,
  max smallint
);

INSERT INTO census_2011.indigenous_income_band (code, min, max) VALUES
(0, 0, 0), -- NegativeNil
(1, 1, 199),
(2, 200, 299),
(3, 300, 399),
(4, 400, 599),
(5, 600, 799),
(6, 800, 999),
(7, 1000, NULL), --1000+
(8, NULL, NULL); -- NotStated


CREATE TABLE census_2011.unpaid_domestic_work
(
  code smallint PRIMARY KEY,
  min smallint,
  max smallint
);

INSERT INTO census_2011.unpaid_domestic_work (code, min, max) VALUES
(0, 0, 0), 
(1, 1, 4),
(2, 5, 14),
(3, 15, 29),
(4, 30, NULL),
(5, NULL, NULL); -- not_stated


CREATE TYPE census_2011.child_care AS ENUM (
  'cared_for_own_child_children_only',
  'cared_for_other_child_children_only',
  'cared_for_own_child_children_and_other_child_children',
  'did_not_provide_child_care',
  'unpaid_child_care_not_stated'
);


CREATE TYPE census_2011.household_relationship AS ENUM (
  'husband_in_a_registered_marriage',
  'wife_in_a_registered_marriage',
  'partner_in_de_facto_marriage',
  'lone_parent',
  'child_under_15',
  'dependent_student_aged_15_24_years',
  'non_dependent_child',
  'other_related_individual',
  'unrelated_individual_living_in_family_household',
  'group_household_member',
  'lone_person',
  'visitor_from_within_australia'
);


CREATE TYPE census_2011.number_of_children AS ENUM (
  'no_children',
  'one_child',
  'two_children',
  'three_children',
  'four_children',
  'five_children',
  'six_or_more_children',
  'not_stated'
);


CREATE TYPE census_2011.family_type AS ENUM (
  'couple_family_with_no_children',
  'couple_family_with_children',
  'one_parent_family',
  'other_family'
);


CREATE TYPE census_2011.household_type AS ENUM (
  'one_family_households_couple_family_with_no_children',
  'one_family_households_couple_family_with_children',
  'one_family_households_one_parent_family',
  'one_family_households_other_family',
  'multiple_family_households',
  'lone_person_households',
  'group_households' --FIXME sometimes need s on end sometimes not
);

CREATE TYPE census_2011.household_type_simple AS ENUM (
  'family_households',
  'lone_person_household',
  'group_household',
  'other_household'
);


CREATE TYPE census_2011.blended_family_type AS ENUM (
  'intact',
  'step',
  'blended'
);


CREATE TABLE census_2011.family_income_band
(
  code smallint PRIMARY KEY,
  min smallint,
  max smallint
);

INSERT INTO census_2011.family_income_band (code, min, max) VALUES
(0, 0, 0), -- NegativeNil
(1, 1, 199),
(2, 200, 299),
(3, 300, 399),
(4, 400, 599),
(5, 600, 799),
(6, 800, 999),
(7, 1000, 1249),
(8, 1250, 1499),
(9, 1500, 1999),
(10, 2000, 2499),
(11, 2500, 2999),
(12, 3000, 3499),
(13, 3500, 3999),
(14, 4000, NULL), -- 4000+
(15, NULL, NULL), -- Partial_income_stated
(16, NULL, NULL); -- All_incomes_not_stated


CREATE TABLE census_2011.indigenous_household_income_band
(
  code smallint PRIMARY KEY,
  min smallint,
  max smallint
);

INSERT INTO census_2011.indigenous_household_income_band (code, min, max) VALUES
(0, 0, 0), -- NegativeNil
(1, 1, 199),
(2, 200, 299),
(3, 300, 399),
(4, 400, 599),
(5, 600, 799),
(6, 800, 999),
(7, 1000, 1249),
(8, 1250, 1499),
(9, 1500, 1999),
(10, 2000, 2499),
(11, 2500, 2999),
(12, 3000, NULL), -- 3000+
(13, NULL, NULL), -- Partial_income_stated
(14, NULL, NULL); -- All_incomes_not_stated


CREATE TYPE census_2011.number_of_motor_vehicles AS ENUM (
  'no_motor_vehicles',
  'one_motor_vehicle',
  'two_motor_vehicles',
  'three_motor_vehicles',
  'four_or_more_motor_vehicles',
  'not_stated'
);


CREATE TYPE census_2011.number_of_persons_usually_resident AS ENUM (
  'one',
  'two',
  'three',
  'four',
  'five',
  'six_or_more'
);


CREATE TYPE census_2011.dwelling_structure_simple AS ENUM (
  'separate_house',
  'semi_detached_row_or_terrace_house_townhouse_etc',
  'flat_unit_or_apartment',
  'other_dwelling',
  'not_stated'
);


CREATE TYPE census_2011.dwelling_structure_indigenous AS ENUM (
  'separate_house',
  'semi_detached_row_or_terrace_house_townhouse_etc',
  'flat_unit_or_apartment',
  'other_dwelling_caravan_cabin_houseboat',
  'other_dwelling_improvised_home_tent_sleepers_out',
  'other_dwelling_house_or_flat_attached_to_a_shop_office_etc',
  'not_stated'
);


CREATE TABLE census_2011.dwelling_structure_extended_minimal
(
  id serial PRIMARY KEY,
  long text,
  strd census_2011.dict_strd
);

INSERT INTO census_2011.dwelling_structure_extended_minimal (long, strd) VALUES
('separate_house', ARRAY[11]),
('semi_detached_row_or_terrace_house_townhouse_etc_with_one_storey', ARRAY[21]),
('semi_detached_row_or_terrace_house_townhouse_etc_with_two_or_more_storeys', ARRAY[22]),
('flat_unit_or_apartment_in_a_one_or_two_storey_block', ARRAY[31]),
('flat_unit_or_apartment_in_a_three_storey_block', ARRAY[32]),
('flat_unit_or_apartment_in_a_four_storey_or_more_block', ARRAY[33]),
('flat_unit_or_apartment_attached_to_a_house', ARRAY[34]),
('other_dwelling', ARRAY[91, 93, 94]),
('dwelling_structure_not_stated', ARRAY['&&']);


CREATE TABLE census_2011.dwelling_structure_extended_full
(
  id serial PRIMARY KEY,
  long text,
  strd census_2011.dict_strd
);

INSERT INTO census_2011.dwelling_structure_extended_full (long, strd) VALUES
('separate_house', ARRAY[11]),
('semi_detached_row_or_terrace_house_townhouse_etc_with_one_storey', ARRAY[21]),
('semi_detached_row_or_terrace_house_townhouse_etc_with_two_or_more_storeys', ARRAY[22]),
('flat_unit_or_apartment_in_a_one_or_two_storey_block', ARRAY[31]),
('flat_unit_or_apartment_in_a_three_storey_block', ARRAY[32]),
('flat_unit_or_apartment_in_a_four_storey_or_more_block', ARRAY[33]),
('flat_unit_or_apartment_attached_to_a_house', ARRAY[34]),
('other_dwelling_caravan_cabin_houseboat', ARRAY[91]),
('other_dwelling_improvised_home_tent_sleepers_out', ARRAY[93]),
('other_dwelling_house_or_flat_attached_to_a_shop_office_etc', ARRAY[94]),
('dwelling_structure_not_stated', ARRAY['&&']),
('unoccupied', ARRAY['@@']); -- FIXME doublecheck


CREATE TYPE census_2011.tenure_landlord_type AS ENUM (
  'owned_outright',
  'owned_with_a_mortgage',
  'rented_real_estate_agent',
  'rented_state_or_territory_housing_authority',
  'rented_person_not_in_same_household',
  'rented_housing_co_operative_community_church_group',
  'rented_other_landlord_type',
  'rented_landlord_type_not_stated',
  'other_tenure_type',
  'tenure_type_not_stated'
);


CREATE TYPE census_2011.landlord_type AS ENUM (
  'real_estate_agent',
  'state_or_territory_housing_authority',
  'person_not_in_same_household',
  'housing_co_operative_community_church_group',
  'other_landlord_type',
  'not_stated'
);


CREATE TABLE census_2011.rental_payment_band
(
  code smallint PRIMARY KEY,
  min smallint,
  max smallint
);

INSERT INTO census_2011.rental_payment_band (code, min, max) VALUES
(0, 0, 74),
(1, 75, 99),
(2, 100, 149),
(3, 150, 199),
(4, 200, 224),
(5, 225, 274),
(6, 275, 349),
(7, 350, 449),
(8, 450, 549),
(9, 550, 649),
(10, 650, NULL), --650+
(11, NULL, NULL); -- NotStated


CREATE TABLE census_2011.mortgage_repayment_band
(
  code smallint PRIMARY KEY,
  min smallint,
  max smallint
);

INSERT INTO census_2011.mortgage_repayment_band (code, min, max) VALUES
(0, 0, 299),
(1, 300, 449),
(2, 450, 599),
(3, 600, 799),
(4, 800, 999),
(5, 1000, 1399),
(6, 1400, 1799),
(7, 1800, 2399),
(8, 2400, 2999),
(9, 3000, 3999),
(10, 4000, NULL), --4000+
(11, NULL, NULL); -- NotStated


CREATE TYPE census_2011.internet_connection AS ENUM (
  'none',
  'dial_up',
  'broadband',
  'other',
  'not_stated'
);


CREATE TYPE census_2011.number_of_bedrooms AS ENUM (
  'zero',
  'one',
  'two',
  'three',
  'four',
  'five',
  'six_or_more',
  'not_stated'
);


CREATE TYPE census_2011.previous_place_of_usual_residence AS ENUM (
  'same_usual_address',
  'different_usual_address_same_sa2',
  'different_usual_address_different_sa2_nsw',
  'different_usual_address_different_sa2_vic',
  'different_usual_address_different_sa2_qld',
  'different_usual_address_different_sa2_sa',
  'different_usual_address_different_sa2_wa',
  'different_usual_address_different_sa2_tas',
  'different_usual_address_different_sa2_nt',
  'different_usual_address_different_sa2_act',
  'different_usual_address_different_sa2_oth',
  'different_usual_address_overseas',
  'different_usual_address_not_stated'
);


CREATE TYPE census_2011.non_school_level_of_education AS ENUM (
  'postgraduate_degree_level',
  'graduate_diploma_and_graduate_certificate_level',
  'bachelor_degree_level',
  'advanced_diploma_and_diploma_level',
  'certificate_level_certificate_level_nfd',
  'certificate_level_certificate_iii_and_iv_level',
  'certificate_level_certificate_i_and_ii_level',
  'level_of_education_inadequately_described',
  'level_of_education_not_stated'
);


CREATE TABLE census_2011.non_school_level_of_education_simple
(
  id serial PRIMARY KEY,
  long text,
  qallp census_2011.dict_qallp
);

INSERT INTO census_2011.non_school_level_of_education_simple (long, qallp) VALUES
('postgraduate_degree_graduate_diploma_and_graduate_certificate_level', ARRAY['1', '2']),
('bachelor_degree_level', ARRAY['3']),
('advanced_diploma_and_diploma_level', ARRAY['4']),
('certificate_level_nfd', ARRAY['50']),
('certificate_iii_and_iv_level', ARRAY['51']),
('certificate_i_and_ii_level', ARRAY['52']),
('level_of_education_not_stated', ARRAY['&&&']);


CREATE TYPE census_2011.field_of_study AS ENUM (
  'natural_and_physical_sciences',
  'information_technology',
  'engineering_and_related_technologies',
  'architecture_and_building',
  'agriculture_environmental_and_related_studies',
  'health',
  'education',
  'management_and_commerce',
  'society_and_culture',
  'creative_arts',
  'food_hospitality_and_personal_services',
  'mixed_field_programmes',
  'field_of_study_inadequately_described',
  'field_of_study_not_stated'
);


CREATE TYPE census_2011.employment_status AS ENUM (
  'employed_worked_full_time',
  'employed_worked_part_time',
  'employed_away_from_work',
  'hours_worked_not_stated',
  'unemployed_looking_for_full_time_work',
  'unemployed_looking_for_part_time_work',
  'not_in_the_labour_force',
  'labour_force_status_not_stated'
);


CREATE TYPE census_2011.employment_status_simple AS ENUM (
  'employed_worked_full_time',
  'employed_worked_part_time',
  'employed_away_from_work',
  'unemployed',
  'not_in_the_labour_force',
  'labour_force_status_not_stated'
);


CREATE TYPE census_2011.industry AS ENUM (
  'agriculture_forestry_and_fishing',
  'mining',
  'manufacturing',
  'electricity_gas_water_and_waste_services',
  'construction',
  'wholesale_trade',
  'retail_trade',
  'accommodation_and_food_services',
  'transport_postal_and_warehousing',
  'information_media_and_telecommunications',
  'financial_and_insurance_services',
  'rental_hiring_and_real_estate_services',
  'professional_scientific_and_technical_services',
  'administrative_and_support_services',
  'public_administration_and_safety',
  'education_and_training',
  'health_care_and_social_assistance',
  'arts_and_recreation_services',
  'other_services',
  'inadequately_described_not_stated'
);


CREATE TYPE census_2011.occupation AS ENUM (
  'managers',
  'professionals',
  'technicians_and_trades_workers',
  'community_and_personal_service_workers',
  'clerical_and_administrative_workers',
  'sales_workers',
  'machinery_operators_and_drivers',
  'labourers',
  'inadequately_described_not_stated'
);


CREATE TYPE census_2011.method_of_travel AS ENUM (
  'one_method_train',
  'one_method_bus',
  'one_method_ferry',
  'one_method_tram_includes_light_rail',
  'one_method_taxi',
  'one_method_car_as_driver',
  'one_method_car_as_passenger',
  'one_method_truck',
  'one_method_motorbike_scooter',
  'one_method_bicycle',
  'one_method_other',
  'one_method_walked_only',

  'two_methods_train_and_bus',
  'two_methods_train_and_ferry',
  'two_methods_train_and_tram_includes_light_rail',
  'two_methods_train_and_car_as_driver',
  'two_methods_train_and_car_as_passenger',
  'two_methods_train_and_other',
  'two_methods_bus_and_ferry',
  'two_methods_bus_and_tram_includes_light_rail',
  'two_methods_bus_and_car_as_driver',
  'two_methods_bus_and_car_as_passenger',
  'two_methods_bus_and_other',
  'two_methods_other_two_methods',

  'three_methods_train_and_two_other_methods',
  'three_methods_bus_and_two_other_methods_excludes_train',
  'three_methods_other_three_methods',

  'worked_at_home',
  'did_not_go_to_work',
  'method_of_travel_to_work_not_stated'
);


CREATE TYPE census_2011.indigenous_status AS ENUM (
  'indigenous_persons_aboriginal',
  'indigenous_persons_torres_strait_islander',
  'indigenous_persons_both_aboriginal_and_torres_strait_islander',
  'non_indigenous_persons',
  'indigenous_status_not_stated'
);


CREATE TYPE census_2011.tsp_years AS ENUM (
  '2001',
  '2006',
  '2011'
);
