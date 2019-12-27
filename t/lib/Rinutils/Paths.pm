package Rinutils::Paths;

use 5.014;
use strict;
use warnings;
use Socket qw(:crlf);
use String::ShellQuote qw/shell_quote/;

use parent 'Exporter';

our @EXPORT_OK = qw($IS_WIN bin_file src_file);

use Path::Tiny qw/ path /;

my $FCS_SRC_PATH = path( $ENV{FCS_SRC_PATH} );

sub src_file
{
    return $FCS_SRC_PATH->child( @{ shift @_ } );
}

sub src_script
{
    return src_file( [ 'scripts', shift ] );
}
our $IS_WIN = ( $^O eq "MSWin32" );

sub _correct_path
{
    my $p = shift;
    if ($IS_WIN)
    {
        $p =~ tr#/#\\#;
    }
    return $p;
}
my $EXE_SUF  = ( $IS_WIN ? '.exe' : '' );
my $FCS_PATH = path( $ENV{FCS_PATH} );
my $PY3      = ( $IS_WIN ? 'python3 ' : '' );

sub exe_fn
{
    return shift . $EXE_SUF;
}

sub _is_tag
{
    my ($tag) = @_;

    return ( ( $ENV{FCS_TEST_TAGS} // '' ) =~ /\b\Q$tag\E\b/ );
}
my $BREAK_TAG   = _is_tag('break_backcompat');
my $FC_ONLY     = _is_tag('fc_only');
my $NO_FLARES   = _is_tag('no_flares');
my $NO_PATSOLVE = _is_tag('no_pats');
my $NO_VALGRIND = _is_tag('no_valg');
my $NO_DBM      = _is_tag('no_dbm');
my $DBM_APR     = _is_tag('dbm_apr');

# A file in the output/binaries directory where fc-solve was compiled.
sub bin_file
{
    return $FCS_PATH->child( @{ shift @_ } );
}

sub dll_file
{
    my $fn = shift;
    return bin_file( [ "lib$fn." . ( $IS_WIN ? "dll" : "so" ) ] );
}

sub bin_exe_raw
{
    return _correct_path( bin_file(@_) ) . $EXE_SUF;
}

# A board file in the binary directory.
sub bin_board
{
    return $FCS_PATH->child(shift);
}

sub is_break
{
    return $BREAK_TAG;
}

sub is_freecell_only
{
    return $FC_ONLY;
}

sub is_without_flares
{
    return $NO_FLARES;
}

sub is_without_valgrind
{
    return $NO_VALGRIND;
}

sub normalize_lf
{
    my ($s) = @_;
    $s =~ s#$CRLF#$LF#g;
    return $s;
}

1;
