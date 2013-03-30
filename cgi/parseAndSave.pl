#!/usr/bin/perl
# This script drives the .cgi backend using text from the URL passed via the "upaddr" field 
# Chris Hokamp 
# Fall 2012

use strict;
use warnings; 

use utf8;
use Encode;
use CGI '-utf8'; #TODO: ensure that this is necessary
use CGI::Carp 'fatalsToBrowser';
use LWP;
use URI;
use HTTP::Request::Common qw(GET);

#TODO: remove salsa tagger, add DB caching of pages
use lib 'mysql';
use docFinder;
use parseTagTypes;
use dictTagger;

#Notes: 
#	- add a class for "known" words
#	- also add an attribute = context = the sentence the word is in (from nltk sentence parser)
#add a very specific stylesheet with implementation-specific classes to handle the new markup in the page

my $query = new CGI; 
my $time = time();

#the site may generate different HTML depending upon the browser
my $ua = LWP::UserAgent->new; 
$ua->agent('Mozilla/8.0');

#TODO: set this in the javascript
#my $upfile = $query->param("upfile");

# read the url and from the Web interface
my $url = $query->param("targetUrl");

#TODO: get user preference for link color
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

#print "getting url\n";
my $req = GET $url;
my $res = $ua->request($req); 
if ($res->is_success) {
    #print "res was success\n";
    my $html = $res->decoded_content;
    #print "html is: $html\n";	
    #step 3 - try to resolve links
	$html =~ s/(src ?= ?|href ?= ?)\"(.*?)\"/fixUri($1,$2)/egi;
	#reencode UTF
	$html = encode('UTF-8', $html);
	#tested
	#WORKING - commented to try the <iframe> method
	sub fixUri {
		my ($prefix, $link) = @_;
		#TEST
		#print "link is: $link\n";
		#print "converted is: ";
		#print URI->new_abs( $link, $res->base )."\n";
		#END_TEST
		return $prefix.URI->new_abs( $link, $res->base );
    }		
    #step 3 - call the tagtype module

	my $output = &tagTypes($html, $url, $linkColor);
    #print "output is: $output\n";	

    #WORKING - CHANGING TO DB-BACKED PAGE STORAGE
    &storeDoc($url, $output);
	&outputLink($url);	
} else {
	#tell the user that this request didn't work
        
	    print $query->header(-charset => 'UTF-8');
        print $res->status_line . "\n";
}


sub save {
	my ($filename, $data) = @_;
	#TODO: change to database implementation
	open OUT, '>', $filename;
	print OUT $data;
	close OUT;
}	  

sub outputLink {
	#TODO: ensure that this is the proper way to make output UTF8-safe
	print $query->header(-charset => 'UTF-8');
	my $filename = $_[0];
	print $filename;

    #TEST ONLY!! - move to a separate module!
    #my $html = &getDoc($filename);
    #print "HTML IS:\n$html\n\n";
}

sub outputPage {
	#TODO: ensure that this is the proper way to make output UTF8-safe
	print $query->header(-charset => 'UTF-8');
	print $_[0];
}
