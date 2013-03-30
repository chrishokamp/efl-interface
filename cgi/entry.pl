#!/usr/bin/perl
# This script initializes a session for evaluation of the interface 
# Chris Hokamp 
# Fall 2012

use strict;
use warnings; 

#use Encode;
use CGI '-utf8'; #TODO: ensure that this is necessary
use CGI::Carp 'fatalsToBrowser';
#use JSON;

#use LWP;
#use URI;
#use HTTP::Request::Common qw(GET);

#use parseTagTypes;
#use salsaTagger;

#Steps: 
#get user id and native language
#open .TSV and write this data
#close .TSV
#pass back the filename, and show the interface page

my $user = new CGI; 
my $time = time();


#TODO: control for valid UID on client-side
#my $uId = $user->param("userId");
#my $nativeLang = $user->param("nativeLang");

#TEST
my $uId = 'testuser';
my $nativeLang = 'Javanese';

my $filename = '/home/chris/test/eval/'.$uId.'.log';

#TODO: why isn't this working??
#&writeToFile($filename);
sub writeToFile {
	my $filename = $_[0];
	open (USERFILE, '>', $filename) or die $!;
	print USERFILE "$time\n";
	print USERFILE "$uId\n";
	print USERFILE "$nativeLang\n";

	close USERFILE;
}

#now pass the filename back to the browser
#
#TEST 
#TODO: output as JSON
&outputPage($filename);

sub outputPage {
	#my $docRef = $_[0];
	#TODO: ensure that this is the proper way to make output UTF8-safe
	print $user->header(-charset => 'UTF-8');
	#my @content = (); 
	#TEST - THE DATA HERE SHOULD BE CLEANER - GOING INTO THE NESTED STRUCTURE SHOULDN'T BE NECESSARY
	#my @doc = @{$docRef};
	#print $query->start_html();
	#my $i = 0;
	#foreach my $ref (@doc) {	
	#	my @evt = @{$ref};
	#	my $str =  $evt[1];
	#	my @words = split(' ', $str);
		
	#	for (@words) {
			#print "$_\n";
	#		push (@content, $_);
	#	} 
	#	if ($evt[0] eq 'text') {
			#$content .= ' '.$evt[1];
	#		print $evt[1]."\n";
	#	}
		#print 'test...';
	#	if ($i%5 == 0){
	#		print ('blah');
	#	}
	#	$i++;
	#	print "\ni is: $i\n"; 
	#}
	#TESTING output problem -- only tags are being shown in the browser!!
	#for (@content) {
	#	print $_.' ';
	#}
	#print CGI::escapeHTML($_[0]);
	print $_[0];
	$user->end_html();
	#print '<span class="context" style="color: blue;">test test </span>'."\n";
	#print "-- content is finished --";

	#END_TEST
}
