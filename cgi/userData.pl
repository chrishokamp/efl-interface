#!/usr/bin/perl
# Chris Hokamp 
# Fall 2012

use strict;
use warnings;
use CGI '-utf8'; #TODO: ensure that this is necessary
use CGI::Carp 'fatalsToBrowser';
#use Encode;
#use JSON;
#use Data::Dumper;

my $userData = new CGI; 
my $jsonString = $userData->param("userData");

#my $uid = $decoded->{"id"}; #tested

#open OUT, '>>', '/local/chris_h/houndDog/userData/userLogs.json';
open OUT, '>>', '/home/chris/test/hd-userLogs.json';
print OUT $jsonString; 
print OUT "\n"; 
close OUT;

&outputPage($jsonString);
sub outputPage {
	print $userData->header(-charset => 'UTF-8');
    print $_[0];
}

1;
