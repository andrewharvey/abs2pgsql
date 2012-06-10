#!/usr/bin/perl -w

# This file is licensed CC0 by Andrew Harvey <andrew.harvey4@gmail.com>
#
# To the extent possible under law, the person who associated CC0
# with this work has waived all copyright and related or neighboring
# rights to this work.
# http://creativecommons.org/publicdomain/zero/1.0/

# Given a file defining the mapping of fields into the target PostgreSQL
# schema, prepare the load.

# ./map-expansion.pl < short_name2target.map > short_name2target_expanded.map

use strict;

# We need DBI to access PostgreSQL to retrieve values from ENUM's.
use DBI;

# declare functions
sub insert ($$$$);
sub matchRange ($$);
sub expand($$$$$);

# prepare db handle for future requests
my $dbh = DBI->connect("DBI:Pg:", '', '' , {'RaiseError' => 0, AutoCommit => 0});
my $sth;

# used to read in file defining 
use Text::CSV;

# these are used in the expansions hardcode
my @time_series_population_ages_source = (0..79);
push @time_series_population_ages_source, ('80_84', '85_years_and_over');

my @time_series_population_ages_target = (0..80);
push @time_series_population_ages_target, (85);

my @population_ages_source = (0..79);
push @population_ages_source, ('80_84', '85_89', '90_94', '95_99', '100_years_and_over');

my @population_ages_target = (0..80);
push @population_ages_target, (85, 90, 95, 100);

my @indigenous_population_ages_source = (0..24);
push @indigenous_population_ages_source, ('25_29', '30_34', '35_39', '40_44', '45_49', '50_54', '55_59', '60_64', '65_years_and_over');

my @indigenous_population_ages_target = (0..25);
push @indigenous_population_ages_target, (30, 35, 40, 45, 50, 55, 60, 65);


# hard code the [:foo:] expansions
# format is foo => [[long name values list],[target insert values list][
my %expansions = (
  sex => [
      [qw/Males Females/],
      [qw/true false/]
    ],
  pop_ages => [
      \@population_ages_source,
      \@population_ages_target
    ],
  ages_a => [
      [qw/15_19_years 20_24_years 25_34_years 35_44_years 45_54_years 55_64_years 64_74_years 75_84_years 85_years_and_over/],
      [qw/15 20 25 35 45 55 65 75 85/]
    ],
  ages_b => [
      [qw/0_14_years 15_24_years 25_34_years 35_44_years 45_54_years 55_64_years 65_74_years 75_84_years 85_years_and_over/],
      [qw/0 15 25 35 45 55 65 75 85/]
    ],
  ages_c => [
      [qw/0_4_years 5_14_years 15_19_years 20_24_years 25_34_years 35_44_years 45_54_years 55_64_years 64_74_years 75_84_years 85_years_and_over/], 
      [qw/0 5 15 20 25 35 45 55 65 75 85/]
    ],
  ages_d => [
      [qw/15_19_years 20_24_years 25_29_years 30_34_years 35_39_years 40_44_years 45_49_years 50_54_years 55_59_years 60_64_years 65_69_years 70_74_years 75_79_years 80_84_years 85_years_and_over/],
      [qw/15 20 25 30 35 40 45 50 55 60 64 70 75 80 85/]
    ],
  ages_e => [
      [qw/0_4_years 5_9_years 10_14_years 15_19_years 20_24_years 25_29_years 30_34_years 35_39_years 40_44_years 45_49_years 50_54_years 55_59_years 60_64_years 65_years_and_over/],
      [qw/0 5 10 15 20 25 30 35 40 45 50 55 60 65/]
    ],
  ages_f => [
      [qw/0_4_years 5_14_years 15_19_years 20_24_years 25_34_years 35_44_years 45_54_years 55_64_years 65_years_and_over/],
      [qw/0 5 15 20 25 35 45 55 65/]
    ],
  ages_g => [
      [qw/15_19_years 20_24_years 25_34_years 35_44_years 45_54_years 55_64_years 65_years_and_over/],
      [qw/15 20 25 35 45 55 65/]
    ],
  income_band => [
      [qw/Negative_Nil_income 1_199 200_299 300_399 400_599 600_799 800_999 1000_1249 1250_1499 1500_1999 2000_or_more Personal_income_not_stated/],
      [0..11]
    ],
  family_income_band => [
      [qw/Negative_Nil_income 1_199 200_299 300_399 400_599 600_799 800_999 1000_1249 1250_1499 1500_1999 2000_2499 2500_2999 3000_3499 3500_3999 4000_or_more Partial_income_stated All_incomes_not_stated/],
      [0..16]
    ],
  rental_payment_band => [
      [qw/0_74 75_99 100_149 150_199 200_224 255_274 275_349 350_449 450_549 550_649 650_and_over Rent_not_stated/],
      [0..11]
    ],
  bedrooms => [
      [qw/None_includes_bedsitters One_bedroom Two_bedrooms Three_bedrooms Four_bedrooms Five_bedrooms Six_or_more_bedrooms Not_stated/],
      [qw/zero one two three four five six_or_more not_stated/]
    ],
  internet_connection => [
      [qw/No_Internet_connection Type_of_Internet_connection_Broadband Type_of_Internet_connection_Dial_up Type_of_Internet_connection_Other Internet_connection_not_stated/],
      [qw/none broadband dial_up other not_stated/]
    ],
  indigenous_population_ages => [
      \@indigenous_population_ages_source,
      \@indigenous_population_ages_target
    ],
  indigenous_income_band => [
      [qw/Negative_Nil_income 1_199 200_299 300_399 400_599 600_799 800_999 1000_or_more Personal_income_not_stated/],
      [0..8]
    ],
  indigenous_household_income => [
      [qw/Negative_Nil_income 1_199 200_299 300_399 400_599 600_799 800_999 1000_1249 1250_1499 1500_1999 2000_2499 2500_2999 3000_or_more Partial_income_stated All_incomes_not_stated/],
      [0..14]
    ],
  time_series_population_ages => [
      \@time_series_population_ages_source,
      \@time_series_population_ages_target
    ]
);

