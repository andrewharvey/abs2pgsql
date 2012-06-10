-- table to store DataPack Profile Metadata
CREATE TABLE census_2011.datapack_metadata (
  sequential text PRIMARY KEY,
  short text,
  long text,
  datapack_file text,
  profile_table text,
  column_heading text,
  profile text
);
