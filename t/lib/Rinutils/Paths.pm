package Rinutils::Paths;

use 5.014;
use strict;
use warnings;

use parent 'Exporter';
our @EXPORT_OK = qw(bin_file src_file);

use Path::Tiny qw/ path /;

my $FCS_SRC_PATH = path( $ENV{FCS_SRC_PATH} );

sub src_file
{
    return $FCS_SRC_PATH->child( @{ shift @_ } );
}

my $FCS_BIN_PATH = path( $ENV{FCS_BIN_PATH} );

# A file in the output/binaries directory where fc-solve was compiled.
sub bin_file
{
    return $FCS_BIN_PATH->child( @{ shift @_ } );
}

1;
