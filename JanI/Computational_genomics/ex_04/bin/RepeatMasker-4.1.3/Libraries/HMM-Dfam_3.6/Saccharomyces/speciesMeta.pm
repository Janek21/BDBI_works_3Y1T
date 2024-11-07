package speciesMeta;
require Exporter;
@EXPORT_OK   = qw( %validIDs );
%EXPORT_TAGS = ( all => [ @EXPORT_OK ] );
@ISA         = qw(Exporter);
BEGIN {
  %validIDs = (

          'is10' => 1,
          'is3' => 1,
          'tn1000' => 1,
          'is2' => 1,
          'is150' => 1,
          'is186' => 1,
          'is30' => 1,
          'is1' => 1,
          'is5' => 1
        

  ); }
