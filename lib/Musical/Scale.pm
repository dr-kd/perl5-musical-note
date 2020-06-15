package Musical::Scale;
use Moo;
use Musical::Scale::List;
use Musical::Note qw/lilypond/;
use List::Util;
use Carp;
use Array::Circular;

use Moo;

has _scales => (
    is => 'lazy',
    default => sub {
        return Musical::Scale::List->new;
    }
);


has root => (
    is => 'ro',
    required => 1,
    coerce => sub {
        my ($r) = @_;
        return $r if ref $r && $r->isa('Musical::Note');
        return Musical::Note->new($r);
    }
);

has current => (
    is => 'rwp',
    default => sub {
    },
);

has mode => (
    is => 'ro',
    default => 'Major'
);

has intervals => (
    is => 'lazy',
    default => sub {
        my ($self) = @_;
        return $self->_scales->scale_for($self->mode)->{interval_nums};
    },
);

has octaves => (
    is => 'ro',
    default => 1
);

sub up {
    my ($self) = @_;
    $self->_set_current($self->root) unless $self->current;
    my $c = $self->current;
    my $n = $self->current->transpose( $self->intervals->current_and_next);
    $self->_set_current($n);
    return $c;
}

sub down {
    my ($self) = @_;
    $self->_set_current($self->root) unless $self->current;
    my $c = $self->current;
    my $n = $self->current->transpose( 0 - $self->intervals->current_and_next);
    $self->_set_current($n);
    return $self->current;
}



1;


