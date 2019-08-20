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
