#!/usr/bin/perl -w

# This file is licensed CC0 by Andrew Harvey <andrew.harvey4@gmail.com>
#
# To the extent possible under law, the person who associated CC0
# with this work has waived all copyright and related or neighboring
# rights to this work.
# http://creativecommons.org/publicdomain/zero/1.0/

# ./map-expansion.pl < short_name2target.map > short_name2target_expanded.map

use Data::Dumper;
use strict;
sub insert ($$$$);
sub matchRange ($$);
sub expand($$$$$);

my %expansions = (
  sex => [[qw/Males Females/], [qw/true false/]],
  pop_ages => [[0..79], [0..79]],
  ages_a => [[qw/15_19_years 20_24_years 25_34_years 35_44_years 45_54_years 55_64_years 64_74_years 75_84_years 85_years_and_over/], [qw/15 20 25 35 45 55 65 75 85/]],
  ages_b => [[qw/0_14_years 15_24_years 25_34_years 35_44_years 45_54_years 55_64_years 65_74_years 75_84_years 85_years_and_over/], [qw/0 15 25 35 45 55 65 75 85/]],
  ages_c => [[qw/0_4_years 5_14_years 15_19_years 20_24_years 25_34_years 35_44_years 45_54_years 55_64_years 64_74_years 75_84_years 85_years_and_over/], [qw/0 5 15 20 25 35 45 55 65 75 85/]],
  ages_d => [[qw/15_19_years 20_24_years 25_29_years 30_34_years 35_39_years 40_44_years 45_49_years 50_54_years 55_59_years 60_64_years 65_69_years 70_74_years 75_79_years 80_84_years 85_years_and_over/], [qw/15 20 25 30 35 40 45 50 55 60 64 70 75 80 85/]],
  ages_e => [[qw/0_4_years 5_9_years 10_14_years 15_19_years 20_24_years 25_29_years 30_34_years 35_39_years 40_44_years 45_49_years 50_54_years 55_59_years 60_64_years 65_years_and_over/], [qw/0 5 10 15 20 25 30 35 40 45 50 55 60 65/]]
);

# read in every line of our schema map definion file
while (<>) {
  chomp;
  # and unless it is a comment or empty line...
  unless ((/^#/) || (/^\s*$/)) {
    # "parse" the schema translation definition
    my ($dataset_num, $src_template, $dst_template, $table_orders) =
      /^(\d+) ([^\s]+) ([^\s]+) (.*)$/;
    $table_orders =~ s/^\((.*)\)$/$1/;
    my @insert_values = split /,/, $table_orders;
    # ... and expand it out
    insert ($dataset_num, $src_template, $dst_template, \@insert_values);
    print "\n";
  }
}

# take a template line and expand it out
sub insert ($$$$) {
   my ($dataset_num, $src, $dst, $inserts) = @_;

   my $replacements;
   for my $expansion_key (keys %expansions) {
     if (rangeMatch($src, $expansion_key)) {
       for my $new ( expand($src, $expansion_key, $inserts, @{$expansions{$expansion_key}}[0], @{$expansions{$expansion_key}}[1]) ) {
         insert ($dataset_num, $new->{'src'}, $dst, $new->{'inserts'});
       }
       return;
     }
   }

    if (curlyMatch($src, 'ynn')) {
      for my $new ( expand($src, 'ynn', $inserts, @{$expansions{$expansion_key}}[0], @{$expansions{$expansion_key}}[1]) ) {
        insert ($dataset_num, $new->{'src'}, $dst, $new->{'inserts'});
      }
      return;
    }

   print "Inserting...\n"; 
   print "   $dataset_num\n";
   print "   $src\n";
   print "   $dst\n";
   print "   (".join(',', @{$inserts}).")\n";
   print "\n";

#   my %item = (
#     datapack_table => $dataset_num,
#     src => $src,
#     dst => $dst,
#     column_ordering => $order
#  );
}

# look for a [:foo:] template to expand
sub rangeMatch($$) {
  my ($text, $foo) = @_;
  return $text =~ /\[\:$foo\:\]/;
}

# look for a {foo:bar1|bar2|...|barN} template to expand
sub curlyMatch($$) {
  my ($text, $foo) = @_;
  return $text =~ /\{$foo\:[^}]*\}/;
}

# arguments:
#   src = Age_years_80_84_[:sex:]
#   inserts = (1, true, \sex)
#   a = sex
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
    $new_src =~ s/\[\:$a\:\]/$adash_at_index/;
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
