#!/usr/bin/env perl
# t/004_format.t - check output formats

use Test::More;
use Musical::Note;

my $note;

my %cons = (
    default => 'D#4',
    iso => 'D#4',
    midi => 'Ds4',
    midinum => 63,
    _isobase => 'D#',
    _kern => 'd#',
    pdl => 'ds4',
    xml => '<pitch><step>D</step><octave>4</octave><alter>1</alter></pitch>',
    hashref => { step => 'D', octave => 4, alter => 1 }
);

foreach my $n (keys %cons) {
    if ( $n =~ /^_/ ) {
        diag "Skipping $n as no way to round trip";
        next
    }
    subtest "testing round tripp $n" => sub {
        my $type = $n;
        $type = '' if $type eq 'default';
        $note = Musical::Note->new($cons{$n}, $type);
        is($note->format, 'D#4');
        is($note->format("iso"), 'D#4');
        is($note->format("midi"), 'Ds4');
        is($note->format("midinum"), 63);
        is($note->format("isobase"), 'D#');
        is($note->format("kern"), 'd#');
        is($note->format("pdl"), 'ds4');
        is($note->format("xml"), '<pitch><step>D</step><octave>4</octave><alter>1</alter></pitch>');
    };
}

subtest 'eb2' => sub {
    $note = Musical::Note->new("Eb2");

    is($note->format, 'Eb2');
    is($note->format("iso"), 'Eb2');
    is($note->format("midi"), 'Ef2');
    is($note->format("midinum"), 39);
    is($note->format("isobase"), 'Eb');
    is($note->format("kern"), 'EE-');
    is($note->format("pdl"), 'ef2');
    is($note->format("xml"), '<pitch><step>E</step><octave>2</octave><alter>-1</alter></pitch>');
};

done_testing;
