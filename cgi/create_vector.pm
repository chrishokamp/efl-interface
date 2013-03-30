#!/usr/bin/perl
#Author: Chris Hokamp
#Winter 2013
#create a random vector parameterized by two values: d=dimensionality, and c=number_of_non_zero_cells

use strict;
use warnings;

sub buildVector {
    my ($d, $c) = @_;
    my %new_vec = ();
    
    my %chosen = ();
    #populate array, ensuring there are no duplicates
    my @cells = ();
    for (my $i = 0; $i<$c; $i++) { #tested
        my $filled = 0; #bool
        while ($filled == 0) {
            my $newRandom = int(rand($d)) + 1; #vector cells begin at 1
            if (!(exists $chosen{$newRandom})) {
                $cells[$i] = $newRandom;
                $chosen{$newRandom} = 1;
                $filled = 1;
            }
        }
    }
    #map the cells to the vector, randomly choosing from @vals
    my @vals = (-1, 1); 
    foreach my $cell (@cells) { #tested
        $new_vec{$cell} = $vals[int(rand(2))];
    }
    return \%new_vec;
}

#TEST
#&buildVector(4001, 30); #tested
return 1;
