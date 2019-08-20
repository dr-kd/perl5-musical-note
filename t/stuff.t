#!/usr/bin/env perl
use warnings;
use strict;
use Test::More;
use Array::Circular;


my $n = Array::Circular->new(
    { 'alter' => 0,                 'iso' => 'C',   'step' => 'C' },
    { 'alter' => 1, 'flat' => 'Db', 'iso' => 'C#',  'step' => 'C' },
    { 'alter' => 0,                 'iso' => 'D',   'step' => 'D' },
    { 'alter' => 1, 'flat' => 'Eb', 'iso' => 'D#',  'step' => 'D' },
    { 'alter' => 0,                 'iso' => 'E',   'step' => 'E' },
    { 'alter' => 0,                 'iso' => 'F',   'step' => 'F' },
    { 'alter' => 1, 'flat' => 'Gb', 'iso' => 'F#',  'step' => 'F' },
    { 'alter' => 0,                 'iso' => 'G',   'step' => 'G' },
    { 'alter' => 1, 'flat' => 'Ab', 'iso' => 'G#',  'step' => 'G' },
    { 'alter' => 0,                 'iso' => 'A',   'step' => 'A' },
);

$n->loops(-1);

for (0 .. 127) {
    my $o = $n->loops + 1;
    my $midinum = $n->index + $o * @$n;
    $n->next;
    is $midinum, $_, "$_ matches $midinum";
}

done_testing;
