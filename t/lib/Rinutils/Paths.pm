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

# A file in the output/binaries directory where fc-solve was compiled.
sub bin_file
{
    return $FCS_PATH->child( @{ shift @_ } );
}

sub normalize_lf
{
    my ($s) = @_;
    $s =~ s#$CRLF#$LF#g;
    return $s;
}

1;
