package Musical::Scale::List;

use Moo;
use List::Util;
use Carp;
use Array::Circular;

=head1 NAME

Music::Notes::Scales

=head2 DESCRIPTION

This package contains a repository of representation of various scale
intervals.

=head2 ATTRIBUTES

=head3 available_scales

Convienence attribute for returning all of the scale we currently know
about, by the name of the scale

=cut

has available_scales => (
    is => 'lazy',
    default => sub {
        return [ map  { $_->{name} } @{$_[0]->all_scales} ];
    }
);

=head3 all_scales

Attribute for providing a data structure which is a representation of all
the scales we currently know about

=cut

has all_scales => (
    is => 'lazy',
    default => sub {
        [{
            'interval_nums' =>  Array::Circular->new( 2, 2, 1, 2, 2, 2, 1 ),
            'interval_names' => Array::Circular->new( 'W', 'W', 'H', 'W', 'W', 'W', 'H' ),
            'name' => 'Major (Ionian)',
            'note_nums' => Array::Circular->new( 0, 2, 4, 5, 7, 9, 11 ),
        },
         {
             'interval_nums' => Array::Circular->new( 2, 2, 1, 2, 2, 1, 2 ),
             'interval_names' => Array::Circular->new( 'W', 'W', 'H', 'W', 'W', 'H', 'W' ),
             'note_nums' => Array::Circular->new( 0, 2, 4, 5, 7, 9, 10 ),
             'name' => 'Dominant 7th (Myxolydian)'
         },
         {
             'interval_nums' => Array::Circular->new( 2, 1, 2, 2, 2, 1, 2 ),
             'interval_names' => Array::Circular->new( 'W', 'H', 'W', 'W', 'W', 'H', 'W' ),
             'name' => 'Minor (Dorian)',
             'note_nums' => Array::Circular->new( 0, 2, 3, 5, 7, 9, 10 )
         },
         {
             'interval_names' => Array::Circular->new( 'H', 'W', 'W', 'H', 'W', 'W', 'W' ),
             'interval_nums' => Array::Circular->new( 1, 2, 2, 1, 2, 2, 2 ),
             'note_nums' => Array::Circular->new( 0, 1, 3, 5, 6, 8, 10 ),
             'name' => 'Half-Diminished (Locrian)'
         },
         {
             'name' => 'Diminished (8 Tone)',
             'note_nums' => Array::Circular->new( 0, 2, 3, 5, 6, 8, 9, 11 ),
             'interval_names' => Array::Circular->new( 'W', 'H', 'W', 'H', 'W', 'H', 'W', 'H' ),
             'interval_nums' => Array::Circular->new( 2, 1, 2, 1, 2, 1, 2, 1 ) },
         {
             'name' => 'Lydian',
             'note_nums' => Array::Circular->new( 0, 2, 4, 6, 7, 9, 11 ),
             'interval_names' => Array::Circular->new( 'W', 'W', 'W', 'H', 'W', 'W', 'H' ),
             'interval_nums' => Array::Circular->new( 2, 2, 2, 1, 2, 2, 1 ),
         },
         {
             'note_nums' => Array::Circular->new( 0, 2, 4, 5, 7, 8, 11 ),
             'name' => 'Harmonic maj',
             'interval_nums' => Array::Circular->new( 2, 2, 1, 2, 1, 3, 1 ),
             'interval_names' => Array::Circular->new( 'W', 'W', 'H', 'W', 'H', 3, 'H' )
         },
         {
             'interval_nums' => Array::Circular->new( 2, 2, 2, 2, 1, 2, 1 ),
             'interval_names' => Array::Circular->new( 'W', 'W', 'W', 'W', 'H', 'W', 'H' ),
             'name' => 'Lydian aug',
             'note_nums' => Array::Circular->new( 0, 2, 4, 6, 8, 9, 11 )
         },
         {
             'interval_names' => Array::Circular->new( 3, 'H', 3, 'H', 3, 'H' ),
             'interval_nums' => Array::Circular->new( 3, 1, 3, 1, 3, 1 ),
             'note_nums' => Array::Circular->new( 0, 3, 4, 7, 8, 11 ),
             'name' => 'Aug'
         },
         {
             'interval_nums' => Array::Circular->new( 3, 2, 1, 1, 3, 2 ),
             'interval_names' => Array::Circular->new( 3, 'W', 'H', 'H', 3, 'W' ),
             'name' => 'Blues',
             'note_nums' => Array::Circular->new( 0, 3, 5, 6, 7, 10 )
         },
         {
             'note_nums' => Array::Circular->new( 0, 2, 4, 7, 9 ),
             'name' => 'Maj Pentatonic',
             'interval_names' => Array::Circular->new( 'W', 'W', 3, 'W', 3 ),
             'interval_nums' => [ 2, 2, 3, 2, 3 ] },
         {
             'interval_nums' => Array::Circular->new( 2, 2, 2, 1, 2, 1, 2 ),
             'interval_names' => Array::Circular->new( 'W', 'W', 'W', 'H', 'W', 'H', 'W' ),
             'name' => 'Lydian Dominant',
             'note_nums' => Array::Circular->new( 0, 2, 4, 6, 7, 9, 10 )
         },
         {
             'interval_nums' => Array::Circular->new( 2, 2, 1, 2, 1, 2, 2 ),
             'interval_names' => Array::Circular->new( 'W', 'W', 'H', 'W', 'H', 'W', 'W' ),
             'name' => 'Hindu',
             'note_nums' => Array::Circular->new( 0, 2, 4, 5, 7, 8, 10 ),
         },
         {
             'note_nums' => Array::Circular->new( 0, 2, 4, 6, 8, 10 ),
             'name' => 'Whole Tone',
             'interval_names' => Array::Circular->new( 'W', 'W', 'W', 'W', 'W', 'W' ),
             'interval_nums' => Array::Circular->new( 2, 2, 2, 2, 2, 2 ),
         },
         {
             'note_nums' => Array::Circular->new( 0, 1, 3, 4, 6, 7, 9, 10 ),
             'name' => 'Diminished',
             'interval_nums' => Array::Circular->new( 1, 2, 1, 2, 1, 2, 1, 2 ),
             'interval_names' => Array::Circular->new( 'H', 'W', 'H', 'W', 'H', 'W', 'H', 'W' )
         },
         {
             'interval_nums' => Array::Circular->new( 1, 2, 1, 2, 2, 2, 2 ),
             'interval_names' => Array::Circular->new( 'H', 'W', 'H', 'W', 'W', 'W', 'W' ),
             'name' => 'Dimished whole tone',
             'note_nums' => Array::Circular->new( 0, 1, 3, 4, 6, 8, 10 )
         },
         {
             'interval_nums' => Array::Circular->new( 2, 1, 2, 2, 2, 2, 1 ),
             'interval_names' => Array::Circular->new( 'W', 'H', 'W', 'W', 'W', 'W', 'H' ),
             'name' => 'Melodic minor',
             'note_nums' => Array::Circular->new( 0, 2, 3, 5, 7, 9, 11 )
         },
         {
             'name' => 'Minor pentatonic',
             'note_nums' => Array::Circular->new( 0, 3, 5, 7, 10 ),
             'interval_nums' => Array::Circular->new( 3, 2, 2, 3, 2 ),
             'interval_names' => Array::Circular->new( 3, 'W', 'W', 3, 'W' ) },
         {
             'name' => 'Harmonic',
             'note_nums' => Array::Circular->new( 0, 2, 3, 5, 7, 8, 11 ),
             'interval_nums' => Array::Circular->new( 2, 1, 2, 2, 1, 3, 1 ),
             'interval_names' => Array::Circular->new( 'W', 'H', 'W', 'W', 'H', 3, 'H' )
         },
         {
             'interval_nums' => Array::Circular->new( 1, 2, 2, 2, 1, 2, 2 ),
             'interval_names' => Array::Circular->new( 'H', 'W', 'W', 'W', 'H', 'W', 'W' ),
             'name' => 'Phyrigian',
             'note_nums' => Array::Circular->new( 0, 1, 3, 5, 7, 8, 10 )
         },
         {
             'note_nums' => Array::Circular->new( 0, 2, 3, 5, 7, 8, 10 ),
             'name' => 'Natural minor',
             'interval_nums' => Array::Circular->new( 2, 1, 2, 2, 1, 2, 2 ),
             'interval_names' => Array::Circular->new( 'W', 'H', 'W', 'W', 'H', 'W', 'W' )
         },
         {
             'name' => 'Half diminished',
             'note_nums' => Array::Circular->new( 0, 1, 3, 5, 6, 8, 10 ),
             'interval_names' => Array::Circular->new( 'H', 'W', 'W', 'H', 'W', 'W', 'W' ),
             'interval_nums' => Array::Circular->new( 1, 2, 2, 1, 2, 2, 2 ) },
         {
             'interval_names' => Array::Circular->new( 'W', 'H', 'W', 'H', 'W', 'W', 'W' ),
             'interval_nums' => Array::Circular->new( 2, 1, 2, 1, 2, 2, 2 ),
             'note_nums' => Array::Circular->new( 0, 2, 3, 5, 6, 8, 10 ),
             'name' => 'Half dim 2'
         },
         {
             'note_nums' => Array::Circular->new( 0, 2, 3, 5, 6, 8, 9, 11 ),
             'name' => 'Diminished 8',
             'interval_nums' => Array::Circular->new( 2, 1, 2, 1, 2, 1, 2, 1 ),
             'interval_names' => Array::Circular->new( 'W', 'H', 'W', 'H', 'W', 'H', 'W', 'H' )
         },
         {
             'interval_names' => Array::Circular->new( 'W', 3, 'W', 'W', 'H', 'W' ),
             'interval_nums' => Array::Circular->new( 2, 3, 2, 2, 1, 2 ),
             'note_nums' => Array::Circular->new( 0, 2, 5, 7, 9, 10 ),
             'name' => 'Dominant 7'
         }
     ]
    }
);

