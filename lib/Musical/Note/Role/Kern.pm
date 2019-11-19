package Musical::Note::Role::Kern;
use Moo::Role;
use Music::Note;

sub kern {
    my ($self) = @_;
    my $s = $self->step;
    my $o = $self->octave - 4;
    $DB::single=1;
    if ($o >= 0) {$s = lc($s);}
    else {$o = -(++$o);}
    my %kernfs = (-3,'---',-2,'--',-1,'-',0,'',1,'#',2,'##',3,'###');
    $s.($s x $o).$kernfs{$self->{alter}};
    return $s;
}

1;
