--
-- # About
--
-- This file defines target PostgreSQL data types and reference tables
-- for the ABS Census 2011 Profile products. These definitions provide the
-- data model for the 7 DataPack Profiles.

--
-- # Census Dictionary
--
-- Although there is a 2011 Census Dictionary product which details
-- the official classifications of the raw data, I'm not aware of free
-- products released to this classification, rather Profiles are released
-- which use trimmed down versions of the classifications provided
-- in the Census Dictionary.
--
-- This schema DOES NOT load the Census Dictionary, that is provided by
-- a separate top level loader in this abs2pgsql repository. This schema
-- does however define parts of the dictionary, but only enough to
-- represent and link the data from the Profiles to the Census Dictionary.

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


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------


--
-- Census Dictionary, 2011 Classifications
--
-- http://www.abs.gov.au/ausstats/abs@.nsf/Lookup/2901.0Chapter99992011
--
-- Although we include parts of the data model of the Census Dictionary,
-- 2011 Classifications in this schema, the purpose is not to implement
-- the complete Census Dictionary in this schema. This can and should be
-- done in a separate schema. The only purpose of including parts here is
-- so that the tables from the profiles we load which make reference to
-- the dictionary can have such references represented using the same
-- codes so they can indeed reference the Census Dictionary schema.
--
-- tl dr; This is not a PostgreSQL Schema for the complete Census Dictionary
-- 2011 Classifications, it is merely providing just enough to reference a
-- separately loaded Census Dictionary.
--

-- "Arrays of domains are not yet supported." in PostgreSQL. Ideally
-- these would be declared as base types then where they are used the []
-- is added to make them arrays.

CREATE DOMAIN census_2011.dict_mstp AS char(1);
CREATE DOMAIN census_2011.dict_mdcp AS char(1);
CREATE DOMAIN census_2011.dict_ancp AS char(4)[];
CREATE DOMAIN census_2011.dict_bppp AS char(1);
CREATE DOMAIN census_2011.dict_bplp AS char(4);
CREATE DOMAIN census_2011.dict_englp AS char(1)[];
CREATE DOMAIN census_2011.dict_lanp AS char(4);
CREATE DOMAIN census_2011.dict_lanp_array AS char(4)[];
CREATE DOMAIN census_2011.dict_relp AS varchar(4)[];
CREATE DOMAIN census_2011.dict_typp AS char(2)[];
CREATE DOMAIN census_2011.dict_typp_i AS char(1)[];
CREATE DOMAIN census_2011.dict_stup AS char(1)[];
CREATE DOMAIN census_2011.dict_hscp AS char(1);
CREATE DOMAIN census_2011.dict_chcarep AS char(1);
CREATE DOMAIN census_2011.dict_tisp AS char(2);
CREATE DOMAIN census_2011.dict_fmcf AS varchar(4);
CREATE DOMAIN census_2011.dict_vehrd AS char(1);
CREATE DOMAIN census_2011.dict_strd_array AS char(2)[];
CREATE DOMAIN census_2011.dict_strd AS varchar(2);
CREATE DOMAIN census_2011.dict_tenlld AS char(1);
CREATE DOMAIN census_2011.dict_lldd AS char(2)[];
CREATE DOMAIN census_2011.dict_nedd AS char(1);
CREATE DOMAIN census_2011.dict_bedrd AS char(1);
CREATE DOMAIN census_2011.dict_qallp AS varchar(3)[];
CREATE DOMAIN census_2011.dict_qalfp AS varchar(6);
CREATE DOMAIN census_2011.dict_lfsp AS char(1);
CREATE DOMAIN census_2011.dict_lfsp_array AS char(1)[];
CREATE DOMAIN census_2011.dict_indp AS varchar(4)[];
CREATE DOMAIN census_2011.dict_occp AS varchar(4)[];
CREATE DOMAIN census_2011.dict_mtwp AS char(3);
CREATE DOMAIN census_2011.dict_ingp AS char(1);


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


