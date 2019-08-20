#!/usr/bin/env perl
use warnings;
use strict;
use Musical::Note;
use Array::Circular;
use Test::More;
use YAML;

my @n = ('c', 'c#', 'd', 'd#', 'e', 'f',  'f#', 'g',  'g#',  'a',  'a#',  'b');
my $n = Array::Circular->new(@n);

$n->loops(-1);

my @note_list;

# for my $i (0 .. 11) {
for my $i (0 .. 127) {
    my $o = $n->loops + 1;
    my $midinote = $o * 12 + $n->index;
    my $this = $n->current_and_next;

    push @note_list, { midinote => $midinote, iso =>  "$this" . $n->loops };
    my $test_name = "Midinote: $midinote, ISO: $this" . $n->loops;
    subtest $test_name => sub {
        my $note = Musical::Note->new(midinum => $i);
        is $note->midinum, $i;
    };
}

my %note_cache = (
    midinum => \@note_list,
    iso => { map { $_->{iso} => $_ } @note_list },
);

# diag explain \%note_cache;


done_testing;
