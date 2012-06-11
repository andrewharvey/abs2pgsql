#!/usr/bin/perl -w

# This file is licensed CC0 by Andrew Harvey <andrew.harvey4@gmail.com>
#
# To the extent possible under law, the person who associated CC0
# with this work has waived all copyright and related or neighboring
# rights to this work.
# http://creativecommons.org/publicdomain/zero/1.0/

use strict;
use autodie;
use Text::CSV;

# We use two variables to store the contents of the metadata tables.
# They both sore the same content but we use the list to produce the
# .copy file to load the DataPack Metadata into a PostgreSQL table, and
# the hash so we can easily lookup values on a primary key of
# (DataPack file,Long)
my @metadata_contents_list;
my %metadata_contents;

# parse the source DataPack Metadata CSV files into a Perl structure
my $metadata_csv = Text::CSV->new( { sep_char => "\t" } );
$metadata_csv->column_names("Sequential", "Short", "Long", "DataPack file", "Profile table", "Column heading description in profile");

for my $profile (qw/BCP IP TSP/) {
  open (my $metadata_file, '<', "DataPack-Metadata/${profile}.tsv");

  # chew the header line
  $metadata_csv->getline($metadata_file);

  # for the rest of the lines
  while (my $row = $metadata_csv->getline_hr($metadata_file)) {
    my $line_as_hashref = {
        "profile" => $profile,
        "seq" => $row->{'Sequential'},
        "short" => $row->{'Short'},
        "long" => $row->{'Long'},
        "file" => $row->{'DataPack file'},
        "table" => $row->{'Profile table'},
        "column" => $row->{'Column heading description in profile'}
      };
    push @metadata_contents_list, $line_as_hashref;
    my ($short_datapack_file) = $row->{'DataPack file'} =~ /^(\w\d\d)/;
    my $key = $short_datapack_file . " " . lc($row->{'Long'});
    $metadata_contents{$key} = $line_as_hashref;
  }

  close $metadata_file;
}

# produce the .copy file used to load the metadata tables into PostgreSQL
open (my $metadata_copy, '>', "datapack-metadata.copy");

for my $item (@metadata_contents_list) {
  print $metadata_copy
    $item->{seq} . "\t" .
    $item->{short} . "\t" .
    $item->{long} . "\t" .
    $item->{file} . "\t" .
    $item->{table} . "\t" .
    $item->{column} . "\t" .
    $item->{profile} . "\n";
}

close $metadata_copy;


my %not_found_in_metadata;
my $line_count = 0;

# now read through an expanded load template as produced by 03-expand-template.pl
for my $line (<STDIN>) {
  chomp $line;
  # and unless it is a comment or empty line...
  unless (($line =~ /^#/) || ($line =~ /^\s*$/)) {
    $line_count++;

    # "parse" the schema translation definition
    if ($line =~ /^(\w\d+) ([^\s]+) ([^\s]+) (.*)$/) {
      my ($dataset_num, $long, $table, $insert) = ($1, $2, $3, $4);
      $insert =~ s/^\((.*)\)$/$1/;
      my @insert_values = split(/,/, $insert);

      my $metadata = $metadata_contents{$dataset_num . " " . lc($long)};

      # keep track of lines from the expanded load template which we couldn't find in the metadata table
      if (!defined $metadata) {
        $not_found_in_metadata{$dataset_num . " ". lc($long)} = '';
      }

      #print "Load " . $metadata->{'seq'} . " from " . $metadata->{'table'} . " into " . $table . " values\n";
      #print "asgs_code, " . $insert . ", value\n";
    }else{
      die "Map file line of unexpected format: $line\n";
    }
  }
}

# report out on problems
for my $i (sort keys %not_found_in_metadata) {
  print STDERR "Could not locate in metadata: \"$i\"\n";
}

if (scalar keys %not_found_in_metadata > 0) {
  print STDERR "\nTotal of " . scalar(keys(%not_found_in_metadata)) . " (out of " . $line_count . ") columns defined in template, but not found in\nmetadata file.\n";
}

