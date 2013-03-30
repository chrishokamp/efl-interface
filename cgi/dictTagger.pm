#!/usr/bin/perl 

#Author: Chris Hokamp
#Winter 2012
#Info: This module takes sentences and checks them against the SaLSa database. If the word is known, It returns a sentence with the headword tagged (<head>word</head>). If all words in the sentence are unknown, it does nothing.
use strict;
use warnings;
use reverseTok;
use dictClient;

#TEST
#my $globalIndex = 0;

#TODO - take the user-specified color and use it to markup the class="head" elements
my $globalIndex = 0;

open TEST, '>>', 'testTagger.txt' or die $!;
sub tag 
{
	my ($senRef, $linkColor) = @_;

	#print "sen is $senRef\n";
	#print "i is $i\n";
	
	my @tokens = @$senRef; #split on single whitespace
	my $sen = join(" ", @tokens);
	#the ID is the word's index in the array
	my @output = ();
	#print "sen is $sen\n";
	
	#TODO: there is a bug here - the wrong words are being tagged 
	#Update: this is related to the actual markup in some way 
	#	- has something to do with numbers (reverseTokenizer?)
	for (my $i = 0; $i < @tokens; $i++) {

		my $word = $tokens[$i];	
		#print "The word is: $word\n";
		#TODO: add unique identifiers to each target word
		#my $bool = `perl dictClient.pl $word`;
        my $bool = 'false';
		my $bool = &checkWord($word);
		chomp($bool);
        print TEST "WORD: $word, BOOL: $bool\n";
		#print " bool is $bool\n";
		if ($bool eq 'true')
		{
			#print "salsa knows it... \n";
			$output[$i] = '<span class="feedback" id="'.$globalIndex.'" style="color: '.$linkColor.'">'.$word.'</span>';			
            print TEST "After tagging: ".$output[$i]."\n";
			#$globalIndex++;
		} else {
			$output[$i] = $word;
			#print '<span class="head"></span><span class="context"></span>';
		}
		#$i++;

		#TEST
		#$i = $i-1;	

		
	}
	#sentences are labeled with id=sen + globalId 
	my $context = '<span class="context" id="sen'.$globalIndex.'" style="display: none">'.$sen.'</span>';
	push(@output, $context);
	my $processed = join (" ", @output);
	#TEST DETOKENIZER
	$processed = &detokenize($processed);

	#print "processed is: $processed\n";
	$globalIndex++;
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
