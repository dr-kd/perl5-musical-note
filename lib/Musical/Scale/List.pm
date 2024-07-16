package Musical::Scale::List;

use Moo;
use List::Util qw(any first);
use Carp qw(carp);
use Array::Circular ();

=head1 NAME

Musical::Scale::List

=head1 DESCRIPTION

This package contains representations of various scales.

=head2 ATTRIBUTES

=head3 available_scales

Convienence attribute for returning the names of all the scales we
currently know about.

=cut

our %scales = (
    'Major (Ionian)'                   => [qw( 0 2 4 5 7 9 11 )],
    'Minor (Dorian)'                   => [qw( 0 2 3 5 7 9 10 )],
    'Phyrigian'                        => [qw( 0 1 3 5 7 8 10 )],
    'Lydian'                           => [qw( 0 2 4 6 7 9 11 )],
    'Dominant 7th (Myxolydian)'        => [qw( 0 2 4 5 7 9 10 )],
    'Natural minor (Aeolian)'          => [qw( 0 2 3 5 7 8 10 )],
    'Locrian'                          => [qw( 0 1 3 5 6 8 10 )],
    'Lydian augmented'                 => [qw( 0 2 4 6 8 9 11 )],
    'Lydian dominant'                  => [qw( 0 2 4 6 7 9 10 )],
    'Half diminished 2'                => [qw( 0 2 3 5 6 8 10 )],
    'Diminished (W-H)'                 => [qw( 0 2 3 5 6 8 9 11 )],
    'Diminished (H-W)'                 => [qw( 0 1 3 4 6 7 9 10 )],
    'Dimished whole tone'              => [qw( 0 1 3 4 6 8 10 )],
    'Half diminished'                  => [qw( 0 1 3 5 6 8 10 )],
    'Harmonic'                         => [qw( 0 2 3 5 7 8 11 )],
    'Harmonic major'                   => [qw( 0 2 4 5 7 8 11 )],
    'Harmonic minor'                   => [qw( 0 2 3 5 7 8 11 )],
    'Neapolitan major'                 => [qw( 0 1 3 5 7 9 11 )],
    'Neapolitan minor'                 => [qw( 0 1 3 5 7 8 11 )],
    'Dominant 7'                       => [qw( 0 2 5 7 9 10 )],
    'Hungarian minor'                  => [qw( 0 2 3 6 7 8 11 )],
    'Hindu'                            => [qw( 0 2 4 5 7 8 10 )],
    'Todi (Indian)'                    => [qw( 0 1 3 6 7 8 11 )],
    'Marva (Indian)'                   => [qw( 0 1 4 6 7 9 11 )],
    'Persian'                          => [qw( 0 1 4 5 6 8 11 )],
    'Oriental'                         => [qw( 0 1 4 5 6 9 10 )],
    'Romanian'                         => [qw( 0 2 3 6 7 9 10 )],
    'Pelog (Balinese)'                 => [qw( 0 1 3 7 10 )],
    'Iwato (Japanese)'                 => [qw( 0 1 5 6 10 )],
    'Hirajoshi (Japanese)'             => [qw( 0 2 3 7 8 )],
    'Egyptian'                         => [qw( 0 2 5 7 10 )],
    'Major pentatonic'                 => [qw( 0 2 4 7 9 )],
    'Minor pentatonic'                 => [qw( 0 3 5 7 10 )],
    '3 semitone (diminished arpeggio)' => [qw( 0 3 6 9 )],
    '4 semitone (augmented arpeggio)'  => [qw( 0 4 8 )],
    'Chromatic'                        => [qw( 0 1 2 3 4 5 6 7 8 9 10 11 )],
);

has available_scales => (
    is      => 'ro',
    default => sub { return [ sort keys %scales ] },
);

=head3 all_scales

Attribute for providing a data structure which is a representation of all
the scales we currently know about.

=cut

has all_scales => ( is => 'lazy' );

sub _build_all_scales {
    my ($self) = @_;
    my @all_scales;
    for my $name (keys %scales) {
        my $scale     = $scales{$name};
        my @intervals = $self->get_intervals([ @$scale, 12 ]);
        my @steps     = map { $_ == 1 ? 'H' : $_ == 2 ? 'W' : '3' } @intervals;
        my $item = {
            name           => $name,
            note_nums      => Array::Circular->new(@$scale),
            interval_nums  => Array::Circular->new(@intervals),
            interval_names => Array::Circular->new(@steps),
        };
        push @all_scales, $item;
    }
    return \@all_scales;
}

=head2 METHODS

=head3 scale_for

    my $maj = Music::Notes::Scales->new->scale_for('Major (Ionian)');

Given a scale name, as provided by C<available_scales>, return the raw
representation of that scale.

=cut

sub scale_for {
    my ($self, $name) = @_;
    carp "Must provide scale name" unless $name;
    my $scale = List::Util::first { $_->{name} =~ /^ $name /x } @{ $self->all_scales };
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
nmbers for the scale (e.g. major scale is C<qw/0 2 4 5 7 9 11/>).

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

=head3 get_intervals(\@numbers)

    my $intervals = $scales->get_intervals(\@numbers);

Given a list of numbers, compute the intervals between successive
members.

=cut

sub get_intervals {
    my ($self, $nums) = @_;
    my $last;
    my @intervals;
    for my $x (@$nums) {
        push @intervals, $x - $last
            if defined $last;
        $last = $x;
    }
    return \@intervals;
}

=head1 CONTRIBUTORS

Gene Boggs (L<https://metacpan.org/author/GENE>)

=head1 AUTHOR COPYRIGHT AND LICENSE

Copyright (c) 2024 Kieren Diment <zarquon@cpan.org>

This software can be redistributed under the same terms as perl itself.

=cut

1;
