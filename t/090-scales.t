#!/usr/bin/env perl
use warnings;
use strict;
use Musical::Note;
use Musical::Scale;
use Musical::Scale::List;
use Array::Circular;
use Test::More;

my @iso = qw( C4 D4 E4 F4 G4 A4 B4 C5 );

subtest basics => sub {
    use_ok 'Musical::Scale::List';
    my $scale = new_ok 'Musical::Scale::List';
    my $got = $scale->available_scales;
    is scalar @$got, 38, 'available_scales';
    $got = $scale->all_scales;
    is scalar @$got, 38, 'all_scales';
    ok $got->[0]{name}, 'all_scales';
    $got = $scale->scale_for('Major');
    isa_ok $got, 'HASH';
    my $name = 'Major (Ionian)';
    $got = $scale->scale_for($name);
    isa_ok $got, 'HASH';
    isa_ok $got->{interval_nums}, 'Array::Circular';
    my $expect = [qw( 0 2 4 5 7 9 11 )];
    $got = $scale->array_for($name);
    isa_ok $got, 'Array::Circular';
    is "@$got", "@$expect", 'array_for note_nums';
    $expect = [qw( 2 2 1 2 2 2 1 )];
    $got = $scale->array_for($name, 'interval_nums');
    is "@$got", "@$expect", 'array_for interval_nums';
    $expect = [qw( W W H W W W H )];
    $got = $scale->array_for($name, 'interval_names');
    is "@$got", "@$expect", 'array_for interval_names';
    @$got = $scale->get_intervals([qw(1 2 3 4 5)]);
    is_deeply $got, [qw(1 1 1 1)], 'get_intervals';
};

subtest transpose => sub {
    my $note = new_ok 'Musical::Note' => ['C4'];
    my @c_major = ('C4');
    my @i = qw(2 2 1 2 2 2 1);
    my $expect = 0;
    for my $i (@i) {
        $expect += $i;
        my $got = $note->transpose($expect);
        is $got->midinum, $expect + 60, 'transpose midinum';
        push @c_major, $got->iso;
    }

    is_deeply \@c_major, \@iso, 'generated from intervals';

    # get major intervals
    my $scale = new_ok 'Musical::Scale::List';
    my $got = $scale->scale_for('Major (Ionian)')->{interval_nums};
    is "@$got", "@i", 'interval_nums';

    my @i2 = split /\s/, "@$got";
    my $sum = 0;
    my $count = 1;
    for my $i (@i2) {
        $sum += $i;
        my $got = $note->transpose($sum);
        my $expect = $iso[$count++];
        is $got->iso, $expect, 'transpose iso';
    }
};

subtest oo => sub {
    my $scale = Musical::Scale->new(root => 'C4');
    my @up = map { $scale->up } 0 .. @{ $scale->intervals };
    my $got = [ map { $_->iso } @up ];
    is_deeply $got, \@iso, 'oo implementation generates correct scale';

    my @down = map { $scale->down->iso } 0 .. @{ $scale->intervals };
    # diag explain \@down;
    is_deeply \@down, [ reverse @iso ], "Descending also generates correct scale";
};

done_testing;
