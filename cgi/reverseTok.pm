#this module implements some heuristics to put a whitespace-delimited tokenized string back together before outputting to the interface

#Author: Chris Hokamp	
#Fall 2012

use strict;
use warnings;

#NOTE:
#how to reverse the effects of the tokenizer.pm module from Rada?

#RULES
#(1) move all syntactic punctuation one space to the left
sub detokenize {
	my $str = $_[0];
        #print "1: string is: $str\n";	
	chomp($str);
	#TODO: test this to see output - only use for text events
	$str =~ s/ ([,.:;!?] )/$1/g; #Note: is matching through newlines necessary?
	#fix dashes
	$str =~ s/ - /-/g;
	#fix slashes
	#$str =~ s/ \/ /\//g;
	#fix underscores
	$str =~ s/ _ /_/g;
	#fix possesives - *see below for a more comprehensive formulation
	$str =~ s/ ' s /'s /g;
	#fix apostrophes (Note: this only fixes apostrophes inside words)
	#$str =~ s/ ' ([a-zA-Z]* )/'$1/g;	
	#fix quotes TODO: commented for debugging - this was causing errors
	#$str =~ s/ " (.+?) " /"$1"/g;
	#print "2: string is: $str\n";
    
    #add a space at the beginning and at the end
    $str = " ".$str;
    $str .= " ";
	return $str;	
}	

1;
