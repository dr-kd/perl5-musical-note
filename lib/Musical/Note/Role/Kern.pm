package Musical::Note::Role::Kern;
use Moo::Role;
use Music::Note;

sub kern {
    my ($self) = @_;
    my $s = $self->step;
    my $o = $self->octave - 4;
    $o-- if $o < 0; # otherwise we get an off by one error below middle c
    if ($o >= 0) {$s = lc($s);}
    else {$o = -(++$o);}
    my %kernfs = (-3,'---',-2,'--',-1,'-',0,'',1,'#',2,'##',3,'###');

    $s = $s.($s x $o).$kernfs{$self->{alter}};
    return $s;
}

1;
