#!/usr/bin/perl

#This script is the interface to SaLSA
#Author: Chris Hokamp
#Fall 2012

use CGI '-utf8'; #TODO: ensure that this is necessary
use CGI::Carp 'fatalsToBrowser';

use salsaClient;

#(1) get the query from CGI (param: context)
#(2) give the headword markup consistent with salsa
#(3) parse salsa's response
#(4) send the list of synonyms back to the page and display

my $query = new CGI; 
my $time = time();

#TODO: make sure the target word is marked-up by salsaTagger.pm
my $context = $query->param("context");
my $word = $query->param("word");
$context =~ s/($word)/<head>$1<\/head>/;

#TEST
#my $context = "The film is very thin.";
#my $word ="film";
#TODO: this is for development only! (temp fix)
#$context =~ s/($word)/<head>$1<\/head>/;

#TESTING CGI ERROR
my $output = &askSalsa($context);
#chomp($output);
#Now test page output
#print $query->header(-charset => 'UTF-8');
#print "Testing salsaQuery.pm output... $output"; #tested
#print $output;

&outputPage($output); #Tested

#&outputPage($output);

sub askSalsa {
        my $context = $_[0];	
	#Now ask SaLSA and get the results back
        my $rawOutput = &topSynonyms($context); 		

	chomp($rawOutput);
	my @words = split(/\|/, $rawOutput);
        my $output = join('<br />', @words);	
	#now get the top ten
				
	#$output =~ s/All synonyms scores = //; #temporary hack to clean the raw output of SaLSa 
	#$output =~ s/[\[\]\(\),'0-9_]/ /g;
	#$output =~ s/^\s+//;
	#$output =~ s/\s+$//;
	#chomp($output);
	#TEST
	#print "output of salsa is: $output\n"; 
	return $output;
}	

sub outputPage {
	my $cont = $_[0];
	print $query->header(-charset => 'UTF-8');
	#print "Testing salsaQuery.pm output..."; #tested
	print $cont;
}

