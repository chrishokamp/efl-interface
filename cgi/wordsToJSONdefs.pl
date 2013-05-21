#!/usr/bin/perl

#takes a string as the query, and outputs the list of glosses from WordNet
#TODO: make into persistent server so that WordNet doesn't need to be reloaded every time

use strict;
use warnings;
use feature qw(say);
use JSON;
use Data::Dumper;

use queryWordNet;

open WORDS, '<', '../data/vocab.json';

my %examples = ();

while (my $l = <WORDS>) {
    my $decoded = decode_json($l);
    my $w = $decoded->{'word'}; 
    my $pos = $decoded->{'pos'}; 
    my $sens = &getDefinitions($w, $pos);
    #say "word: $w pos: $pos";
    my $i = 0;
    foreach my $s (@$sens) {
        say "\tDEF: $s";
        $examples{$w}{$pos}{$i} = $s;
        $i +=1;
    }
}

my $out = encode_json \%examples;
open OUT, '>', 'wordExamples.json';
say OUT $out;
close OUT;


