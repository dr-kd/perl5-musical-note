use strict;
use warnings;
package Musical::Note;
use Moo;
use Scalar::Util qw/looks_like_number/;
use Array::Circular;
use Carp;

=head1 NAME

Musical::Note

=head2 DESCRIPTION

Representiation of a musical note, based on the original L<Music:Note> but
with a more OO and pluggable interface.


=head2 SYNOPSIS

    my $n = Musical::Note->new('c4'); # case insensitive
    my $n = Musical::Note->new(c); # defaults to octave 4
    my $n = Musical::Note->new(step => c, alter => 0, octave => 4);
    my $n = Musical::Note->new(60) # midinum;
    my $n = Musical::Note->new(midinum => 60);

=cut

my @scale = ('c', 'c#', 'd', 'd#', 'e', 'f',  'f#', 'g',  'g#',  'a',  'a#',  'b');

around BUILDARGS => sub {
    my ($orig, $class, @args) = @_;
    if (@args == 1 && ! ref @args) {
        my $init = $args[0];
        if (looks_like_number $init) {
            return { midinum => $init };
        }
        elsif ( $init =~ /[a-g]/i) {
            return $class->_parse_iso($init);
        }
    }
    return $args[0] if ref $args[0] eq 'HASH';
    return +{ @args };
};

sub _parse_iso {
    my ($class, $t) = @_;
    uc $t;
    my ($step, @tokens) = split '', $t;
    if (! looks_like_number ($tokens[-1])) {
        push @tokens, 4;
    }
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

    
has _scale => (
    is => 'lazy',
    default => sub {
        my ($self) = @_;
        my $scale = Array::Circular->new(@scale);
        $scale->loops($self->octave);
        return $scale;
    }
);

has midinum => (
    is => 'lazy',
    default => sub {
        my ($self) = @_;
    }
);

has step => (
    is => 'lazy',
    default => sub {
        my ($self) = @_;
        my $idx = $self->midinum % scalar @$self;
    }
);

has alter => (
    is => 'lazy',
    default => sub {
        my ($self) = @_;
    },
);

has octave => (
    is => 'lazy',
    default => sub {
        my ($self) = @_;
        my $o = int ( $self->midinum / 12 ) - 1;
        $DB::single=1;
        $self->_scale->loops( int ( $self->midinum / 12 ) );
        return $o;
    },
);

has iso => (
    is => 'lazy',
    default => sub {
        my ($self) = @_;
        return '';
    }
);

1;
