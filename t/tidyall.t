package main;

use strict;
use warnings;

use Test::More;
if ( !$ENV{'RINUTILS_TEST_TIDY'} )
{
    plan skip_all => "Skipping because RINUTILS_TEST_TIDY is not set";
}

package MyCacheModel;

require Moo;
Moo->import;

extends('Code::TidyAll::CacheModel');

my $DUMMY_LAST_MOD = 0;

sub _build_cache_value
{
    my ($self) = @_;

    return $self->_sig(
        [ $self->base_sig, $DUMMY_LAST_MOD, $self->file_contents ] );
}

package main;

require Test::Code::TidyAll;

my $KEY = 'TIDYALL_DATA_DIR';
Test::Code::TidyAll::tidyall_ok(
    cache_model_class => 'MyCacheModel',
    conf_file         => "$ENV{FCS_SRC_PATH}/.tidyallrc",
    ( exists( $ENV{$KEY} ) ? ( data_dir => $ENV{$KEY} ) : () )
);
