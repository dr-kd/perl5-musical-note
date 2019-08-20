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

=cut

my @scale = ('c', 'c#', 'd', 'd#', 'e', 'f',  'f#', 'g',  'g#',  'a',  'a#',  'b');

has scale => (
    is => 'ro',
    default => sub {
        my ($self) = @_;
        my $scale = Array::Circular->new(@scale);
        return $scale;
    }
);

has midinum => (
    is => 'lazy',
    default => sub {
        my ($self) = @_;
        $DB::single=1;
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
        $self->scale->loops( int ( $self->midinum / 12 ) );
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
