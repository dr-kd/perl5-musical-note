#!/usr/bin/env perl
use warnings;
use strict;
use Musical::Note;
use Test::More;
my $by_midi = { map {
    my $n = Musical::Note->new($_, 'midinum');
    $n->format('midinum') => {
        iso => $n->format('iso'),
        $n->alter ? ( flat => $n->en_eq('flat') || $n->format('iso') ) : (),
        midinum => $n->format('midinum'),
        step => $n->step,
        octave => $n->octave,
        alter => $n->alter, }
    } ( 21 .. 33 )
};
diag explain $by_midi;

my $by_iso = { map { $by_midi->{$_}->{iso} => $by_midi->{$_} } keys %$by_midi };
diag explain $by_iso;
ok(1);
done_testing;
