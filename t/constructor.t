#!/usr/bin/env perl
use warnings;
use strict;
use Musical::Note;
use Test::More;

my @midi_range = (21 .. 108);

foreach (@midi_range) {

    subtest "midinote $_" => sub {
        my $n = Musical::Note->new($_);
        ok ($n->midinum, 'midinum');
        ok ($n->step, 'step');
        ok ($n->octave, 'octave');
        ok ($n->alter, 'alter');
    };
}

done_testing;
