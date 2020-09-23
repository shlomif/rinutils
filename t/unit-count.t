#!/usr/bin/perl

use strict;
use warnings;

use FindBin qw/ $Bin /;
use lib "$Bin/lib";

use Rinutils::InlineWrap (
    C => <<"EOF",
#include "rinutils/count.h"

int test_count() {
    int myarr[24];
    return COUNT(myarr);
}

int test_last() {
    int mymyarr[7]={0,1,2,3,4,5,606};
    return LAST(mymyarr);
}
EOF
);

use Test::More tests => 2;
use Test::Differences (qw( eq_or_diff ));

# TEST
eq_or_diff( scalar( test_count() ), 24, "COUNT() works" );

# TEST
eq_or_diff( scalar( test_last() ), 606, "LAST() works" );
