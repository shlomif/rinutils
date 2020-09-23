package Rinutils::Paths::Base;

use 5.014;
use strict;
use warnings;
use parent 'Exporter';

our @EXPORT_OK = qw( is_win );

sub is_win
{
    return ( $^O eq "MSWin32" );
}

1;
