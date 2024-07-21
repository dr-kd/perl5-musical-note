#!/usr/bin/env perl
use warnings;
use strict;
use Music::Theory::Note;
use Test::More;

for (0 .. 127) {
    my $n = Music::Theory::Note->new($_);
    ok $n->iso, $n->iso;
}
done_testing;
