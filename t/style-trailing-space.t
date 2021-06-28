#!/usr/bin/perl

use strict;
use warnings;

use Test::TrailingSpace ();
use Test::More tests => 2;

foreach my $path ( @ENV{qw/FCS_SRC_PATH FCS_BIN_PATH/} )
{
    my $finder = Test::TrailingSpace->new(
        {
            root              => $path,
            filename_regex    => qr/./,
            abs_path_prune_re => qr#CMakeFiles|CTestTestfile\.cmake|_Inline|
(?:\.(?:a|dll|exe|gz|o|patch|pyc|xcf|xz)\z) |
(?:(?:\A|/|\\)\.\S+\.swp\z) |
(?:(?:\A|/|\\)valgrind\S*\.log\z) |
(?:(?:\A|/|\\)DartConfiguration\.tcl\z)
#msx,
        }
    );

    # TEST*2
    $finder->no_trailing_space("No trailing whitespace was found.");
}
