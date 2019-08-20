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

=head1 NOTES

constructor

# hashref => { step => '', octave => I, alter => I }
# iso => { note => 'c#4' }
# musicxml => { note => '<step>C</step><octave>4</octave><alter>-1</alter>'
# midinum  => { note => 61 } # c#4
# kern => { note => 'c#' } # c#4

=cut



my %midi_cache = (
    '21' => { 'alter' => 0,                  'iso' => 'A0',  'midinum' => 21, 'octave' => 0, 'step' => 'A' },
    '22' => { 'alter' => 1, 'flat' => 'Bb0', 'iso' => 'A#0', 'midinum' => 22, 'octave' => 0, 'step' => 'A' },
    '23' => { 'alter' => 0,                  'iso' => 'B0',  'midinum' => 23, 'octave' => 0, 'step' => 'B' },
    '24' => { 'alter' => 0,                  'iso' => 'C1',  'midinum' => 24, 'octave' => 1, 'step' => 'C' },
    '25' => { 'alter' => 1, 'flat' => 'Db1', 'iso' => 'C#1', 'midinum' => 25, 'octave' => 1, 'step' => 'C' },
    '26' => { 'alter' => 0,                  'iso' => 'D1',  'midinum' => 26, 'octave' => 1, 'step' => 'D' },
    '27' => { 'alter' => 1, 'flat' => 'Eb1', 'iso' => 'D#1', 'midinum' => 27, 'octave' => 1, 'step' => 'D' },
    '28' => { 'alter' => 0,                  'iso' => 'E1',  'midinum' => 28, 'octave' => 1, 'step' => 'E' },
    '29' => { 'alter' => 0,                  'iso' => 'F1',  'midinum' => 29, 'octave' => 1, 'step' => 'F' },
    '30' => { 'alter' => 1, 'flat' => 'Gb1', 'iso' => 'F#1', 'midinum' => 30, 'octave' => 1, 'step' => 'F' },
    '31' => { 'alter' => 0,                  'iso' => 'G1',  'midinum' => 31, 'octave' => 1, 'step' => 'G' },
    '32' => { 'alter' => 1, 'flat' => 'Ab1', 'iso' => 'G#1', 'midinum' => 32, 'octave' => 1, 'step' => 'G' },
    '33' => { 'alter' => 0,                  'iso' => 'A1',  'midinum' => 33, 'octave' => 1, 'step' => 'A' },
);

sub _midi_cache {
    return %midi_cache;
}

# Key by iso
my %iso_cache = map { $midi_cache{$_}->{iso} => $midi_cache{$_} } keys %midi_cache;

# But also key by enharmonic equivalents
foreach my $k (keys %iso_cache) {
    next unless $iso_cache{$k}->{flat};
    my $flat = $iso_cache{$k}->{flat};
    $iso_cache{$flat} = { %{$iso_cache{$k}} }; # clone
    $iso_cache{$flat}->{alter} = 0 - $iso_cache{$flat}->{alter};
    $iso_cache{$flat}->{step} = chr( ord ($iso_cache{$flat}->{step}) -1 );
    $iso_cache{$flat}->{step} = 'G' if $iso_cache{$flat}->{step} eq '@';
}

sub _iso_cache {
    return %iso_cache;
}

## Plugins here ... maybe range too

# sub import {
#     my ($class, @args) = @_;
#     # load plugins here.
# }


=head2 SKETCH

    use Music:Note;
    my $c = Musical::Note;
    my $n = $c->new( step => 'C' ) # default octave 4, default alter 0
    $n = $c->new( midinum => 60 ) # must look like number.  must be between 0 and 127 - C-1 to G9
    $n = $c->new( iso => 'C' ) # or any of the below

    ## maybe
    $n = $c->new('C') # C4 - case insensitive
    $n = $c->new('C#') # C#4
    $n = $c->new('C#4') # C4
    $n = $c->new(60); # C4 from midinum

    $n->format(); # iso
    $n->format('midinum');
    $n->format('iso');
    $n->format('isobase');

maybe ...

    use Music::Note qw(Range Kern MusicXML);
    $c->new('cc- 

Overriding in plugins:

    around BUILDARGS => sub {
        my ($orig, $class, @args) = @_;
        my @new = ... # coerce your plugin to return iso, midinum or best step/octave/alter hashref here
        return $class->$orig(@new)
    };

=cut

around BUILDARGS => sub {
    my ($orig, $class, @args) = @_;
    my %args = ref ($args[0]) eq 'HASH' ? %{$args[0]} : @args;
    %args = ( midinum => 60 ) if ! %args; # default to C4
    my @required = qw/iso midinum step/;
    my @got = grep { exists $args{$_} } @required;
    croak "Only one of @required can be passed through to $class->new" if @got > 1 ;

    my $coerce_method = "coerce_from_$got[0]";
    my $new = $class->$coerce_method(%args);
    return $new;
    # iso
    # midinum
    # step, maybe octave, maybe alter
};

my %alter_map = (
    '#'  =>  1,
    'b'  => -1,
    'x'  =>  2,
    'bb' => -2,
);

sub coerce_from_iso {
    my ($class, %args) = @_;
    my @elem = split '', delete $args{iso};
    $args{step} = shift @elem;
    if (! @elem) {
        $args{octave} = 4;
        $args{alter} = 0;
    }
    else {
        my $next = shift @elem;

        if (looks_like_number $next ) {
            # either #, b, x or num.
            $args{octave} = $next;
            $args{alter} = 0;
        }
        elsif (@elem == 1) {
            my $final =  $elem[0];
            if (looks_like_num $final) {
                $args{alter} = $alter_map{$next} or croak "Invalid alter supplied: $next";
                $args{octave} = $final;
            }
            else {
                $args{alter} = $alter_map{bb};
                $args{octave} = 4;
            }
        }
        elsif (@elem == 2) {
              my $final = pop @elem;
              ## YOU ARE HERE.
          }
    }
    return \%args;
}

sub coerce_from_midinum {
    my ($class, %args) = @_;
}

sub coerce_from_step {
    my ($class, %args) = @_;
    $args{octave} ||= 4;
    $args{alter} ||= 0;
    return \%args;
}

has 'step' => (
    is => 'lazy',
    builder => sub {
    }
);

has 'octave' => (
    is => 'lazy',
    builder => sub {
    }
);

has 'alter' => (
    is => 'lazy',
    builder => sub {
    }
);

has midinum => (
    is => 'lazy',
    builder => sub {
    }
);

1;
