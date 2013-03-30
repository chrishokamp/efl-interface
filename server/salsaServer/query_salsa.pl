#!/usr/bin/perl
# This script talks to salsa
# Chris Hokamp 
# Spring 2012
use CGI;
use salsaIndexTagger;

$query = new CGI; 
$time = time();
$myAttr = $query->param("word");
chomp($myAttr);
#use this to get the context
my $context = $query->param("context");

#now get the word's id in the paragraph, which will serve as its index to SaLSA
my $id  = $query->param("id");

#Tag the word with <head>$word</head> within its sentence
my @sentence = split(/ /, $context); #this is just a temporary hack until the sentence tokenizer is working
my $senRef = \@sentence;
my $tagged_sen = &tag($senRef, $id); #now the word is tagged as the head word
$tagged_sen = $tagged_sen." \."; #add a period for SaLSA

#now save to a file - this will need to be threaded or something in the future to allow concurrent access
#now save to a file
my $filename = 'temp.txt';
chmod 0777, $filename or die $!; #added this in an attempt to fix errors

open TEMP, '>', $filename;

print TEMP $tagged_sen."\n";
close TEMP;

#Now ask SaLSA and get the results back
my @results = `python salsa.py temp.txt`; #update: this doesn't work because the Apache User can't find the python install
my $output = $results[24];
chomp($output);
#now get the top ten
				
$output =~ s/All synonyms scores = //; #temporary hack to clean the raw output of SaLSa 
$output =~ s/[\[\]\(\),'0-9_]/ /g;
$output =~ s/^\s+//;
$output =~ s/\s+$//;
#TEST
#print "output is: $output\n"; #it works!

my @newTerms = split(/\s{2,}/, $output);
#GET THE TOP TEN (OR FEWER) SYNONYMS
my @topten = ();
my $l = @newTerms;
my $i = 0;
while ($i < 10 && $i < $l)
{
	my $term = $newTerms[$i];
	$i++;
	push (@topten, $term);
}
my $syns = "";
for (@topten)
{
	$syns .= " $_ <br />";
}

print $query->header ( ); 
print <<END_HTML; 

the attribute's value is: <a href = "http://en.wiktionary.org/wiki/$myAttr">$myAttr</a> <br />
the context is:<br /> $context <br />
the id is: $id <br />
the best synonyms are: $syns
END_HTML

