#!/usr/bin/perl -w

#Author: Chris Hokamp
#Winter 2012
#Information Retrieval

#simple tokenization

#use strict;
#use warnings;


sub simple_tokenize #basic tokenization heuristics - return a tokenized string with single whitespaces as delimiters
{
	my $t = $_[0];
	#print "tokenizing this: \n$t\n";
	$t =~ s/\n+/ /g; #replace newline(s) with a single whitespace
	$t =~ s/([[:punct:]])/ $1 /g;
	$t =~ s/\d//g; #remove all digits
	$t =~ s/ , ([a-z]) \. ([a-z]) \. ([a-z]) \. / $1\.$2\.$3\. /g; #handle name abbreviations in the form: lastname , i . i . i .
	$t =~ s/ , ([a-z]) \. ([a-z]) \. / $1\.$2\. /g; #handle name abbreviations in the form: lastname , i . i .
	$t =~ s/ , ([a-z]) \. / $1\. /g; #handle name abbreviations in the form: lastname , i . 
	$t =~ s/ ([a-z]) \. ([a-z]) \. ([a-z]) \. / $1\.$2\.$3\. /g; #fix 3-char abbreviations
	$t =~ s/ ([a-z]) \. ([a-z]) \. / $1\.$2\. /g; #fix 2-char abbreviations
	
	$t =~ s/ ' s /'s /g; #fix possesives
	$t = &fixContractions($t);
	#$t =~ s/\s+/ /g; #truncate multiple whitespaces -TEST
	$t =~ s/\b - \b/-/g; #fix hyphenated stuff
	$t =~ s/ [[:punct:]] / /g; #remove all non-integral punctuation
	$t =~ s/\s+/ /g; #truncate multiple whitespaces	
	$t =~ s/^\s+//g; #remove whitespace at the beginning
	$t =~ s/\s+$//g; #remove whitespace at the end
	#Test
	#print "now t is: \n$t\n";

	return $t;
}

sub fixContractions
{
	my $line = $_[0];
	$line =~ s/(i) ' (m) /$1'$2 /gi; #i'm
	$line =~ s/(i) ' (d) /$1'$2 /gi; #i'd
	$line =~ s/(you) ' (re) /$1'$2 /gi; #you're
	$line =~ s/(you) ' (ve)/$1'$2 /gi; #you've
	$line =~ s/(don) ' (t) /$1'$2 /gi; #don't
	$line =~ s/(didn) ' (t) /$1'$2 /gi; #didn't
	$line =~ s/(doesn) ' (t) /$1'$2 /gi; #doesn't
	$line =~ s/(there) ' (s) /$1'$2 /gi; #there's
	$line =~ s/(it) ' (s) /$1'$2 /gi; #it's
	$line =~ s/(let) ' (s) /$1'$2 /gi; #let's
	$line =~ s/(she) ' (s) /$1'$2 /gi; #she's
	$line =~ s/(she) ' (d) /$1'$2 /gi; #she'd
	$line =~ s/(he) ' (s) /$1'$2 /gi; #he's
	$line =~ s/(he) ' (d) /$1'$2 /gi; #he'd
	$line =~ s/(you) ' (ve)/$1'$2 /gi; #you've
	$line =~ s/(that) ' (s) /$1'$2 /gi; #that's
	$line =~ s/(can) ' (t) /$1'$2 /gi; #can't
	$line =~ s/(won) ' (t) /$1'$2 /gi; #won't
	$line =~ s/(weren) ' (t) /$1'$2 /gi; #weren't
	$line =~ s/(haven) ' (t) /$1'$2 /gi; #haven't
	$line =~ s/(should) ' (ve) /$1'$2 /gi; #should've
	return $line;
}

1;
