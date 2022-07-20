package Rinutils::InlineWrap;

use 5.014;
use strict;
use warnings;

use Config;
use Inline;

use Rinutils::Paths::Base qw( is_win );
use Rinutils::Paths       qw( bin_file src_file );

sub import
{
    my ( $self, %args ) = @_;

    my ($pkg) = caller(0);

    my $src  = delete( $args{C} );
    my $libs = delete( $args{l} ) // '';

    my @workaround_for_a_heisenbug =
        ( is_win() ? ( optimize => '-g' ) : () );

    my $ccflags = "$Config{ccflags} -std=gnu99";
    if ( is_win() )
    {
        $ccflags =~ s#(^|\s)-[Of][a-zA-Z0-9_\-]*#$1#gms;
    }

    my @inline_params = (
        C    => $src,
        name => $pkg,
        NAME => $pkg,
        INC  => join( " ",
            map     { "-I$_" }
                map { bin_file($_), src_file($_) }
                ( ["include"], ["rinutils/include"], [] ) ),
        CCFLAGS           => $ccflags,
        CLEAN_AFTER_BUILD => 0,
        LIBS              => "-L$ENV{FCS_BIN_PATH} $libs",
        @workaround_for_a_heisenbug,
        %args,
    );

=begin debug

    if (is_win())
    {
        require Data::Dumper;
        print STDERR "inline_params = <<<<<\n", Data::Dumper::Dumper( \@inline_params ),
            ">>>>>>\n";
    }

=end debug

=cut

    ## no critic
    eval "{ package $pkg; Inline->bind(\@inline_params); }";
    ## use critic

    if ($@)
    {
        die $@;
    }

    return;
}

1;