=head2 METHODS

=head3 scale_for

    my $maj = Music::Notes::Scales->new->scale_for('Major (Ionian)');

Given a scale name, as provided by C<available_scales>, return the raw
representation of that scale.

=cut

sub scale_for {
    my ($self, $name) = @_;
    carp "Must provide scale name" unless $name;
    my $scale = List::Util::first { $_->{name} =~ /^ $name /x } @{$self->all_scales};
    return $scale;
}

=head3 array_for($name, [ $data_mode ])

    my $scales = Music::Notes::Scales->new;
    my $name = 'Major (Ionian)';
    my $note_nums = $scales->array_for($name); # or ($name, 'note_nums')
    my $interval_nums = $scales->array_for($name, 'interval_nums');
    my $interval_names = $scales->array_for($name, 'interval_names');

Given the name of a scale and an optional data mode, will return an
L<Array::Circular> of the requested scale data.  Defaults to the note
nmbers for the scale (e.g. major scale is C<qw/0 2 4 5 7 9 11/>.



=cut

sub array_for {
    my ($self, $name, $data_mode) = @_;
    $data_mode ||= 'note_nums';
    die "$data_mode is invalid" unless
        List::Util::any { $_ eq $data_mode }
          qw/interval_names interval_nums note_nums/;
    my $scale = $self->scale_for($name);
    return Array::Circular->new($scale->{$data_mode});
}

1;
