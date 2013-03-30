#!/usr/bin/perl
# This script drives the .cgi backend using text from the URL passed via the "upaddr" param
# Chris Hokamp 
# Fall 2012

use strict;
use warnings; 

use HTML::Parser;
use HTML::Entities;
#use Data::Dumper;

#Perl Tokenizer from Rada
use tokenize;

#for development only
#use preprocess; #note - this doesn't work because it irreversibly changes many of the tokens

#Notes:
# if this is a text event, check the text value of the array
#Skip CDATA using $p->marked_sections
#to rebuild the page, return as skipped_text ??
#	- before adding something new to the array, add skipped_text
#see http://search.cpan.org/dist/HTML-Parser/Parser.pm
#some heuristics can distinguish javascript from text - i.e. if contains ({} word.word, etc...)

#Remember to clean this each time - TODO: DEBUG and move global members to safe subroutines!! 
my @document = ();
my $docRef = \@document;
my $linkColor = 'blue';
my $openBuffer = 0; #boolean which allows custom parsing for different tagtypes (see sub eventTracker)
my %tagset = ('p', 1, 'dd', 1, 'h1', 1, 'h2', 1, 'h3', 1, 'li', 1, 'span', 1);

sub tagTypes {
    #print "inside tag types\n";
	my ($html, $url, $color) = @_;
	$linkColor = $color;

	my $p = HTML::Parser->new(api_version => 3,
		handlers => { 
			      #we only need to explicitly handle text events
			      #call a subroutine which first adds $skipped_text, then continues  
			      default => [\&eventTracker, "event,tagname,text"],
	});
	
	#TODO: find optimal combination of parser parameters
	$p->unbroken_text; #cause text to be passed as unbroken block where possible
	$p->marked_sections( 'TRUE' );
	#$p->utf8_mode( 'TRUE' );
	#Parse the url
	$p->parse($html);
	#for (@document) {
	#	my @data = @$_;
	#	if ($data[0] eq 'text') {
	#		print $data[1];
			#only change the value in this cell in the array
			#tag all known words
			#(1) nltk punkt sentence tokenizer = context
			#	- foreach known word in this cell, get its sentence (context) from its span
			# add <token><\token> tags around the known token with an attr: context="this is the context where we found the <token>token<\token>
			# 
	#	}
		#print Dumper(@data);
	#}
	my $out = ();
	foreach my $ref (@document) {
		my @evt = @{$ref};
		if ($evt[0] eq 'processed') {
			 #$evt[1] = CGI::escapeHTML($evt[1]);
		}
		#Test: concatenate and output the text of the event
		$out .= " ".$evt[1];
        } 
	return $out;
}

#buffer handler and tag parser
sub eventTracker {
	my ($event, $tagname, $text) = @_;
	#print "event is: $event, tagname is $tagname\n";
	#print "buffer is: $openBuffer\n";	

	#TODO: keep events in order in the doc array, but handle text stuff differently
	#Abstract all HTML-specific logic away from the text handling
	if ($event eq 'start' && exists($tagset{$tagname})) {
		$openBuffer = 1;
	}
	if ($event eq 'end' && exists($tagset{$tagname})) {
		$openBuffer = 0;
	}
	&fillDocArray($event, $tagname, $text);
}

#using NLTK may not be the best approach here
#tokenizing the context is definitely necessary, however
sub fillDocArray {
	my ($event, $tagname,$text) = @_;
	my @docArray = ();

	#print "The event: \n".$event."\n";
	#print "The dtext: \n".$text."\n"; 
	#testing with only <p></p>

	if ($openBuffer == 1) {
		#heuristics to handle javascript
		chomp($text);
	  	if ($text =~ /function\(/ || $text=~ /CDATA/ || $text =~ / var / || $text !~ /^[\w\s]/ || $text =~ /[;\}\/]$/ || $text =~ /^</) {
	      		my @data = ($event, $text);
       			#just add the text to the doc array and continue
	        	push ( @docArray, \@data );
		} else {
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
				decode_entities($sen); #tested
                $sen =~ s/\n//g;
                chomp($sen);
				my @tokens = split(/ /, &tokenize($sen));
				my $taggedSen = &tag(\@tokens, $linkColor);
				push (@taggedOutput, $taggedSen);
				#TEST
				#print "taggedSen is: \n".$taggedSen."\n";
			}
			$text = join(' ', @taggedOutput);	
	

			#$text = `python nltkParse.py $text`;
			#now tag the words that we know with <head><\head>	
			#tokenize (nltk) and pass to salsaTagger.pm
		        #	-&tag returns a string
			#FIX THIS
			#Change event name to 'processed'
			$event = 'processed';
			my @tuple = ($event, $text);
			push (@docArray,\@tuple);

		}		
	
	} else {
		#make array ref and push
	#	push(@document,  );
		my @data = ($event, $text);
		push ( @docArray, \@data );
	}
	#TEST	
	push ( @document, @docArray );
}
			
1;         
