#!/usr/bin/perl -w

#Author: Chris Hokamp
#Winter 2012
#Info: This module takes sentences and checks them against the SaLSa database. If the word is known, It returns a sentence with the headword tagged (<head>word</head>). If all words in the sentence are unknown, it does nothing.
use strict;
use warnings;

use checkWord;

sub tag #takes a tokenized sentence and the index (starting at 0) of a word to disambiguate, and returns the tagged sentence if SaLSa knows the word, otherwise returns the joined sentence unchanged
{
	my $senRef = $_[0];
	my $i = $_[1];

	#print "sen is $sen\n";
	#print "i is $i\n";
	my @tokens = @$senRef; #split on single whitespace
		
	#if (&isKnown($tokens[$i]) eq "true")
	#{
	my $w = $tokens[$i];
	$tokens[$i] = '<head>'.$w.'</head>';
	#}
	
	my $processed = join (" ", @tokens);
	#TEST
	#print "processed is: $processed\n";
	return $processed;
} 	


#TEST			
#open IN, "<", "taggerTest.txt";
#while (my $line = <IN>)
#{
#	chomp($line);
#	my @args = split (/;/, $line);
#	my $sen = $args[0];
#	my $i = $args[1];
#	&tag($sen, $i);
#}
#close IN; 

