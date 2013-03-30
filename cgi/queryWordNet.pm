#!/usr/bin/perl

#takes a string as the query, and outputs the list of glosses from WordNet
#TODO: make into persistent server so that WordNet doesn't need to be reloaded every time

use strict;
use warnings;

use WordNet::QueryData;

my $wn = WordNet::QueryData->new();

#my $t = $ARGV[0];
sub getDefinitions {
	my $word = $_[0];
	$word = lc($word);
        my @withPos = $wn->querySense($word);
	my @allDefs = ();
	for (@withPos) {
		#print "making all defs\n";
		push (@allDefs, $wn->querySense($_));	
	}
	my @allGlosses = ();
	for (@allDefs) {
		#print "making all glosses \n";
		push (@allGlosses, $wn->querySense($_, "glos"));
	}
	#TODO: print with POS labels
	#TODO: remove NLTK dependency by using BrillTagger
	#print "all glosses \n";
	#for (@allGlosses) {
	#	print "$_\n";
	#}
	return @allGlosses;
}
#test - tested
#&getDefinitions('rabbit');
1;