# read in every line of our schema map definion file
while (<>) {
  chomp;
  # and unless it is a comment or empty line...
  unless ((/^#/) || (/^\s*$/)) {
    # "parse" the schema translation definition
    my ($dataset_num, $src_template, $dst_template, $table_orders) =
      /^(\w\d+) ([^\s]+) ([^\s]+) (.*)$/;
    $table_orders =~ s/^\((.*)\)$/$1/;
    my @insert_values = split(/,/, $table_orders);
    # ... and expand it out
    insert ($dataset_num, $src_template, $dst_template, \@insert_values);
    print "\n";
  }
}

$dbh->disconnect;

# take a template line and expand it out
sub insert ($$$$) {
  my ($dataset_num, $src, $dst, $inserts) = @_;

  # replace all [:foo:]'s
  for my $expansion_key (keys %expansions) {
    if (rangeMatch($src, $expansion_key)) {
      for my $new ( expand($src, $expansion_key, $inserts, @{$expansions{$expansion_key}}[0], @{$expansions{$expansion_key}}[1]) ) {
        insert ($dataset_num, $new->{'src'}, $dst, $new->{'inserts'});
      }
      return;
    }
  }

  # replace all ynn
  if (curlyMatch($src, 'ynn')) {
    my ($yes, $no, $not_stated) = $src =~ /{ynn:([^|]*)\|([^|]*)\|([^}]*)}/;
    for my $new ( expand($src, 'ynn', $inserts, [$yes, $no, $not_stated], ['yes', 'no', 'not_stated']) ) {
      insert ($dataset_num, $new->{'src'}, $dst, $new->{'inserts'});
    }
    return;
  }

  # replace all tf
  if (curlyMatch($src, 'tf')) {
    my $a;
    my $true;
    my $false;
    if ($src =~ /{(tf):([^|]*)\|([^}]*)}/) {
      $a = $1;
      $true = $2;
      $false = $3;
    }elsif ($src =~ /{(tf_\d+):([^|]*)\|([^}]*)}/) {
      $a = $1;
      $true = $2;
      $false = $3;
    }else{
      die "Unexpected tf syntax\n";
    }
    for my $new ( expand($src, $a, $inserts, [$true, $false], ['true', 'false']) ) {
      insert ($dataset_num, $new->{'src'}, $dst, $new->{'inserts'});
    }
    return;
  }

  # replace all db lookups
  if (curlyMatch($src, 'db')) {
    my ($lookup) = $src =~ /{db:([^}]*)}/;
    my $enum_as_hashref = pgenum2arrayref($lookup);
    for my $new ( expand($src, "db:$lookup", $inserts, $enum_as_hashref, $enum_as_hashref) ) {
      insert ($dataset_num, $new->{'src'}, $dst, $new->{'inserts'});
    }
    return;
  }

  print "$dataset_num $src $dst (".join(',', @{$inserts}).")\n";
}