CREATE TABLE census_2011.registered_marital_status
(
  id smallserial PRIMARY KEY,
  long text,
  mstp census_2011.dict_mstp
);

INSERT INTO census_2011.registered_marital_status (long, mstp) VALUES
('never_married', 1),
('widowed', 2),
('divorced', 3),
('separated', 4),
('married', 5);


CREATE TABLE census_2011.social_marital_status
(
  id smallserial PRIMARY KEY,
  long text,
  mdcp census_2011.dict_mdcp
);

INSERT INTO census_2011.social_marital_status (long, mdcp) VALUES
('married_in_a_registered_marriage', 1),
('married_in_a_de_facto_marriage', 2),
('not_married', 3);


CREATE TABLE census_2011.ancestry
(
  id smallserial PRIMARY KEY,
  long text,
  ancp census_2011.dict_ancp
);

INSERT INTO census_2011.ancestry (long, ancp) VALUES
('Australian', ARRAY[1101]),
('Australian_Aboriginal', ARRAY[1102]),
('Chinese', ARRAY[6101]),
('Croatian', ARRAY[3204]),
('Dutch', ARRAY[2303]),
('English', ARRAY[2101]),
('Filipino', ARRAY[5201]),
('French', ARRAY[2305]),
('German', ARRAY[2306]),
('Greek', ARRAY[3205]),
('Hungarian', ARRAY[3304]),
('Indian', ARRAY[7106]),
('Irish', ARRAY[2201]),
('Italian', ARRAY[3103]),
('Korean', ARRAY[6902]),
('Lebanese', ARRAY[4106]),
('Macedonian', ARRAY[3206]),
('Maltese', ARRAY[3104]),
('Maori', ARRAY[1201]),
('New_Zealander', ARRAY[1202]),
('Polish', ARRAY[3307]),
('Russian', ARRAY[3308]),
('Scottish', ARRAY[2102]),
('Serbian', ARRAY[3213]),
('Sinhalese', ARRAY[7115]),
('South_African', ARRAY[9215]),
('Spanish', ARRAY[3106]),
('Turkish', ARRAY[4907]),
('Vietnamese', ARRAY[5107]),
('Welsh', ARRAY[2103]),
('Other', NULL),
('Ancestry_not_stated', ARRAY['&&&&']);


CREATE TABLE census_2011.parent_birthplace_combination
(
  id smallserial PRIMARY KEY,
  long text,
  bppp census_2011.dict_bppp
);

INSERT INTO census_2011.parent_birthplace_combination (long, bppp) VALUES
('both_parents_born_overseas', '1'),
('father_only_born_overseas', '2'),
('mother_only_born_overseas', '3'),
('both_parents_born_in_australia', '4'),
('birthplace_not_stated', '&');


CREATE TABLE census_2011.birthplace
(
  id smallserial PRIMARY KEY,
  long text,
  bplp census_2011.dict_bplp
);

INSERT INTO census_2011.birthplace (long, bplp) VALUES
('Australia', 1101),
('Bosnia_and_Herzegovina', 3202),
('Cambodia', 5102),
('Canada', 8102),
('China_excl_SARs_and_Taiwan', 6101),
('Croatia', 3204),
('Egypt', 4102),
('Fiji', 1502),
('Former_Yugoslav_Republic_of_Macedonia_FYROM', 3206),
('Germany', 2304),
('Greece', 3207),
('Hong_Kong_SAR_of_China', 6102),
('India', 7103),
('Indonesia', 5202),
('Iraq', 4204),
('Ireland', 2201),
('Italy', 3104),
('Japan', 6201),
('Korea_Republic_of_South',6203),
('Lebanon', 4208),
('Malaysia', 5203),
('Malta', 3105),
('Netherlands', 2308),
('New_Zealand', 1201),
('Philippines', 5204),
('Poland', 3307),
('Singapore', 5205),
('South_Africa', 9925),
('South_Eastern_Europe_nfd', 3200),
('Sri_Lanka', 7107),
('Thailand', 5104),
('Turkey', 4215),
('United_Kingdom_Channel_Islands_and_Isle_of_Man', 2100),
('United_States_of_America', 8104),
('Vietnam', 5105),
('Born_elsewhere', NULL);


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
  id smallserial PRIMARY KEY,
  long text,
  englp census_2011.dict_englp
);

