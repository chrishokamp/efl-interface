#!/usr/bin/perl
#Author: Chris Hokamp
#Winter 2013
#cosine similarity for two vectors implemented as hashes

use strict;
use warnings;
use Data::Dumper;

sub cosSim {
    my ($vecRef1, $vecRef2) = @_;
    my $len = (&eucLen($vecRef1) * &eucLen($vecRef2));
    #print "len is $len\n";
    my $dp = &dotProduct($vecRef1, $vecRef2); 
    #print "dp is $dp\n";
    my $cos = $dp/$len;
    return $cos;
}

sub eucLen {
    my $vecRef = shift;
    my %vec = %$vecRef;
    my $sumSquares = 1;
    foreach my $key (keys %vec) {
        my $val = $vec{$key};
        my $sq = $val**2; 
        $sumSquares += $sq;
    }
    my $eucLen = sqrt($sumSquares);
    return $eucLen;
}

sub dotProduct {
    my ($vecRef1, $vecRef2) = @_;
    my %vec1 = %$vecRef1;
    my %vec2 = %$vecRef2;
    my $dp = 0;
    foreach my $i (keys %vec1) {
        if (exists $vec2{$i}) {
            $dp += $vec1{$i} * $vec2{$i};
        }
    }
    return $dp;
}    

1;
