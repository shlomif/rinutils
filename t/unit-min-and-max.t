#!/usr/bin/perl

use strict;
use warnings;

use FindBin qw/ $Bin /;
use lib "$Bin/lib";

use Rinutils::InlineWrap (
    C => <<"EOF",
#include "rinutils/min_and_max.h"

int max_wrap(int a, int b) {
    return max(a, b);
}

int min_wrap(int a, int b) {
    return min(a, b);
}
EOF
);

use Test::More tests => 2;
use Test::Differences (qw( eq_or_diff ));

# TEST
eq_or_diff( max_wrap( 3, 24 ), 24, "max" );

# TEST
eq_or_diff( min_wrap( 7, 140 ), 7, "max" );
