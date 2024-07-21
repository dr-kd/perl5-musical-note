#!/usr/bin/env perl
use Test::More;
use Music::Theory::Note qw/Lilypond/;

my $n = Music::Theory::Note->new('C4');

my $out = $n->format;
is $out, 'C4';
$n->formatter('lilypond');
$out = $n->format;
is $out, q|c'|;

for $i (0 .. 127) {
    my $m = Music::Theory::Note->new($i);
    my $out = sprintf 'iso: %s llp: %s rel: %s', $m->iso, $m->lilypond, $m->lilypond_relative;
    diag $out;
}

done_testing;