INSERT INTO census_2011.english_proficiency (long, englp) VALUES
('speaks_english_only', ARRAY[1]),
('speaks_other_language_and_speaks_english_very_well_or_well', ARRAY[2, 3]),
('speaks_other_language_and_speaks_english_not_well_or_not_at_all', ARRAY[4, 5]),
('speaks_other_language_and_speaks_english_proficiency_in_english_not_stated', ARRAY['&']); -- FIXME is this 6 or &


CREATE TABLE census_2011.language
(
  id smallserial PRIMARY KEY,
  long text,
  lanp census_2011.dict_lanp
);

INSERT INTO census_2011.language (long, lanp) VALUES
('english_only', 1201),
('arabic', 4202),
('assyrian', 4206),
('australian_indigenous_languages', 8000),
('chinese_languages_cantonese', 7101),
('chinese_languages_mandarin', 7104),
('chinese_languages_other', NULL),
('croatian', 3503),
('dutch', 1401),
('french', 2101),
('german', 1301),
('greek', 2201),
('hungarian', 3301),
('indo_aryan_languages_bengali', 5201),
('indo_aryan_languages_hindi', 5203),
('indo_aryan_languages_punjabi', 5207),
('indo_aryan_languages_sinhalese', 5211),
('indo_aryan_languages_urdu', 5212),
('indo_aryan_languages_other', NULL),
('iranic_languages_dari', 4105),
('iranic_languages_persian_excluding_dari', 4106),
('iranic_languages_other', NULL),
('italian', 2401),
('japanese', 7201),
('khmer', 6301),
('korean', 7301),
('macedonian', 3504),
('maltese', 2501),
('polish', 3602),
('portuguese', 2302),
('russian', 3402),
('samoan', 9308),
('serbian', 3505),
('southeast_asian_austronesian_languages_filipino', 6512),
('southeast_asian_austronesian_languages_indonesian', 6504),
('southeast_asian_austronesian_languages_tagalog', 6511),
('southeast_asian_austronesian_languages_other', NULL),
('spanish', 2303),
('tamil', 5103),
('thai', 6402),
('turkish', 4301),
('vietnamese', 6302),
('other', NULL),
('not_stated', '&&&&');


CREATE TABLE census_2011.language_tsp
(
  id smallserial PRIMARY KEY,
  long text,
  lanp census_2011.dict_lanp_array
);

INSERT INTO census_2011.language_tsp (long, lanp) VALUES
('english_only', ARRAY[1201]),
('arabic_includes_lebanese', ARRAY[4202]),
('assyrian', ARRAY[4206]),
('australian_indigenous_languages', ARRAY[8000]),
('chinese_languages_cantonese', ARRAY[7101]),
('chinese_languages_mandarin', ARRAY[7104]),
('chinese_languages_other', NULL),
('croatian', ARRAY[3503]),
('dutch', ARRAY[1401]),
('french', ARRAY[2101]),
('german', ARRAY[1301]),
('greek', ARRAY[2201]),
('hindi', ARRAY[3301]),
('indonesian', ARRAY[6504]),
('italian', ARRAY[2401]),
('japanese', ARRAY[7201]),
('khmer', ARRAY[6301]),
('korean', ARRAY[7301]),
('macedonian', ARRAY[3504]),
('maltese', ARRAY[2501]),
('persian_includes_dari', ARRAY[4105, 4106]),
('polish', ARRAY[3602]),
('portuguese', ARRAY[2302]),
('punjabi', ARRAY[5207]),
('russian', ARRAY[3402]),
('samoan', ARRAY[9308]),
('serbian', ARRAY[3505]),
('sinhalese', ARRAY[5211]),
('spanish', ARRAY[2303]),
('tagalog_includes_filipino', ARRAY[6511,6512]),
('tamil', ARRAY[5103]),
('thai', ARRAY[6402]),
('turkish', ARRAY[4301]),
('vietnamese', ARRAY[6302]),
('other', NULL),
('not_stated', ARRAY['&&&&']);


