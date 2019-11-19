#!/usr/bin/env perl
use Test::More;
use Musical::Note qw/Kern/;

is 'black', 'white', 'This test is broken - it passes but output is wrong';
my $n = Musical::Note->new('C4');

my $out = $n->format;
is $out, 'C4';
$n->formatter('kern');
$out = $n->format;
is $out, q|c|;

for $i (0 .. 127) {
    my $m = Musical::Note->new($i);
    my $out = sprintf 'iso: %s kern: %s', $m->iso, $m->kern;
    diag $out;
}

done_testing;





