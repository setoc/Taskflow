package App::Custom::Hdb;
use 5.016;
use strict;
use warnings;


#use Exporter qw (import);
#our @EXPORT_OK=qw(execute);

sub hdbcopydata{
        #  0         1          2      3            4
     my ($package, $filename, $line, $subroutine, $hasargs,
    #  5          6          7            8       9         10
    $wantarray, $evaltext, $is_require, $hints, $bitmask, $hinthash)
  = caller(0);
    say "executing $subroutine";
    return 1;
}


1;