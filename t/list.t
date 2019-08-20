#!/usr/bin/env perl
use warnings;
use strict;
use Array::Circular;
use Test::More;

my @n = ('c', 'c#', 'd', 'd#', 'e', 'f', 'f#', 'g', 'g#', 'a', 'a#', 'b');
my $n = Array::Circular->new(@n);
$n->loops(-1);
my @all;

for (0 .. 127) {
    my $o = $n->loops + 1;
    my $midinote = $o * 12 + $n->index;
    my $this = $n->current_and_next;
    push @all, { midinote => $midinote, iso =>  "$this" . $n->loops };
}

ok 1;
diag explain \@all;
done_testing;

__END__

   | x x | x x x | |
   | x x | x x x | |
   |c|d|e|f|g|a|b|c|
   ----------------- 
