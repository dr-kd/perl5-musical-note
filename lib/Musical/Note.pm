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
    ucfirst ($t);
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
        my @scale = ('C', 'C#', 'D', 'D#', 'E', 'F',  'F#', 'G',  'G#',  'A',  'A#',  'B');
        my $scale = Array::Circular->new(@scale);
        return $scale;
    }
);

has _scale_idx => (
    is => 'lazy',
    default => sub {
        my ($self) = @_;
        my @scale = @{$self->_scale};
        my %scale = map { $scale[$_] => $_ } 0 .. $#scale;
        my %enh = (
            0 =>  ['Dbb', 'B#',],
            1 =>  ['Db', 'Bx', ],
            2 =>  ['Cx', 'Ebb',],
            3 =>  ['Eb', 'Fbb',],
            4 =>  ['Dx', 'Fb', ],
            5 =>  ['E#', 'Gbb',],
            6 =>  ['Gb', 'Ex', ],
            7 =>  ['Fx', 'Abb',],
            8 =>  ['Ab',       ],
            9 =>  ['Gx', 'Bbb',],
            10 => ['Bb', 'Cbb',],
            11 => ['Ax', 'Cb', ],
        );
        foreach my $e (keys %enh) {
            $scale{$_} = $e for @{$enh{$e}};
        }
        return \%scale;
    },
);

has midinum => (
    is => 'lazy',
    default => sub {
        my ($self) = @_;
        my $scale = $self->_scale;
        my $o = $self->octave +1;
        my $m = $o * 12 + $self->_scale_idx->{$self->isobase};
        return $m;
    }
);

has step => (
    is => 'lazy',
    default => sub {
        my ($self) = @_;
        my $idx = $self->midinum % scalar @{$self->_scale};
        my $s = (split('', $self->_scale->[$idx]))[0];
        $self->_scale->index( int ( $self->midinum / 12 ) );
        return $s;
    }
);

has alter => (
    is => 'lazy',
    default => sub {
        my ($self) = @_;
        my $idx = $self->midinum % 12;
        my ($n, $alter) = split ('', $self->_scale->[$idx], 2);
        my %alter_map = (
            '#' => 1,
            'x' => 2,
            'b' => -1,
            'bb' => -2,
        );
        return $alter ? $alter_map{$alter} : 0;
    },
);

has octave => (
    is => 'lazy',
    default => sub {
        my ($self) = @_;
        my $o = int ( $self->midinum / 12 ) - 1;
        $self->_scale->loops($o);
        return $o;
    },
);

has iso => (
    is => 'lazy',
    default => sub {
        my ($self) = @_;
        return $self->isobase . $self->octave;
    }
);

has isobase => (
    is => 'lazy',
    default => sub {
        my ($self) = @_;
        my $a;
        my %acc = (
            1 => sub { '#' },
            2 => sub { 'x' },
            0 => sub { '' },
            -1 => sub { 'b'},
            -2 => sub { 'bb'},
        );
        $a =  $acc{$self->alter}->();
        return $self->step . $a;
    }
);

1;
