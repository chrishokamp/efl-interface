#!/usr/bin/perl
# Chris Hokamp 
# Fall 2012

use strict;
use warnings;

#use Encode;
use CGI '-utf8'; #TODO: ensure that this is necessary
use CGI::Carp 'fatalsToBrowser';
#use JSON;
#use Data::Dumper;

my $userData = new CGI; 
my $jsonString = $userData->param("userData");
#my $jsonString = '{"id":"thatGuy","foo":"bar"}';
#my $decoded = decode_json($jsonString);
#just dump to file for now  
#dump both the json and the Data::Dumper
#my $perlString = Dumper($decoded);

#my $uid = $decoded->{"id"}; #tested
open OUT, '>>', '/home/chris/test/userData.json';
print OUT $jsonString; 
print OUT "\n"; 
close OUT;
&outputPage($jsonString);
sub outputPage {
	print $userData->header(-charset => 'UTF-8');
	print $_[0];
}
1;
