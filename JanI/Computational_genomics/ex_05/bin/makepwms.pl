#!/usr/bin/perl
#
## ######################################################################################
##
##   makepwms.pl - computing a PWM model from a set of signal sequences
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

if (scalar(@ARGV) < 2) {

  print STDERR "ERROR: makepwms.pl requires two arguments an integer and a sequence file in tabular format\n";
  exit(1);

};

my $col = $ARGV[0];
my $file = $ARGV[1];

if (!open(SEQSFILE,"< $file")) {

  print STDERR "ERROR: makepwms.pl cannot open $file file\n";
  exit(1);

};

my @pwm    = ();         # storing PWM counter in a matrix
my @nucleotides = qw( A C G T N );
my %nucs   = qw( A 0 C 1 G 2 T 3 N 4 SUM 5 );
my @zeroes = (0) x (scalar(@nucleotides) + 1);

# loading absolute frequencies matrix
my $c = 0;
while (<SEQSFILE>) {

  next if /^\#/o;
  next if /^\s*$/o;
  chomp;
  my $line = uc($_);

  for (my $i = 0; $i < length($line); $i++) {
      my $nuc = substr($line, $i, 1);
      exists($pwm[$i]) || ($pwm[$i] = [ @zeroes ]);
      my $j = exists($nucs{$nuc}) ? $nucs{$nuc} : $nucs{"N"};
      $pwm[$i][$j]++;
  };
  
  $c++;
  
}; # while

print STDERR "# Processed $c sequences...\n";
close(SEQSFILE);

my $I = scalar(@pwm);
my $J = scalar(@zeroes);

# relative frequencies matrix
for (my $i = 0; $i < $I; $i++) {
    for (my $j = 0; $j < $J; $j++) {
        $pwm[$i][$J] += $pwm[$i][$j];
        print STDERR "$i $j $pwm[$i][$j]\n";
    };
};

# computing loglikelyhood matrix
for (my $i = 0; $i < $I; $i++) {
    for (my $j = 0; $j < $J; $j++) {
	$pwm[$i][$j] = &loglikelyhood($pwm[$i][$j]/$pwm[$i][$J]);
        print STDERR "$i $j $pwm[$i][$j]\n";
    };
};

# writing the matrix
print STDOUT <<"EOF";
##
## A simple Position Weight Matrix
## derived from a set of sequences
## from $file
##
EOF

print STDOUT "P0",
             join("", map { sprintf("%10s", $_) } @nucleotides), "\n";

$J = scalar(@nucleotides) - 1;
my $k = 0;
for (my $i = 0; $i < $I; $i++) {
    my @tmp = @{ $pwm[$i] };
    print STDERR sprintf("%02d", $k+1)," @tmp\n";
    print STDOUT sprintf("%02d", ++$k),
                 join("", map { sprintf("%10.3f", $_) } @tmp[(0..$J)]), "\n";
};

print STDOUT "XX $col\n";
    
exit(0);

sub loglikelyhood() {
    my ($score,$lklhd);
    $score = shift;
    $lklhd = $score == 0 ? -9999 : log($score / 0.25) / log(2);
    return $lklhd;
} # loglikelyhood
