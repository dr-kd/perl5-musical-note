package Musical::Note::Role::Lilypond;
use warnings;
use strict;
use Moo::Role;

sub _llp_map {
    return {
          '-1'=> q|,| x 4,
            0 => q|,| x 3,
            1 => q|,| x 2,
            2 => q|,| x 1,
            3 => q||     ,
            4 => q|'| x 1,
            5 => q|'| x 2,
            6 => q|'| x 3,
            7 => q|'| x 4,
            8 => q|'| x 8,
            9 => q|'| x 9,
        };
}

sub lilypond {
    my ($self) = @_;
    my $step = lc $self->step;
    my $octave = $self->_llp_map->{$self->octave};
    return $step . $self->_alter . $octave;
};

sub _alter {
    my ($self) = @_;
    return '' unless $self->alter;
    my $map = {
        '0' => '',
        '1' => 'is',
        '2' => 'isis',
        '-1' => 'es',
        '-2' => 'eses',
    };
    my $a = $self->alter;
    $a ||=0;
    return $map->{ $self->alter };
}

sub lilypond_relative {
    return lc($_[0]->step) . $_[0]->_alter;
}

sub format_up_octave {
    my ($self, $n) = @_;
    $n ||=1;
    return $_[0]->step . q|'| x $n;
}

sub format_down_octave {
    my ($self, $n) = @_;
    $n ||=1;
    return $_[0]->step . q|,| x $n;
}

1;
