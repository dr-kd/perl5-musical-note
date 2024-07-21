#!/usr/bin/env perl
use Test::More;
use Music::Theory::Note qw/Kern/;

my %map = (
    C0 => 'CCCCC', C1 => 'CCCC', C2 => 'CCC', C3 => 'CC', C4 => 'C',
    C8 => 'ccccc', C7 => 'cccc', C6 => 'ccc', C5 => 'cc', C4 => 'c',
);

for (sort keys %map ) {
    my $n = Music::Theory::Note->new($_);
    is $n->kern, $map{$_}, "$_ kern renders correctly"
}


done_testing;





