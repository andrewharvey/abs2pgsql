#!/usr/bin/perl -w

# This file is licensed CC0 by Andrew Harvey <andrew.harvey4@gmail.com>
#
# To the extent possible under law, the person who associated CC0
# with this work has waived all copyright and related or neighboring
# rights to this work.
# http://creativecommons.org/publicdomain/zero/1.0/

use strict;
use Text::CSV;
use DBI;

my %datapack_file;
my %datapack_seq;

# parse the source DataPack_Table2 CSV file into a Perl hash
my $datapack_csv = Text::CSV->new( { sep_char => "\t" } );
open (my $datapack_table2, '<', "data/BCP_DataPack_Table2.tsv") or die $!;
my $header = $datapack_csv->getline($datapack_table2);
$datapack_csv->column_names($header);
while (my $row = $datapack_csv->getline_hr($datapack_table2)) {
  $datapack_file{$row->{'Short'}} = $row->{'DataPack file'};
  $datapack_seq{$row->{'Short'}} = $row->{'Sequential'};
}
close $datapack_table2;

my %data_to_insert;

# open all source ABS files and save data into local Perl hash
#for my $structure ("mb sa1 sa2 sa3 sa4 gccsa state iloc iare ireg tr poa ssc ced sed add nrmr lga") {
for my $structure ("aust") {
  for my $age (0..79) {
    for my $sex ("M", "F") {
      my $short = "Age_yr_".$age."_".$sex;
      my $filename = $datapack_file{$short};
      my $col = $datapack_seq{$short};
      my $structure_uc = uc $structure;
      print "Short $short in ${filename}_${structure_uc}_sequential.csv col $col\n";

      open (my $datafile, '<', "./sample_bcp_datapacks/2011Sample_${filename}_${structure_uc}_sequential.csv") or die $!;
      my $seq_csv = Text::CSV->new();
      my $seq_header = $seq_csv->getline($datafile);
      $seq_csv->column_names($seq_header);
      while (my $seq_row = $seq_csv->getline_hr($datafile)) {
        my $region_id = $seq_row->{'region_id'};
        my $value = $seq_row->{$col};
        $data_to_insert{$structure}{$region_id}{$age}{$sex} = $value;
      }
      close $datafile;
    }
  }
}

# set up database connection
my $dbh = DBI->connect("DBI:Pg:", '', '' , {'RaiseError' => 1, AutoCommit => 0});
my $sth;

# now flush the local Perl hash of data into PostgreSQL
for my $structure (keys %data_to_insert) {
  for my $region_id (keys %{$data_to_insert{$structure}}) {
    for my $age (keys %{$data_to_insert{$structure}{$region_id}}) {
      for my $sex (keys %{$data_to_insert{$structure}{$region_id}{$age}}) {
        my $persons = $data_to_insert{$structure}{$region_id}{$age}{$sex};
        $sth = $dbh->prepare("INSERT INTO census_2011.bcp_population_$structure VALUES (?,?,?,?);");
        $sth->execute($region_id, $age, $sex, $persons) or die $!;
      }
    }
  }
  $dbh->commit or die $!;
}

$dbh->disconnect;
