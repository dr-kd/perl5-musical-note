#!/usr/bin/env perl
use warnings;
use strict;
use Scalar::Util qw/looks_like_number/;
use Test::More;

my %test = (
    'c4'   => { step => 'c', alter => 0,  octave => 4 },
    'c#4'  => { step => 'c', alter => 1,  octave => 4 },
    'cx4'  => { step => 'c', alter => 2,  octave => 4 },
    'cb4'  => { step => 'c', alter => -1, octave => 4 },
    'cbb4' => { step => 'c', alter => -2, octave => 4 },
    'c-1'   => { step => 'c', alter => 0,  octave => -1 },
    'c#-1'  => { step => 'c', alter => 1,  octave => -1 },
    'cx-1'  => { step => 'c', alter => 2,  octave => -1 },
    'cb-1'  => { step => 'c', alter => -1, octave => -1 },
    'cbb-1' => { step => 'c', alter => -2, octave => -1 },

);

foreach my $t (keys %test) {
    my $r = parse_iso($t);
    is_deeply ($r, $test{$t}, "$t ok");
}
done_testing;

sub parse_iso {
    my ($t) = @_;
    $DB::single=1;
    my ($step, @tokens) = split '', $t;

    my ($alter, $octave);

    my $get_octave = sub {
        my $o = shift @tokens;
        if ($o eq '-') {
            $o .= shift @tokens;
            $o += 0;
        }
        return $o;
    };

    my $next = $tokens[0];
    if (looks_like_number($next) || $next eq '-' ) {
        $alter = 0;
        $octave = $get_octave->();
        return { step => $step, octave => $octave, alter => $alter };
    }

    my $p = {
        'b' => sub {
            $next = shift @tokens;
            my $peek = $tokens[0];
            if ($peek eq 'b') {
                $alter = -2;
                shift @tokens;
            }
            else {
                $alter = -1;
            }
            $octave = $get_octave->();
            return { step => $step, octave => $octave, alter => $alter };
        },
        '#' => sub {
            $next = shift @tokens;
            $octave = $get_octave->();
            return { step => $step, octave => $octave, alter => 1 };
        },
        'x' => sub {
            $next = shift @tokens;
            $octave = $get_octave->();
            return { step => $step, octave => $octave, alter => 2 };
        },
    };

    return $p->{$next}->();
}
