#!/usr/bin/perl
# This script grabs definitions for a word from the wordnik api 
# Chris Hokamp 
# Fall 2012
 
use strict;
use warnings;
 
use CGI;
use CGI::Carp 'fatalsToBrowser';
use LWP::UserAgent;
use HTTP::Request::Common qw(GET);

my $query = new CGI;
my $ua = LWP::UserAgent->new;

#get the word
#my $word = $query->param("word"); 

my $word = 'rabbit';

#TEST RESTFUL API
my $basePre = 'http://api.wordnik.com//v4/word.json/';
my $basePost = '/definitions?includeRelated=false&includeTags=false&sourceDictionaries=all&useCanonical=false';
my $authToken = '&api_key=f459be7ba20b06494200602ce9f0d116be7633f3956066bd4';

my $q = $basePre.$word.$basePost.$authToken;
#TEST
#print "Query URL is: $q\n";

my $req = GET $q;
#$req->auth_token('f459be7ba20b06494200602ce9f0d116be7633f3956066bd4');
my $res = $ua->request($req);
if ($res->is_success) {
	my $json = $res->content;
	#TEST
	#print "the result of the request was: $json\n"; 
	print $query->header();
	print &parseResult($json);
	
} else {
	print $res->status_line."\n";
}
	
sub parseResult {
	my $raw = $_[0];
	#print "raw is: $raw";
	my @text = ($raw =~ /"text":"(.*?)"/g);
	
	my $buf = "";
	my $i = 1;
	for (@text) {
		#print $_."\n";
		$buf .= $i.': '.$_.'<br />';
		$i++;
		
	}
	return $buf;
}
