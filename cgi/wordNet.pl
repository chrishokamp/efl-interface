#!/usr/bin/perl

use strict;
use warnings;

use CGI;
use CGI::Carp 'fatalsToBrowser';

use queryWordNet;

my $query = new CGI;
my $word = $query->param("word");
#TEST #tested
#my $word = 'clever';

my @defs = &getDefinitions($word);
my $outputLines = ();

for (my $i = 0; $i < @defs; $i++) {
	$outputLines .= ($i+1).': '.$defs[$i].'<br /><br />';
}


#TODO: temporary fix!
#my $outputLines = join('<br />', @defs);
&output($outputLines);

#TODO: handle output using client-side javascript object
sub output {
	my $output = $_[0];
	print $query->header(-charset => 'UTF-8');
	print $output;
} 

