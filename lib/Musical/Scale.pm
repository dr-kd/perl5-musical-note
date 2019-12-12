package Musical::Scale;
use Moo;
use Musical::Scale::List;
use Musical::Note qw/lilypond/;
use List::Util;
use Carp;
use Array::Circular;

around BUILDARGS => sub {
    my ($orig, $class, @args) = @_;
    my @fixed_args;
    my %info;

    # hashref it's already been looked up, pass it through.
    # bit more thought required here :)

    # single string, or a hash
    if ( ! ref $args[0] ) {
        # - string it's a name look it up.
        if (@args == 1 && ! ref $args[0]) {
            %info  = %{ Musical::Scale::List->new->scale_for($args[0]) };
        }
        else {
            %info = @args;
        }
    }
    else { # hashref constructor
        %info = %{ $args[0] };
    }
    
    my $default = List::Util::any { exists $info{$_} }
        qw/interval_nums interval_names note_nums/;

    # "At least one of 'interval_nums', 'interval_names' or 'note_nums'
    # must be supplied to constructor"

    return $class->$orig(\%info);
};

has name => (
    is => 'ro',
    required => 0,
);

has interval_nums => (
    is => 'ro',
    required => 0,
);

has note_nums => (
    is => 'ro',
    required => 0
);

has interval_names => (
    is => 'ro',
    required => 0
);

has start_octave => (
    is => 'lazy',
    default => sub { 4 }
);

has key => (
    is => 'lazy',
    default => sub { 'C' },
);

has intervals => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my $i =  Array::Circular->new(@{$_[0]->interval_nums});
        $i->loops($_[0]->start_octave);
        return $i;
    }
);

has scale => (
    is => 'ro',
    lazy => 1,
    default => sub {
        my ($self) = @_;
        my @scale;
        my $iv = $self->intervals;
        my $note = Musical::Note->new($self->key . $self->start_octave);
        push @scale, $note;
        for ( 1 .. @{$self->intervals} ) {
            $note = $note->transpose($self->intervals->current);
            $self->intervals->next;
            push @scale, $note;
        }
        my $scale = Array::Circular->new(@scale);
        $DB::single = 1;
        return $scale;
    }
);


has current_note => (
    is => 'rw',
    default => sub {
        my ($self) = @_;
        my $name = $self->key . $self->start_octave;
        return Musical::Note->new($name);
    }
);

sub next_note {
    my ($self, $steps) = @_;
    $steps ||= 1;
    my $interval = 0;
    $interval += $self->intervals->next for ( 1 .. $steps);
    my $note = $self->_note_for($interval);
    return $note;
}

sub prev_note {
    my ($self, $steps) = @_;
    $steps ||= 1;
    my $interval = 0;
    $interval -= $self->intervals->previous for ( 1 .. $steps);
    my $note = $self->_note_for($interval);
    return $note;
}

*previous_note = \&prev_note;

sub _note_for {
    my ($self, $interval) = @_;
    my $new = $self->current_note->transpose($interval);
    return $new;
}

sub _current_and_step {
    my ($self, $interval, $steps) = @_;
    $steps ||= 1;
    my $current = $self->current_note;
    my $new = $self->_note_for($interval);
    my $direction;
    if ($interval > 0) {
        $direction = 'next';
    }
    elsif ($interval < 0) {
        $direction = 'previous';
    }
    if ($direction) {
        $self->intervals->$direction for 1 .. $steps;
    }
    return $new;
}

sub _calc_interval {
    my ($self, $steps, $dir) = @_;
    my $other_dir = $dir eq 'next' ? 'previous' : 'next';
    my $interval = 0;
    $interval = $interval + $self->intervals->$dir for 1 .. $steps;
    $self->intervals->$other_dir for 1 .. $steps; # reset back to where we were
    $interval = - $interval if $dir eq 'previous';
    return $interval;
}
sub note_and_next {
    my ($self, $steps) = @_;
    $steps ||=1;
    my $interval = $self->_calc_interval($steps, 'next');
    return $self->_current_and_step($interval, $steps);
}

sub note_and_previous {
    my ($self, $steps) = @_;
    $steps ||=1;
    my $interval = $self->_calc_interval($steps, 'previous');
    return $self->_current_and_step($interval, $steps);
}

1;
