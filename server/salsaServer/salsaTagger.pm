#!/usr/bin/perl 

#Author: Chris Hokamp
#Winter 2012
#Info: This module takes sentences and checks them against the SaLSa database. If the word is known, It returns a sentence with the headword tagged (<head>word</head>). If all words in the sentence are unknown, it does nothing.
#use strict;
#use warnings;

use checkWord;

sub tag #takes a tokenized sentence and marks the words that SaLSa knows with <a name = "<word>">$word</a>, otherwise returns the joined text unchanged
{
	my $senRef = $_[0];

	#print "sen is $sen\n";
	#print "i is $i\n";
	my @tokens = @$senRef; #split on single whitespace
	
	my $i = 0; #this stores the current index
	#the ID is the word's index in the array
	foreach my $word (@tokens)
	{	
		if (&isKnown($word) eq "true")
		{
			$tokens[$i] = '<a class ="head" id="'.$i.'" name ='."\"$word\">".$word.'</a>';
			
		}	
		$i++;
	}
	
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
1;
