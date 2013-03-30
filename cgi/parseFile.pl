#!/usr/bin/perl
# This script drives the .cgi backend using text from the URL passed via the "upaddr" field 
# 
# Fall 2012

use strict;
use warnings; 

use utf8;
use CGI '-utf8'; #TODO: ensure that this is necessary
use CGI::Carp 'fatalsToBrowser';

#TODO: remove salsa tagger, add DB caching of pages
use lib 'mysql';
use docFinder;
use tokenize;
use dictTagger;

$CGI::POST_MAX = 1024 * 2000; #2Mb max
#my $safe_filename_chars = "a-zA-Z0-9_.-";

my $query = new CGI; 
#my $file = $cgi->param('file');
my $time = time();

#TODO: set this in the javascript
my $upfile = $query->param("file");
my $buffer = "";
while (my $line = <$upfile>) {
    $buffer .= $line;
}

my $linkColor = 'red';
#&outputPage("testing hidden iframe...");
my $output = &markup(&tagFile($buffer));

my $filename = 'testFile';
if ($output ne "") {

    #WORKING - CHANGING TO DB-BACKED PAGE STORAGE
    &storeDoc($filename, $output);
    &outputLink($filename);
	#&outputPage($output);	#tested
} else {
	#tell the user that this request didn't work
	print $query->header(-charset => 'UTF-8');
    print "Sorry, the file couldn't be processed\n";
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

sub tagFile {
    my $text = shift;
    #currently only splits on periods	
	my @sentences = split(/\. /, $text);
	if (@sentences > 1) {
		for (my $i = 0; $i < @sentences-2; $i++) {
			$sentences[$i] = $sentences[$i].'. ';
		}
	}
	my $sens = @sentences;			
	my @taggedOutput = ();
		
	foreach my $sen (@sentences) {
		#print "SEN: $sen\n";
		my @tokens = split(/ /, &tokenize($sen));
		my $taggedSen = &tag(\@tokens, $linkColor);
        
		push (@taggedOutput, $taggedSen);
		    #TEST
			#print "taggedSen is: \n".$taggedSen."\n";
	}
	my $outputText = join(' ', @taggedOutput);	
    return $outputText; 
}

sub markup {
    my $raw = shift;
    my $pre = '<html><body style="width: 960px; margin-left: auto; margin-right:auto;"><wrapper style="width: 80%; margin-left: auto; margin-right:auto;">';
    my $post = '</wrapper></body></html>';
    return $pre.$raw.$post;
}





sub outputPage {
	#TODO: ensure that this is the proper way to make output UTF8-safe
	print $query->header(-charset => 'UTF-8');
	print $_[0];
    print "\n\n";
}
