#!/usr/bin/env perl
use warnings;
use strict;
use Musical::Scale;
use Test::More;

=head1 NOTES

So we're going to approach this using Levine, Jazz Theory as a starting point.

The crux being that chords are easiest to remember with the context of what
scale they're in.

Major
Melodic Minor
Diminished
Whole tone.

Let's also think about inversions.

on CM

1 3 5 == C E G
3 5 1 == E G C # 1st inv same as root but last note an octave above
5 1 4 == G E C # 2nd inv

on CM7

1 3 5 7 = C E G B # C maj 7
3 5 7 1 = E G B C # 1st inv
5 7 1 3 = G B C E # 2nd inv
7 1 3 5 = B C E G # 3rd inv




=cut

# standard triad

my @triad = qw(1     3      5);
#              r     2      2
#              x     y      z
#              x1    x2     x3
#              0     2      4
#              0     x2-x1  x3-x2

my @sev   = qw(1     3     5      7);
#              r     2     2      2
#              x     y     z      p
#              x1    x2    x3     x4
#              0     2     4      6
#              0     .     .      x4-x3

my @tinv2 = qw(5 1 3);
my @tinv1 = qw(3 5 1);

my @sinv1 = qw(3 5 7 1);
my @sinv2 = qw(5 7 1 3);
my @sinv3 = qw(7 1 3 5);

subtest 'test implementation' => sub {
    my $scale = Musical::Scale->new(mode => 'Major',
                                    root => 'C4',
                                );
    ok $scale->isa('Musical::Scale');
    my $curr = $scale->root;
    $DB::single=1;
    1 == 1;
};


done_testing;
