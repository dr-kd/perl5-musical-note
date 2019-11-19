#!/usr/bin/env perl
use warnings;
use strict;
use Test::More;
use Musical::Scale;
use Test::Exception;

my $name = 'Major (Ionian)';
my $data = {
            'interval_nums' =>  [ 2, 2, 1, 2, 2, 2, 1 ],
            'interval_names' => [ 'W', 'W', 'H', 'W', 'W', 'W', 'H' ],
            'name' => 'Major (Ionian)',
            'note_nums' => [ 0, 4, 2, 5, 7, 9, 11 ],
        };

my $from_name = new_ok ( 'Musical::Scale', [$name], "constructed from scale name");
my $from_data_hashref = new_ok ( 'Musical::Scale', [ $data ], "constructed from hashref");
my $from_data_hash    = new_ok ( 'Musical::Scale', [ %$data], "constructed from hash");

dies_ok { Musical::Scale->new() } "required arguments to MNS are required";

my @n = qw/C D E F G A B C/;

subtest 'ascending internal api' => sub {
    foreach my $i ( 0 .. @{$from_name->intervals}) {
        is $from_name->current_note->step, $n[$i], "Note is $n[$i]";
        my $iv = $from_name->intervals->current;
        $from_name->_note_for($iv);

ssh ffx        $from_name->intervals->next;
        # reset to start
    }
};

subtest 'ascending public api' => sub {
    $from_name->note_and_previous;
    foreach my $i ( 0 .. @{$from_name->intervals}) {
        is $from_name->current_note->step, $n[$i], "Note is $n[$i]";
        $from_name->note_and_next;
    }
};

subtest 'descending' => sub {
    my @rn = reverse @n;

    # Some setup to ensure we are at the beginning of the scale
    my $iv = - $from_name->intervals->previous;
    $from_name->_note_for($iv);
    $from_name->intervals->previous;

    # then the actual test
    foreach my $i ( 0 .. @{$from_name->intervals} ) {
        is $from_name->current_note->step, $rn[$i], "Note is $rn[$i]";
        my $iv = - $from_name->intervals->current;
        $from_name->_note_for( $iv);
        $from_name->intervals->previous;
    }
};

# So ascending and decending are done and working.
## But it's horrible.  Make a coherent interface into Musical::Scale


# then ...

# As MIDI notes.

## simple version:  one note per entry in scale.  does not respect octabeves when looping around array

## More complicated:  same, does respect octaves so current note is a function of the octave


done_testing;
