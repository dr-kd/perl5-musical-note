#!/usr/bin/env perl
use warnings;
use strict;
use Musical::Scale::List;
use Test::More;
my $scales = new_ok 'Musical::Scale::List', [], "Got a new scale obj";
my $maj = $scales->scale_for('Major (Ionian)');
ok $maj, "Found a major scale";
my $maj_nums = $scales->array_for('Major (Ionian)');
isa_ok $maj_nums, 'Array::Circular', "Got the circular representation of the scale note numbers";

done_testing;

