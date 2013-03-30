#!/usr/bin/perl
# Interface between AJAX and MySQL DocCache 
# Chris Hokamp 
# WINTER 2013

use strict;
use warnings;

use CGI;

use lib 'mysql';
use docFinder;

my $query = new CGI; 
my $url = $query->param("docUrl");
chomp($url);

my $html = &getDoc($url);
&outputPage($html);

sub outputPage {
	#TODO: ensure that this is the proper way to make output UTF8-safe
	print $query->header(-charset => 'UTF-8');
	print $_[0];
}



