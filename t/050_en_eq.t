#!/usr/bin/env perl
use warnings;
use strict;
use Musical::Note;
use Test::More;

my $base = Musical::Note->new(60);

my @notes = @{$base->_scale};
my %notes_idx = %{$base->_scale_idx};

my $c = 0;
for my $oct (-1 .. 9) {
    subtest "octave $oct" => sub {
        for my $note (@notes) {
            last if $c > 127;
            my $note = Musical::Note->new($c);
            subtest "enharmonic equivs for " . $note->iso => sub {
                is ( $note->iso, $notes[$c % 12] . $oct, "sanity check for note $c: " . $note->iso);
                my $new;
                my @enh = map { $_->{name} } values %{ $base->_enh->[$c % 12]};
                for my $e (@enh) {
                    diag "Eq is $e";
                    my (undef, $enh) = split ('', $e, 2);
                    my $new = $note->new_en_eq($e);
                    is $new->midinum, $c, $new->iso . " is midinum $c";
                }
            };
            $c++;
        }
    };
}

done_testing;
