#!/usr/bin/perl
# This script drives the .cgi backend using text from the URL passed via the "upaddr" field 
# Chris Hokamp 
# Fall 2012


use strict;
use warnings; 

#use Encode;
use utf8;
use CGI '-utf8'; #TODO: ensure that this is necessary
use CGI::Carp 'fatalsToBrowser';
use LWP;
use URI;
use HTTP::Request::Common qw(GET);
use parseTagTypes;
use salsaTagger;

#set buffer to 0
#$|++;

#Notes: 
#	- add a class for "known" words
#	- also add an attribute = context = the sentence the word is in (from nltk sentence parser)
#add a very specific stylesheet with implementation-specific classes to handle the new markup in the page

my $query = new CGI; 
my $time = time();

#the site may generate different HTML depending upon the browser
my $ua = LWP::UserAgent->new; 
$ua->agent('Mozilla/8.0');

#TEST LOGGING - make sure web server perms are set correctly!
#open LOG, ">>", 'log.txt';
#print LOG "getUrl.pl was called...\n";
#close LOG;

#check if upfile is there - Note that we can only parse the file or the url, not
#both - check for parsable file type as well -
# UPDATE: do this in Javascript(client-side), not CGI

#TODO: set this in the javascript
#my $upfile = $query->param("upfile");

# read the url and from the Web interface
my $url = $query->param("targetUrl");

#get user preference for link color
#my $linkColor = $query->param("color");

#blue is default
my $linkColor = 'red';
#check color
#if ($linkColor ne 'blue' || $linkColor ne 'red') {
#	$linkColor = 'blue';
#}

#TESTING URLs...
#my $url = 'http://localhost/dev/efl-interface-rd/tick_numbers_increase.html';
#my $url = 'http://localhost/efl-interface-rd/just_words.html';
#my $url = 'http://localhost/sample1.html';
#my $url = 'http://localhost/';
#my $url = 'http://www.bbc.com';
#my $url = 'http://www.bbc.com/future/story/20121025-language-lessons-from-twitter';
#my $url = 'http://www.yahoo.com';
#my $url = 'http://en.wikipedia.org/wiki/Atmosphere';
#my $url = 'http://www.sparky.org/story.html';
#my $url = 'http://lit.csci.unt.edu/';
#END TESTING URLS


my $req = GET $url;
my $res = $ua->request($req); 
if ($res->is_success) {
    my $html = $res->decoded_content;
	#test
	#step 1 - resolve relative links - WORKING - commented to try the <iframe> method
	#$html =~ s/(src ?= ?|href ?= ?)\"(.*?)\"/&fixUri($1,$2)/egi;
	##reencode UTF
	#$html = encode('UTF-8', $html);
	#
	##tested
	##WORKING - commented to try the <iframe> method
	#sub fixUri {
	#	my ($prefix, $link) = @_;
	#	#TEST
	#	#print "link is: $link\n";
	#	#print "converted is: ";
	#	print URI->new_abs( $link, $res->base )."\n";
	#	#END_TEST
	#	return $prefix.URI->new_abs( $link, $res->base );
    #}		
	#	        
	##print $query->header( );
	#print $html;
	#end test
	#step 2 - call the tagtype module
	&outputPage(&tagTypes($html, $url, $linkColor));

} else {
	#tell the user that this request didn't work
        print $res->status_line . "\n";
}

sub outputPage {
	#my $docRef = $_[0];
	#TODO: ensure that this is the proper way to make output UTF8-safe
	print $query->header(-charset => 'UTF-8');
	print $_[0];
}
