#!/usr/bin/perl
#Author: Chris Hokamp
#Winter 2013

#OPTIONS FOR LOADING VECTORS:
#(1) iterate over a JSON file where documents are on one line each, initialize one random vector for each doc

use strict;
use warnings;
use JSON;
use Data::Dumper;

#RANDOM INDEXING MODULES
use create_vector;
use rawTokenize;

#####COLLECTION PARAMETERS#########
my $DIMENSIONALITY = 10000;
my $CELLS_PER_VECTOR = 30;
my $OUTPUT = 'docVectors.json';
#my $DOCUMENTS = '/home/chris/data/pig_output/tfidf-json/top250-filter20/tfidf_token_weights-top250-filter20.json';
my $DOCUMENTS = '/home/chris/data/pig_output/tfidf-json/top250-filter20/small1000.json';
my $TSV = '/home/chris/data/pig_output/uri_to_context/small/from100000_context3to100.TSV';
my $STOPLIST='stopwords.en.list';
#######END COLLECTION PARAMETERS####
#####TEST######
#&createRawDocVectors($TSV); #tested
#&outputDocVectors(&createDocVectors());
#####END TEST##

sub loadJsonCorpus {
    open DOCS, '<', $DOCUMENTS || die $!;
    my %corpus = ();
    while (my $line = <DOCS>) {
        my $decoded = decode_json($line);
        my $uri = $decoded->{"uri"};
        #print "$uri\n";
        my @subs = split('/', $uri); 
        my $name = pop(@subs);
        #$corpus{$name} = $decoded->{"sorted"}; 
        my @sortedTokenArray = @{$decoded->{"sorted"}}; 
        my %tokenHash = ();
        foreach my $tokenObjRef (@sortedTokenArray) {
            my %tokenObj = %$tokenObjRef;
            my $tok = $tokenObj{'token'};
            my $val = $tokenObj{'weight'};
            $tokenHash{$tok} = $val;
            #foreach my $key (keys %tokenObj) {
            #    print "key: $key val: $tokenObj{$key}\n";
            #}
        }
        $corpus{$name} = \%tokenHash;
    }
    #print Dumper(%corpus); #tested
    return \%corpus;
} 

sub createRawDocVectors {
    #print "inside raw doc vectors...\n";
    my $input = shift;
    my %rawHash = %{&getDocNames($input)};
    my %docVectors = ();
    my $c = 0;
    foreach my $docName(keys %rawHash) {
        my @subs = split('/', $docName); 
        my $name = pop(@subs);
        #print "name: $name\n"; #tested
        $docVectors{$name} = &buildVector($DIMENSIONALITY, $CELLS_PER_VECTOR);#initialize new random vectors  
        $c++;
        if (($c % 100) == 0) {
            print "MADE $c VECTORS...\n";
        }    
    }
    #TEST #tested
    print "INSIDE RAW DOC VECTORS\n";
    #foreach my $k (keys %docVectors) {
        #print "doc name: $k\n";
    #}
    #END TEST
    return \%docVectors;
}

sub createJSONDocVectors {
    my %docVectors = ();
    open DOCS, '<', $DOCUMENTS || die $!;
    while (my $line = <DOCS>) {
        my $decoded = decode_json($line);
        my $uri = $decoded->{"uri"};
        #print "$uri\n";
        my @subs = split('/', $uri); 
        my $name = pop(@subs);
        #print "name: $name\n"; #tested
        $docVectors{$name} = &buildVector($DIMENSIONALITY, $CELLS_PER_VECTOR);#initialize new random vectors  
    }
    return \%docVectors;
}

sub outputDocVectors {
    my $route = shift;
    my $ref = ();
    if ($route eq 'json') {
        $ref = &createJSONDocVectors();
    } elsif ($route eq 'raw') {
        $ref = &createRawDocVectors();
    }
    #print Dumper(%docVectors);
    open OUTPUT, '>', $OUTPUT;
    my $json = to_json($ref, {utf8 => 1, pretty => 1});
    print OUTPUT $json; 
    close OUTPUT;
}

1;
