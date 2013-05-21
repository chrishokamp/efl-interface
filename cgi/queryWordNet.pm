#!/usr/bin/perl

#takes a string as the query, and outputs the list of glosses from WordNet
#TODO: make into persistent server so that WordNet doesn't need to be reloaded every time

use strict;
use warnings;
use feature qw(say);

use WordNet::QueryData;
my $wn = WordNet::QueryData->new();

sub getDefinitions {
	my ($word, $pos) = @_;
    #say "getting word: $word";
	$word = lc($word);
    my @withPos = $wn->querySense($word.'#'.$pos);
	my @allDefs = ();
	for (@withPos) {
		#print "making all defs\n";
		push (@allDefs, $wn->querySense($_, "glos"));	
	}
	#print "all glosses \n";
	for (@allDefs) {
		print "$_\n";
    }	

	return \@allDefs;
}
#test - tested
#&getDefinitions('swim', 'v');
1;
