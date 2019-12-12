#!/usr/bin/env perl
use warnings;
use strict;
use Musical::Note;
use Musical::Scale::List;
use Test::More;
my @cmaj1 = (Musical::Note->new('C4'));

my @i = qw(2 2 1 2 2 2 1);
push @cmaj1, $cmaj1[-1]->transpose($_) for @i;

my @exp = ('C4', 'D4', 'E4', 'F4', 'G4', 'A4', 'B4', 'C5');


my @cmaj2 = (Musical::Note->new('C4'));

my @i2 = @{ Musical::Scale::List->new->scale_for('Major')->{interval_nums} };
is_deeply(\@i, \@i2, "intervals match");
push @cmaj2, $cmaj2[-1]->transpose($_) for @i2;
my $got = [ map { $_->iso } @cmaj2 ];
is_deeply $got, \@exp, "C major scale as we expected";
my $exp = [ map { $_->iso } @cmaj1  ];
is_deeply( $got, $exp, "generated from intervals") ;
done_testing;