# look for a [:foo:] template to expand
sub rangeMatch($$) {
  my ($text, $foo) = @_;
  return $text =~ /\[\:$foo\:\]/;
}

# look for a {foo:bar1|bar2|...|barN} template to expand with optional foo_N
sub curlyMatch($$) {
  my ($text, $foo) = @_;
  return $text =~ /\{$foo(_\d+)?\:[^}]*\}/;
}

# arguments:
#   src = Age_years_80_84_[:sex:]
#   a = sex
#   inserts = (1, true, \sex)
#   adash = \(Males, Females) # source table replacements
#   bdash = \(true, false) # insert values
# returns:
#   list of hashes with (new_src, bdash)
sub expand($$$$$) {
  my ($src, $a, $inserts, $adash, $bdash) = @_;
  my @results;
  #die "adash and bdash of different length" unless (length @$adash eq length @$bdash)
  for (my $i = 0; $i < scalar @{$adash}; $i++) {
    my $adash_at_index = $adash->[$i];
    my $bdash_at_index = $bdash->[$i];
    my $new_src = $src;
    if ($a =~ /^db\:/) {
      $new_src =~ s/\{$a\}/$adash_at_index/;
    }elsif ($a =~ /(^ynn)|(^tf)/) {
      $new_src =~ s/\{$a[^}]*\}/$adash_at_index/;
    }else{
      $new_src =~ s/\[\:$a\:\]/$adash_at_index/;
    }
    my @inserts_array = @{$inserts};
    my @new_inserts_array;
    for my $insert_item (@inserts_array) {
      if ($insert_item =~ /\\$a/) {
        push @new_inserts_array, $bdash_at_index;
      }else{
        push @new_inserts_array, $insert_item;
      }
    }
    my %result_item = (
      src => $new_src,
      inserts => \@new_inserts_array
    );
    push @results, \%result_item;
  }
  return @results;
}

# given an enum or table name created as part of the datatypes return arrayref of its values
# sometimes it is an enum, and other times a table (depending on if it overflowed the 63 character limit)
sub pgenum2arrayref($) {
  my ($lookup) = @_;
  my ($schema, $name) = $lookup =~ /(.*)\.(.*)/;
  my $matching_tables = $dbh->selectall_arrayref("SELECT table_name FROM information_schema.tables WHERE table_schema = '$schema' AND table_name = '$name';");

  if (scalar @$matching_tables eq 0) { # table doesn't exist, probably an enum
    my $pg_enum_arrayref = $dbh->selectall_arrayref("SELECT enum_range(null::$lookup);");
    my $pg_enum = $pg_enum_arrayref->[0]->[0];
    $pg_enum =~ s/^{//;
    $pg_enum =~ s/}$//;
    my @result = split /,/, $pg_enum;
    return \@result;
  }else{ # table exists
    return $dbh->selectall_arrayref("SELECT * FROM $lookup;");
  }
}
