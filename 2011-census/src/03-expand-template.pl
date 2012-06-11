#!/usr/bin/perl -w

# This file is licensed CC0 by Andrew Harvey <andrew.harvey4@gmail.com>
#
# To the extent possible under law, the person who associated CC0
# with this work has waived all copyright and related or neighboring
# rights to this work.
# http://creativecommons.org/publicdomain/zero/1.0/

# Given a file defining the mapping of fields into the target PostgreSQL
# schema, expand out the placemarker values.

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
my %age_expansions = (
    a => "0..79 80-84 85-89 90-94 95-99 100+",
    b => "0..24 25-29 30-34 35-39 40-44 45-49 50-54 55-59 60-64 65+",
    c => "15-19 20-24 25-34 35-44 45-54 55-64 65-74 75-84 85+",
    d => "0-14 15-24 25-34 35-44 45-54 55-64 65-74 75-84 85+",
    e => "0-4 5-14 15-19 20-24 25-34 35-44 45-54 55-64 65-74 75-84 85+",
    f => "0-4 5-9 10-12 13-14 15-17 18-20 21-24",
    g => "15-19 20-24 25-29 30-34 35-39 40-44 45-49 50-54 55-59 60-64 65-69 70-74 75-79 80-84 85+",
    h => "0-4 5-9 10-14 15-19 20-24 25-29 30-34 35-39 40-44 45-49 50-54 55-59 60-64 65+",
    i => "0-4 5-14 15-19 20-24 25-34 35-44 45-54 55-64 65+",
    j => "0..79 80-84 85+",
    k => "15-24 25-34 35-44 45-54 55-64 65-74 75-84 85+",
    l => "15-19 20-24 25-34 35-44 45-54 55-64 65+"
  );

# hard code the [:foo:] expansions
# format is foo => [[long name values list],[target insert values list][
my %expansions = (
  sex => [
      [qw/Males Females/],
      [qw/true false/]
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
      [qw/0_74 75_99 100_149 150_199 200_224 225_274 275_349 350_449 450_549 550_649 650_and_over Rent_not_stated/],
      [0..11]
    ],
  mortgage_repayment_band => [
      [qw/0_299 300_449 450_599 600_799 800_999 1000_1399 1400_1799 1800_2399 2400_2999 3000_3999 4000_and_over Mortgage_repayment_not_stated/],
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
  indigenous_income_band => [
      [qw/Negative_Nil_income 1_199 200_299 300_399 400_599 600_799 800_999 1000_or_more Personal_income_not_stated/],
      [0..8]
    ],
  indigenous_household_income => [
      [qw/Negative_Nil_income 1_199 200_299 300_399 400_599 600_799 800_999 1000_1249 1250_1499 1500_1999 2000_2499 2500_2999 3000_or_more Partial_income_stated All_incomes_not_stated/],
      [0..14]
    ],
  year_of_arrival_a => [
      [qw/Before_1941 1941_1950 1951_1960 1961_1970 1971_1980 1981_1990 1991_2000 2001_2005 2006 2007 2008 2009 2010 2011 not_stated/],
      [0..14],
    ],
  year_of_arrival_b => [
      [qw/Before_1996 1996_2000 2001_2005 2006 2007 2008 2009 2010 2011 not_stated/],
      [0..9]
    ]
);

my @age_inserts;

for my $k (keys %age_expansions) {
  my @values = split / /, $age_expansions{$k};

  my @long_names;
  my @target_values;

  for my $v (@values) {
    if ($v =~ /^(\d+)\.\.(\d+)$/) {
      push @long_names, $1..$2;
      push @target_values, $1..$2;

      map {push @age_inserts, $_ . "\t" . $_ . "\t" . $_} $1..$2;
    }elsif ($v =~ /^(\d+)-(\d+)$/) {
      push @long_names, "$1_$2_years";
      push @target_values, "$1-$2";

      push @age_inserts, "$1" . "-" . $2 . "\t" . $1 . "\t" . $2;
    }elsif ($v =~ /^(\d+)\+$/) {
      push @long_names, "$1_years_and_over";
      push @target_values, "$1+";

      push @age_inserts, $1 . "+\t" . $1 . "\t" . "\\N";
    }else{
      die;
    }
  }

  $expansions{"age_" . $k} = [\@long_names, \@target_values];
}

# produce a .copy file so we can load the data from the age_expansions
# hash into our target schema
open (my $age_copy, '>', "age.copy");
map {print $age_copy "$_\n"} @age_inserts;
close $age_copy;

# read in every line of our schema map definion file
for my $line (<STDIN>) {
  chomp $line;
  # and unless it is a comment or empty line...
  unless (($line =~ /^#/) || ($line =~ /^\s*$/)) {
    # "parse" the schema translation definition
    if ($line =~ /^(\w\d+) ([^\s]+) ([^\s]+) (.*)$/) {
      my ($dataset_num, $src_template, $dst_template, $table_orders) = ($1, $2, $3, $4);
      $table_orders =~ s/^\((.*)\)$/$1/;
      my @insert_values = split(/,/, $table_orders);
      # ... and expand it out
      insert ($dataset_num, $src_template, $dst_template, \@insert_values);
      print "\n";
    }else{
      die "Map file line of unexpected format: $line\n";
    }
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
    return $dbh->selectall_arrayref("SELECT * FROM $lookup;")->[0];
  }
}
