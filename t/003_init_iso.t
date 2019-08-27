#!/usr/bin/env perl
use warnings;
use strict;
use Musical::Note;
use Array::Circular;
use Test::More;

my @notes = (
    ['C',  'Dbb', 'B#',],
    ['C#', 'Db', 'Bx',],
    ['D',  'Cx', 'Ebb',],
    ['D#', 'Eb', 'Fbb',],
    ['E',  'Dx', 'Fb',],
    ['F',  'E#', 'Gbb',],
    ['F#', 'Gb', 'Ex',],
    ['G',  'Fx', 'Abb',],
    ['G#', 'Ab',],
    ['A',  'Gx', 'Bbb',],
    ['A#', 'Bb', 'Cbb',],
    ['B',  'Ax', 'Cb',],
);

my $c = 0;
for my $oct (-1 .. 9) {
    subtest "octave $oct" => sub {
        foreach my $n (@notes) {
            last if $c > 127;
            subtest "note $c of scale" => sub {
                foreach my $m (@$n) {
                    my $mm = $m . $oct;
                    my $o = Musical::Note->new($mm);
                    my $i = Musical::Note->_parse_iso($mm);
                    my ($x) = explain $i;
                    is_deeply $i, { map { $_ => $o->$_ } qw/ step octave alter / }, "parsed $m$oct" . ($ENV{VERBOSE} ?  "to $x ok" : "");
                    is $o->midinum, $c, $o->iso . " is midinum $c";
                }
            };
            $c++;
        }
    };
}

done_testing;
