#!/usr/bin/perl
#
## ######################################################################################
##
##   pwmfinder.pl - finding possible locations for a signal modeled with a PWM model
##
## ######################################################################################
##
##                 CopyLeft 2024 (CC:BY-NC-SA) --- Josep F Abril
##
##   This file should be considered under the Creative Commons BY-NC-SA License
##   (Attribution-Noncommercial-ShareAlike). The material is provided "AS IS", 
##   mainly for teaching purposes, and is distributed in the hope that it will
##   be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
##   of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
##
## ######################################################################################
#

use strict;
use warnings;

if (scalar(@ARGV) < 1) {

  print STDERR "ERROR: pwmfinder.pl requires a PWM file\n";
  exit(1);

};

if (!open(MATFILE,"< $ARGV[0]")) {

  print STDERR "ERROR: pwmfinder.pl cannot open $ARGV[0] file\n";
  exit(1);

};

my %pwm = ();         # storing PWM in a hash
my @nucleotides = (); # array to store nucleotides chars
my $reading_pwm = 0;  # Flag: are we reading scores for PWM or not
my $pos = 0;          # Temporary variable to store the current position
                      # on the PWM being read.

while (<MATFILE>) {

  next if /^\#/o;
  next if /^\s*$/o;

  my $line = $_;

  ($reading_pwm == 0
   && $line =~ m/\AP0\s+(\w+)\s+(\w+)\s+(\w+)\s+(\w+)/
   ) && do {

      $nucleotides[0] = $1;
      $nucleotides[1] = $2;
      $nucleotides[2] = $3;
      $nucleotides[3] = $4;

      $reading_pwm = 1;

      next;

  }; # if $reading_pwm == 0

  ($reading_pwm == 1) && do {

      $line =~ m/\A\d+\s+([\-\d\.]+)\s+([\-\d\.]+)\s+([\-\d\.]+)\s+([\-\d\.]+)/
        && do {

          $pwm{$nucleotides[0]}[$pos] = $1;
          $pwm{$nucleotides[1]}[$pos] = $2;
          $pwm{$nucleotides[2]}[$pos] = $3;
          $pwm{$nucleotides[3]}[$pos] = $4;

          $pos++;

          next;

      };

      $line =~ m/\AXX\s+(\d+)/
        && do {

          $pwm{P}      = $1;
          $reading_pwm = 0;

      };

  }; # if $reading_pwm == 1

}; # while

my $i = 0;
my $len = scalar(@nucleotides);

while ($i < $len) {

  print STDERR "$nucleotides[$i] : @{ $pwm{ $nucleotides[$i] } }\n";

  $i++;

}; # while

print STDERR "Intron first nucleotide: $pwm{P}\n";

# Reading a DNA sequence in fasta format from file

my $iden = <STDIN>;  # Reading first line of fasta file
                     # which conatins the sequence identifier ">XXXX"...
my @seql = <STDIN>;  # Reading the sequence from the rest of lines...
                     # The above two lines will only work
                     # when fasta file has only one sequence...
my $seq  = q{};      # A string to concatenate all the sequence lines...

$i = 0;
while ($i < scalar(@seql)) {

  chomp($seql[$i]);
  $seq = $seq . $seql[$i];
  $i = $i + 1;

};

$seq = uc($seq); # Convert all nucleotides to UpperCase

my @vseq = split //o, $seq;
         # Storing sequence string into a nucleotide vector

# Score all possible signals using the PWM

$i = 0;
while ($i < scalar(@vseq) - $pos) {

  my $k = 0;
  my $p = 0;

  while ($k < $pos) {

    $p = $p + $pwm{ $vseq[$i + $k] }[$k];
    $k++;

  }; # while $k

  $p > 0 &&
      print STDOUT $i + $pwm{P}, " ", sprintf("%10.3f", $p), "\n";

  $i++;

}; # while $i
