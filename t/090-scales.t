#!/usr/bin/env perl
use warnings;
use strict;
use Musical::Note;
use Musical::Scale;
use Musical::Scale::List;
use Array::Circular;
use Test::More;

my @cmaj1 = (Musical::Note->new('C4'));
my @i = qw(2 2 1 2 2 2 1);
my $exp;

subtest 'naive implementation of scale' => sub {

    push @cmaj1, $cmaj1[-1]->transpose($_) for @i;
    my @exp = ('C4', 'D4', 'E4', 'F4', 'G4', 'A4', 'B4', 'C5');
    my @cmaj2 = (Musical::Note->new('C4'));
    my @i2 = @{ Musical::Scale::List->new->scale_for('Major')->{interval_nums} };
    is_deeply(\@i, \@i2, "intervals match");
    push @cmaj2, $cmaj2[-1]->transpose($_) for @i2;
    my $got = [ map { $_->iso } @cmaj2 ];
    is_deeply $got, \@exp, "C major scale as we expected";
    $exp = [ map { $_->iso } @cmaj1  ];
    is_deeply( $got, $exp, "generated from intervals") ;
};

subtest 'implementation with Array::Circular' => sub {
    my $i = Musical::Scale::List->new->scale_for('Major')->{interval_nums};
    my @c = (Musical::Note->new('C4'));
    push @c, $c[-1]->transpose($i->current_and_next) for ( 1 .. @$i);
    is_deeply($exp,  [ map { $_->iso } @c ], 'intervals as Array::Circular');
};

subtest 'proper oo impl' => sub {
    my $scale = Musical::Scale->new(root => 'C4');
    my @s = map { $scale->up } 0 .. @{$scale->intervals};
    my $got = [map { $_->iso } @s];

    is_deeply $exp, $got, 'oo implementation generates correct scale';
    my $rev_exp = [reverse @$exp];
    my @sd = map { $scale->down->iso } 0 .. @{$scale->intervals};
    diag explain \@sd ;
    is_deeply $rev_exp, \@sd, "Descending also generates correct scale";
};

done_testing;
