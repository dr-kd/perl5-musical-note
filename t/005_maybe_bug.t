#!/usr/bin/env perl
use warnings;
use strict;
use Test::More;
use Musical::Note;


my $n = Musical::Note->new();
my $m = Musical::Note->new(step => 'c', octave => 4);
my $o = Musical::Note->new(step => 'c', octave => 4, alter => '1');
my $o1 = Musical::Note->new('c#4');
is ($n->format('midinum'), $m->format('midinum'));
isnt ($n->format('midinum'), $o->format('midinum'));
# isnt ($n->format('midinum'), $o1->format('midinum'));
# my $o2 = Musical::Note->new('D4');
# diag $o2->format('midinum');

done_testing;
