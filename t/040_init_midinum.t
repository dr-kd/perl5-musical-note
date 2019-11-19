#!/usr/bin/env perl
use warnings;
use strict;
use Musical::Note;
use Test::More;

for (0 .. 127) {
    my $n = Musical::Note->new($_);
    ok $n->iso, $n->iso;
}
done_testing;
