#!/usr/bin/env perl
# t/003_methods.t - check various manipulation methods

use Test::More;
use Musical::Note;

my $note = Musical::Note->new({step=>'C',octave=>3,alter=>0});

subtest 'transpose -1' => sub {
    $note->transpose(-1);

    is($note->step, 'B');
    is($note->octave, 2);
    is($note->alter, 0);
};

subtest 'transpose 14' => sub {
    $note->transpose(14);

    is($note->step, 'C');
    is($note->octave, 4);
    is($note->alter, 1);
};

subtest 'enharmonic' => sub {
    $note->en_eq('f');

    is($note->step, 'D');
    is($note->octave, 4);
    is($note->alter, -1);
};

subtest 'up a semitone' => sub {
    $note->alter(1);

    is($note->step, 'D');
    is($note->octave, 4);
    is($note->alter, 1);
};

done_testing;
