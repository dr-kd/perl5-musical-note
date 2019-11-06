use strict;
use warnings;
package Musical::Note;

# ABSTRACT: Representation of musical note for midinum and iso and pluggable back ends

use Moo;
use Scalar::Util qw/looks_like_number/;
use Array::Circular;
use Carp;
use Storable qw/dclone/;
sub clone { return dclone($_[0])}

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

    my $o = $n->alter(1); # C#4
    my $p = $o->en_eq('b');
    my $p = $o->en_eq('bb');
    my $p = $o->en_eq('#');
    my $p = $o->en_eq('x');
    my $p = $o->en_eq('##');

=cut


around BUILDARGS => sub {
    my ($orig, $class, @args) = @_;
    if (@args == 1 && ! ref $args[0]) {
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

sub BUILD {
    my ($self, @args) = @_;
    $self->_scale->loops($self->octave);
}

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

has  _enh => (
    is => 'lazy',
    default => sub {
        [ { '1'  => { name => 'B#',  'alter' => 1,  'step'  => 'B', octave => -1 },
            '-2' => { name => 'Dbb', 'alter' => -2, 'step' => 'D' },
            '0'  => { name => 'C',   'alter' => 0,  'step' => 'C' } },
          { '2'  => { name => 'Bx',  'alter' => 2,  'step' => 'B', octave => -1 },
            '-1' => { name => 'Db',  'alter' => -1, 'step' => 'D', },
            '1'  => { name => 'C#',  'alter' => 1,  'step' => 'C' } },
          { '2'  => { name => 'Cx',  'alter' => 2,  'step' => 'C', },
            '0'  => { name => 'D',   'alter' => 0,  'step' => 'D',  },
            '-2' => { name => 'Ebb', 'alter' => -2, 'step' => 'E' } },
          { '-2' => { name => 'Fbb', 'alter' => -2, 'step' => 'F' },
            '-1' => { name => 'Eb',  'alter' => -1, 'step' => 'E',  },
            '1'  => { name => 'D#',  'alter' => 1,  'step' => 'D',  } },
          { '0'  => { name => 'E',   'alter' => 0,  'step' => 'E', },
            '2'  => { name => 'Dx',  'alter' => 2,  'step' => 'D' },
            '-1' => { name => 'Fb',  'alter' => -1, 'step' => 'F' } },
          { '0'  => { name => 'F',   'alter' => 0,  'step' => 'F' },
            '-2' => { name => 'Gbb',  'alter' => -2, 'step' => 'G', },
            '1'  => { name => 'E#',  'alter' => 1,  'step' => 'E',  } },
          { '1'  => { name => 'F#',  'alter' => 1,  'step' => 'F' },
            '-1' => { name => 'Gb',  'alter' => -1, 'step' => 'G' },
            '2'  => { name => 'Ex',  'alter' => 2,  'step' => 'E', } },
          { '0'  => { name => 'G',   'alter' => 0,  'step' => 'G' },
            '2'  => { name => 'Fx',  'alter' => 2,  'step' => 'F' },
            '-2' => { name => 'Abb', 'alter' => -2, 'step' => 'A',  } },
          { '-1' => { name => 'Ab',  'alter' => -1, 'step' => 'A' },
            '1'  => { name => 'G#',  'alter' => 1,  'step' => 'G' } },
          { '-2' => { name => 'Bbb', 'alter' => -2, 'step' => 'B' },
            '0'  => { name => 'A',   'alter' => 0,  'step' => 'A' },
            '2'  => { name => 'Gx',  'alter' => 2,  'step' => 'G' } },
          { '1'  => { name => 'A#',  'alter' => 1,  'step' => 'A',  },
            '-1' => { name => 'Bb',  'alter' => -1, 'step' => 'B',  },
            '-2' => { name => 'Cbb', 'alter' => -2, 'step' => 'C', octave => 1, } },
          { '-1' => { name => 'Cb',  'alter' => -1, 'step' => 'C', octave => 1 },
            '2'  => { name => 'Ax',  'alter' => 2,  'step' => 'A' },
            '0'  => { name => 'B',   'alter' => 0,  'step' => 'B',} },
      ];
    }
);

has _scale_idx => (
    is => 'lazy',
    default => sub {
        my ($self) = @_;
        my @scale = @{$self->_scale};
        my %id = ();
        my $i = 0;
        for my $e (@{$self->_enh}) {
            $id{$_->{name}} = $i for values %$e;
            $i++;
        }
        return \%id;
    },
);

has midinum => (
    is => 'lazy',
    default => sub {
        my ($self) = @_;
        my $scale = $self->_scale;
        my $o = $scale->loops + 1;
        my $m = $o * 12 + $self->_scale_idx->{$self->isobase};
        $m = $m + 12 if $m < 0; # for enharmonic equivalents in octave -2

        return $m;
    }
);

has step => (
    is => 'lazy',
    default => sub {
        my ($self) = @_;
        my $idx = $self->midinum % scalar @{$self->_scale};
        my $s = (split('', $self->_scale->[$idx]))[0];
        $self->_scale->index( int ( ( $self->midinum / 12 ) + $self->alter  ) );
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
             1 => '#',
             2 => 'x',
             0 => '',
            -1 => 'b',
            -2 => 'bb',
        );
        $a =  $acc{$self->alter};
        return $self->step . $a;
    }
);

sub en_eq {
    my ($self, $type) = @_;
    return $self->clone if ! $type;

    $type = 'x' if $type eq '##';
    $type = 'n' if $type =~ /^n/i;
    my $emap = {
        '#' => 1,
        'bb' => -1,
        'x' => 2,
        'n' => [0], # return all enharmonics for this note
    };

    my $group = $self->_enh->[ $self->_scale->index ];
    my $args = $group->{$emap->{$type}};
    my $class = ref($self);
    return $class->new($args);
}

sub new_en_eq {
    my ($self, $e) = @_;
    my ($init) = grep { $_->{name} eq $e }
        values %{ $self->_enh->[ $self->_scale->index] };
    if (! $init) {
        warn "No enharmonic equivalent for '$e' found.  Returning cloned note\n";
        return $self->clone;
    }
    my $class = ref $self;
    my $octave = $self->octave;
    $init->{octave} = $self->octave;
    return $class->new($init);
}

1;
