#!/usr/bin/env perl
# t/002_create.t - check various note creation methods

use Test::More;
use Musical::Note;

for ( 0 .. 127) {
    subtest "Midi note $_" => sub  {
        my $note = Musical::Note->new(midinum => $_);
        is $note->format('midinum'), $_, "midinote matches midi note";
    };
}

done_testing;
