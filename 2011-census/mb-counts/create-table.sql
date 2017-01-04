CREATE TABLE census_2011.mb_counts
(
    "code" asgs.mb_code PRIMARY KEY REFERENCES asgs_2011.mb(code),
    "dwellings" integer,
    "persons_usually_resident" integer
);
