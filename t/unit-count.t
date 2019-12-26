#!/usr/bin/perl

use strict;
use warnings;

use FindBin qw/ $Bin /;
use lib "$Bin/lib";

package Rinutils::Count;

use FC_Solve::InlineWrap (
    C => <<"EOF",
#include "rinutils/count.h"

int test_count() {
    int myarr[24];
    return COUNT(myarr);
}

EOF
);

package main;

use Test::More tests => 1;
use Test::Differences (qw( eq_or_diff ));

# TEST
eq_or_diff( scalar( Rinutils::Count::test_count() ), 24, "COUNT() works" );
