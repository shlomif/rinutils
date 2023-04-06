#!/usr/bin/env perl

use 5.014;
use strict;
use warnings;
use autodie;

use Getopt::Long qw/ GetOptions /;

use Path::Tiny qw/ path tempdir tempfile cwd /;

sub do_system
{
    my ($args) = @_;

    my $cmd = $args->{cmd};
    print "Running [@$cmd]\n";
    if ( system(@$cmd) )
    {
        die "Running [@$cmd] failed!";
    }
}

my $IS_WIN = ( $^O eq "MSWin32" );
my $SEP    = $IS_WIN ? "\\"    : '/';
my $MAKE   = $IS_WIN ? 'gmake' : 'make';
my $SUDO   = $IS_WIN ? ''      : 'sudo';

my $cmake_gen;
GetOptions( 'gen=s' => \$cmake_gen, )
    or die 'Wrong options';

local $ENV{RUN_TESTS_VERBOSE} = ( $ENV{RUN_TESTS_VERBOSE} // 1 );
if ( defined $cmake_gen )
{
    $ENV{CMAKE_GEN} = $cmake_gen;
}

do_system( { cmd => [ "cmake", "--version" ] } );
if ($IS_WIN)
{
    # ( $ENV{PKG_CONFIG_PATH} //= '' ) .= ";C:\\foo\\lib\\pkgconfig;";
    ( $ENV{PKG_CONFIG_PATH} //= '' ) .=
        ";/foo/lib/pkgconfig/;/c/foo/lib/pkgconfig/";
}

my $cwd = cwd();
do_system(
    {
        cmd => [
"cd . && mkdir ..${SEP}B && cd ..${SEP}B && cmake -DWITH_TEST_SUITE=ON \"$cwd\" "
                . ( defined($cmake_gen) ? qq#-G "$cmake_gen"# : "" )
                . " && $MAKE && $^X \"$cwd${SEP}run-tests.pl\""
        ]
    }
);
