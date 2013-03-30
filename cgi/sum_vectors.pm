#!/usr/bin/perl
#Author: Chris Hokamp
#Winter 2013
#sum two vectors

use strict;
use warnings;

sub sumVectors {
    my ($vec1ref, $vec2ref) = @_;
    my %summed = %$vec2ref; 
    foreach my $key (keys %$vec1ref) {
        if (exists $summed{$key}) {
            my $current = $summed{$key};
            my $new = $current + $$vec1ref{$key};
            $summed{$key} = $new; 
        }
    }
    return \%summed;    
}
 
#TEST
#my %t1 = (1, -1, 4, 1);
#my %t2 = (2, 1, 4, 1);
#&sumVectors(\%t1, \%t2); #tested
return 1;