CREATE TABLE census_2011.religious_affiliation
(
  id smallserial PRIMARY KEY,
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
  id smallserial PRIMARY KEY,
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
  id smallserial PRIMARY KEY,
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


CREATE TABLE census_2011.school_year
(
  id smallserial PRIMARY KEY,
  long text,
  hscp census_2011.dict_hscp
);

INSERT INTO census_2011.school_year (long, hscp) VALUES
('year_12_or_equivalent', 1),
('year_11_or_equivalent', 2),
('year_10_or_equivalent', 3),
('year_9_or_equivalent', 4),
('year_8_or_below', 5),
('did_not_go_to_school',  6),
('highest_year_of_school_not_stated', '&');


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


CREATE TABLE census_2011.child_care
(
  id smallserial PRIMARY KEY,
  long text,
  chcarep census_2011.dict_chcarep
);

INSERT INTO census_2011.child_care (long, chcarep) VALUES
('cared_for_own_child_children_only', 2),
('cared_for_other_child_children_only', 3),
('cared_for_own_child_children_and_other_child_children', 4),
('did_not_provide_child_care', 1),
('unpaid_child_care_not_stated','&');


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


CREATE TABLE census_2011.number_of_children
(
  id smallserial PRIMARY KEY,
  long text,
  tisp census_2011.dict_tisp
);

INSERT INTO census_2011.number_of_children (long, tisp) VALUES
('no_children', '00'),
('one_child', '01'),
('two_children', '02'),
('three_children', '03'),
('four_children', '04'),
('five_children', '05'),
('six_or_more_children', NULL),
('not_stated', '&&');


CREATE TABLE census_2011.family_composition
(
  id smallserial PRIMARY KEY,
  long text,
  fmcf census_2011.dict_fmcf
);

INSERT INTO census_2011.family_composition (long, fmcf) VALUES
('couple_family_with_no_children', 1222),
('couple_family_with_children_under_15_and_dependent_students_and_non_dependent_children', 2111),
('couple_family_with_children_under_15_and_dependent_students_and_no_non_dependent_children', 2112),
('couple_family_with_children_under_15_and_no_dependent_students_and_non_dependent_children', 2121),
('couple_family_with_children_under_15_and_no_dependent_students_and_no_non_dependent_children', 2122),
('couple_family_with_no_children_under_15_and_dependent_students_and_non_dependent_children', 2211),
('couple_family_with_no_children_under_15_and_dependent_students_and_no_non_dependent_children', 2212),
('couple_family_with_no_children_under_15_and_no_dependent_students_and_non_dependent_children', 2221),
('one_parent_family_with_children_under_15_and_dependent_students_and_non_dependent_children', 3111),
('one_parent_family_with_children_under_15_and_dependent_students_and_no_non_dependent_children', 3112),
('one_parent_family_with_children_under_15_and_no_dependent_students_and_non_dependent_children', 3121),
('one_parent_family_with_children_under_15_and_no_dependent_students_and_no_non_dependent_children', 3122),
('one_parent_family_with_no_children_under_15_and_dependent_students_and_non_dependent_children', 3211),
('one_parent_family_with_no_children_under_15_and_dependent_students_and_no_non_dependent_children', 3212),
('one_parent_family_with_no_children_under_15_and_no_dependent_students_and_non_dependent_children', 3221),
('other_family', 9222);


CREATE TABLE census_2011.family_type
(
  id smallserial PRIMARY KEY,
  long text,
  fmcf census_2011.dict_fmcf
);

INSERT INTO census_2011.family_type (long, fmcf) VALUES
('couple_family_with_no_children', '1'),
('couple_family_with_children', '2'),
('one_parent_family', '3'),
('other_family', '9');


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


CREATE TABLE census_2011.number_of_motor_vehicles
(
  id smallserial PRIMARY KEY,
  long text,
  vehrd census_2011.dict_vehrd
);

INSERT INTO census_2011.number_of_motor_vehicles (long, vehrd) VALUES
('no_motor_vehicles', 0),
('one_motor_vehicle', 1),
('two_motor_vehicles', 2),
('three_motor_vehicles', 3),
('four_or_more_motor_vehicles', 4),
('not_stated', '&');


CREATE TYPE census_2011.number_of_persons_usually_resident AS ENUM (
  'one',
  'two',
  'three',
  'four',
  'five',
  'six_or_more'
);


CREATE TABLE census_2011.dwelling_structure_simple
(
  id smallserial PRIMARY KEY,
  long text,
  strd census_2011.dict_strd
);

INSERT INTO census_2011.dwelling_structure_simple (long, strd) VALUES
('separate_house', '1'),
('semi_detached_row_or_terrace_house_townhouse_etc', '2'),
('flat_unit_or_apartment', '3'),
('other_dwelling', '9'),
('not_stated', '&&');


CREATE TABLE census_2011.dwelling_structure_indigenous
(
  id smallserial PRIMARY KEY,
  long text,
  strd census_2011.dict_strd
);

INSERT INTO census_2011.dwelling_structure_indigenous (long, strd) VALUES
('separate_house', '1'),
('semi_detached_row_or_terrace_house_townhouse_etc', '2'),
('flat_unit_or_apartment', '3'),
('other_dwelling_caravan_cabin_houseboat', '91'),
('other_dwelling_improvised_home_tent_sleepers_out', '93'),
('other_dwelling_house_or_flat_attached_to_a_shop_office_etc', '94'),
('not_stated', '&&');


CREATE TABLE census_2011.dwelling_structure_extended_minimal
(
  id smallserial PRIMARY KEY,
  long text,
  strd census_2011.dict_strd_array
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
  id smallserial PRIMARY KEY,
  long text,
  strd census_2011.dict_strd_array
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


CREATE TABLE census_2011.tenure_landlord_type
(
  id smallserial PRIMARY KEY,
  long text,
  tenlld census_2011.dict_tenlld
);

INSERT INTO census_2011.tenure_landlord_type (long, tenlld) VALUES
('owned_outright', 1),
('owned_with_a_mortgage', 2),
('rented_real_estate_agent', 3),
('rented_state_or_territory_housing_authority', 4),
('rented_person_not_in_same_household', 5),
('rented_housing_co_operative_community_church_group', 6),
('rented_other_landlord_type', 7),
('rented_landlord_type_not_stated', 8),
('other_tenure_type', 9),
('tenure_type_not_stated', '&');


CREATE TABLE census_2011.landlord_type
(
  id smallserial PRIMARY KEY,
  long text,
  lldd census_2011.dict_lldd
);

INSERT INTO census_2011.landlord_type (long, lldd) VALUES
('real_estate_agent', ARRAY['10']),
('state_or_territory_housing_authority', ARRAY['20']),
('person_not_in_same_household', ARRAY['31', '32']),
('housing_co_operative_community_church_group', ARRAY['60']),
('other_landlord_type',ARRAY['40', '51', '52']),
('not_stated', ARRAY['&&']);


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


CREATE TABLE census_2011.internet_connection
(
  id smallserial PRIMARY KEY,
  long text,
  nedd census_2011.dict_nedd
);

INSERT INTO census_2011.internet_connection (long, nedd) VALUES
('none', 1),
('dial_up', 3),
('broadband', 2),
('other', 4),
('not_stated', '&');


CREATE TABLE census_2011.number_of_bedrooms
(
  id smallserial PRIMARY KEY,
  long text,
  bedrd census_2011.dict_bedrd
);

INSERT INTO census_2011.number_of_bedrooms (long, bedrd) VALUES
('zero', 0),
('one', 1),
('two', 2),
('three', 3),
('four', 4),
('five', 5),
('six_or_more', 6),
('not_stated', '&');


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


CREATE TABLE census_2011.non_school_level_of_education
(
  id smallserial PRIMARY KEY,
  long text,
  qallp census_2011.dict_qallp
);

INSERT INTO census_2011.non_school_level_of_education (long, qallp) VALUES
('postgraduate_degree_level', ARRAY['1']),
('graduate_diploma_and_graduate_certificate_level', ARRAY['2']),
('bachelor_degree_level', ARRAY['3']),
('advanced_diploma_and_diploma_level', ARRAY['4']),
('certificate_level_certificate_level_nfd', ARRAY['50']),
('certificate_level_certificate_iii_and_iv_level', ARRAY['51']),
('certificate_level_certificate_i_and_ii_level', ARRAY['52']),
('level_of_education_inadequately_described', ARRAY['011']),
('level_of_education_not_stated', ARRAY['&&&']);


CREATE TABLE census_2011.non_school_level_of_education_simple
(
  id smallserial PRIMARY KEY,
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


CREATE TABLE census_2011.field_of_study
(
  id smallserial PRIMARY KEY,
  long text,
  qalfp census_2011.dict_qalfp
);

INSERT INTO census_2011.field_of_study (long, qalfp) VALUES
('natural_and_physical_sciences', '01'),
('information_technology', '02'),
('engineering_and_related_technologies', '03'),
('architecture_and_building', '04'),
('agriculture_environmental_and_related_studies', '05'),
('health', '06'),
('education', '07'),
('management_and_commerce', '08'),
('society_and_culture', '09'),
('creative_arts', '10'),
('food_hospitality_and_personal_services', '11'),
('mixed_field_programmes', '12'),
('field_of_study_inadequately_described', '000110'),
('field_of_study_not_stated', '&&&&&&');


CREATE TABLE census_2011.employment_status
(
  id smallserial PRIMARY KEY,
  long text,
  lfsp census_2011.dict_lfsp
);

INSERT INTO census_2011.employment_status (long, lfsp) VALUES
('employed_worked_full_time', 1),
('employed_worked_part_time', 2),
('employed_away_from_work', 3),
('hours_worked_not_stated', NULL),-- FIXME double check
('unemployed_looking_for_full_time_work', 4),
('unemployed_looking_for_part_time_work', 5),
('not_in_the_labour_force', 6),
('labour_force_status_not_stated', '&');


CREATE TABLE census_2011.employment_status_simple
(
  id smallserial PRIMARY KEY,
  long text,
  lfsp census_2011.dict_lfsp_array
);

INSERT INTO census_2011.employment_status_simple (long, lfsp) VALUES
('employed_worked_full_time', ARRAY[1]),
('employed_worked_part_time', ARRAY[2]),
('employed_away_from_work', ARRAY[3]),
('unemployed', ARRAY[4, 5]),
('not_in_the_labour_force', ARRAY[6]),
('labour_force_status_not_stated', ARRAY['&']);


CREATE TABLE census_2011.industry
(
  id smallserial PRIMARY KEY,
  long text,
  indp census_2011.dict_indp
);

INSERT INTO census_2011.industry (long, indp) VALUES
('agriculture_forestry_and_fishing', ARRAY['A']),
('mining', ARRAY['B']),
('manufacturing', ARRAY['C']),
('electricity_gas_water_and_waste_services', ARRAY['D']),
('construction', ARRAY['E']),
('wholesale_trade', ARRAY['F']),
('retail_trade', ARRAY['G']),
('accommodation_and_food_services', ARRAY['H']),
('transport_postal_and_warehousing', ARRAY['I']),
('information_media_and_telecommunications', ARRAY['J']),
('financial_and_insurance_services', ARRAY['K']),
('rental_hiring_and_real_estate_services', ARRAY['L']),
('professional_scientific_and_technical_services', ARRAY['M']),
('administrative_and_support_services', ARRAY['N']),
('public_administration_and_safety', ARRAY['O']),
('education_and_training', ARRAY['P']),
('health_care_and_social_assistance', ARRAY['Q']),
('arts_and_recreation_services', ARRAY['R']),
('other_services', ARRAY['S']),
('inadequately_described_not_stated', ARRAY['T', '&&&&']);


CREATE TABLE census_2011.occupation
(
  id smallserial PRIMARY KEY,
  long text,
  occp census_2011.dict_occp
);

INSERT INTO census_2011.occupation (long, occp) VALUES
('managers', ARRAY['1']),
('professionals', ARRAY['2']),
('technicians_and_trades_workers', ARRAY['3']),
('community_and_personal_service_workers', ARRAY['4']),
('clerical_and_administrative_workers', ARRAY['5']),
('sales_workers', ARRAY['6']),
('machinery_operators_and_drivers', ARRAY['7']),
('labourers', ARRAY['8']),
('inadequately_described_not_stated', ARRAY['0998', '&&&&']);


CREATE TABLE census_2011.method_of_travel
(
  id smallserial PRIMARY KEY,
  long text,
  mtwp census_2011.dict_mtwp
);

INSERT INTO census_2011.method_of_travel (long, mtwp) VALUES
('one_method_train', '001'),
('one_method_bus', '002'),
('one_method_ferry', '003'),
('one_method_tram_includes_light_rail', '004'),
('one_method_taxi', '005'),
('one_method_car_as_driver', '006'),
('one_method_car_as_passenger', '007'),
('one_method_truck', '008'),
('one_method_motorbike_scooter', '009'),
('one_method_bicycle', '010'),
('one_method_other', '011'),
('one_method_walked_only', '232'),

('two_methods_train_and_bus', '012'),
('two_methods_train_and_ferry', '013'),
('two_methods_train_and_tram_includes_light_rail', '014'),
('two_methods_train_and_car_as_driver', '016'),
('two_methods_train_and_car_as_passenger', '017'),
('two_methods_train_and_other', '021'),
('two_methods_bus_and_ferry', '022'),
('two_methods_bus_and_tram_includes_light_rail', '023'),
('two_methods_bus_and_car_as_driver', '025'),
('two_methods_bus_and_car_as_passenger', '026'),
('two_methods_bus_and_other', '030'), -- FIXME 030 or 024,027,028,029,030 ?
('two_methods_other_two_methods', NULL),

('three_methods_train_and_two_other_methods', NULL),
('three_methods_bus_and_two_other_methods_excludes_train', NULL),
('three_methods_other_three_methods', NULL),

('worked_at_home', '233'),
('did_not_go_to_work', '234'),
('method_of_travel_to_work_not_stated', '&&&');


CREATE TABLE census_2011.indigenous_status
(
  id smallserial PRIMARY KEY,
  long text,
  ingp census_2011.dict_ingp
);

INSERT INTO census_2011.indigenous_status (long, ingp) VALUES
('indigenous_persons_aboriginal', 2),
('indigenous_persons_torres_strait_islander', 3),
('indigenous_persons_both_aboriginal_and_torres_strait_islander', 4),
('non_indigenous_persons', 1),
('indigenous_status_not_stated', '&');


CREATE TYPE census_2011.tsp_years AS ENUM (
  '2001',
  '2006',
  '2011'
);
