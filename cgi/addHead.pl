#!/usr/bin/perl

#This script is the interface between the browser and the disambiguation client 
#Author: Chris Hokamp
#Fall 2013

use utf8;
use CGI '-utf8'; #TODO: ensure that this is necessary
use CGI::Carp 'fatalsToBrowser';

#ENTRY POINT INTO DISAMBIGUATION SYSTEM
use disambiguate;

my $query = new CGI; 
my $time = time();

#TODO: make sure the target word is marked-up by salsaTagger.pm

my $context = $query->param("c");
my $word = $query->param("w");
chomp($context);
chomp($word);

#TEST
#my $context = "He was always a very smart and bright boy at school.";
#my $context = "Live text commentary as Tunisia take on Algeria at the Cup of Nations after favourites Ivory Coast beat Togo .";
#my $word = "text";
#my $word = "bright";
#End test
$context =~ s/($word)/<head>$1<\/head>/;

my $topMatches = &parseContext($context);
&outputPage($topMatches);
#&outputPage('balls');

sub outputPage {
	#TODO: ensure that this is the proper way to make output UTF8-safe
	print $query->header(-charset => 'UTF-8');
	print $_[0];
    print "\n\n";
}

