#!/usr/bin/perl
#Author: Chris Hokamp
#Winter 2013
#create word vectors from a JSON file of document vectors
#STEPS
#(1) Load document vectors
#(2) Load Corpus with counts for each token
#(3) Iterate through corpus
#   3a) initialize vectors for each new word (equivalent to doc vector)
#   3b) sum vectors when the same token is dicovered in a new document

use strict;
use warnings;
use JSON;
use utf8;
use Data::Dumper;
use DBI;

#RANDOM INDEXING MODULES
use sum_vectors; 
use documentVectors;
use cossim;
use lib 'mysql';
use mysqlConnector;
#use loadVectors;

my $TSV = '/home/chris/data/pig_output/uri_to_context/small/from100000_context3to100.TSV'; 
#my $TSV = 'test/1000fromBig.test'; 
#my $TSV = 'test/300fromBig.test'; 
#my $TSV = 'test/500fromBig.test'; 
#my $TSV = 'test/100fromBig.test'; 

#my $TSV = '100.out';
my $STOPLIST = 'stopwords.en.list';

#my %corpus = %{&loadJsonCorpus()};

&outputDocVectors('json');

my $INPUT = 'docVectors.json';
open my $docs, '<', $INPUT or die "error opening $INPUT: $!";
my $docsJson = do { local $/; <$docs> }; 
close $docs;

#my %randomDocVectors = %{decode_json($docsJson)}; #This can also be loaded via the documentVectors module
#
#sub createJSONWordVectors {
#    my %randomWordVectors = (); 
#    foreach my $doc (keys %corpus) { #keys are docs 
#        my $docVecRef = $randomDocVectors{$doc};
#        #print "DOC NAME: $doc\n";
#        my %tokenHash = %{$corpus{$doc}};
#        foreach my $token (keys %tokenHash) {
#            my $tokenWeight = $tokenHash{$token}; 
#            my $weightedVecRef = &weightVector($docVecRef, $tokenWeight);
#            #TEST
#            #print "token: $token, weight: ".$tokenHash{$token}."\n";
#            if (exists $randomWordVectors{$token}) {
#                #TEST
#                #print "The word: $token already exists\n";
#                my $currentVecRef = $randomWordVectors{$token};  
#                my $summedWordVecRef = &sumVectors($currentVecRef, $weightedVecRef);  
#                $randomWordVectors{$token} = $summedWordVecRef;
#            } else {
#                #print "$token is a new word\n";
#                $randomWordVectors{$token} = $weightedVecRef;
#            }
#        }
#    }
#    return \%randomWordVectors; 
#}
#
#TODO: add DBI and JSON support via one subroutine with parameters
sub createDBWordVectors {
    #TEST #tested and loaded
    #&docVectorsToDB();
    #END TEST
    my $docDB = &openDB('randomVecs', 'root', 'hfrawg826'); 
    #prepare the query
    my $docVecQuery = $docDB->prepare("SELECT Vector FROM DocVectors WHERE Doc_Name = ?");
    my %rawCorpus = %{&buildRawTokenHash($TSV, $STOPLIST)};
    my %randomWordVectors = (); 

    #iterate over every token in every doc
    foreach my $doc (keys %rawCorpus) { #keys are docs 
        print "DOC is $doc\n";
        $docVecQuery->execute($doc);
        my @row = @{$docVecQuery->fetchrow_arrayref()};
        #print Dumper($rowRef);

        my $docVecJSON = pop(@row);
        my $docVecRef = decode_json($docVecJSON); #tested
        #print Dumper($docVecRef);

        my %tokenHash = %{$rawCorpus{$doc}};
        foreach my $token (keys %tokenHash) {
            my $tokenWeight = $tokenHash{$token};
            my $weightedVecRef = &weightVector($docVecRef, $tokenWeight); 
            if (exists $randomWordVectors{$token}) {
                 #TEST
                 #print "The word: $token already exists\n";
                 my $currentVecRef = $randomWordVectors{$token};  
                 my $summedWordVecRef = &sumVectors($currentVecRef, $weightedVecRef);  
                 $randomWordVectors{$token} = $summedWordVecRef;
             } else {
                 #print "$token is a new word\n";
                 $randomWordVectors{$token} = $weightedVecRef;
             }
        }
    }
    #TEST
    #foreach my $word (keys %randomWordVectors) {
    #    print "WORD IS: $word\n";
    #    print "ITS VECTOR IS: ";
    #    print Dumper($randomWordVectors{$word});
    #}
#TODO
#   return the random word vectors hashref
#   load the random word vectors into the DB
    return \%randomWordVectors;
}

sub weightVector { #TODO: REMEMBER THAT SOME WEIGHTS ARE CURRENTLY NEGATIVE!!
    my ($vecRef, $weight) = @_;
    my %docVec = %{$vecRef};
    my %weightedDocVec = (); 
    #multiply each cell by the word's weight for this doc
    foreach my $key (keys %docVec) {
        my $currentVal = $docVec{$key};
        my $newWeight = $currentVal * $weight;  
        $weightedDocVec{$key} = $newWeight; 
    }
    return \%weightedDocVec;           
}
#TEST
#TODO: THIS IS THE CURRENT ENTRY POINT
#&test('apple');
#&test('shape');
#&test('gene');
#&test('amazing');
#&test('sausage');

#&createDBWordVectors();
#my $wordVectorsRef = &createWordVectors();        
#print Dumper($wordVectorsRef);
#&input();
sub input {
    print "Enter a word to test, or type q: \n";
    my $input = <STDIN>;
    if ($input eq 'q') {
        print "see ya...\n";
        exit;
    } else {
        my $testWord = $input;
        &test($testWord);
        &input();
    }
}
sub test {
    my $w = shift;
    chomp($w);
    print "WORD: $w\n";
    my $wordVectorsRef = &createDBWordVectors();
    my %wordVectors = %$wordVectorsRef;
    #my $randWord = (keys %wordVectors)[rand keys %wordVectors]; 
    #print "RANDOM WORD: $randWord\n";
    #my $w = 'tomato';
    #my $w = 'rabbit';
    &rankWords($w, $wordVectorsRef);
}

sub rankWords {
    my ($w, $wordVectorsRef) = @_;
    my %wordVectors = %$wordVectorsRef;
    my $wordVecRef = $wordVectors{$w};
    my $topMatch = "";
    my $valBuffer = 0;
    my %scores = ();
    foreach my $key (keys %wordVectors) {
        #if ($key ne $randWord) {
            my $candidateVecRef = $wordVectors{$key};
            my $cossim = &cosSim($wordVecRef, $candidateVecRef); 
            if ($cossim > $valBuffer) { $topMatch = $key; $valBuffer = $cossim };
            $scores{$key} = $cossim;
        #}
        
    }
    print "TOP MATCH: $topMatch, COSSIM: $valBuffer\n";
    my $i = 0;
    foreach (sort {$scores{$b} <=> $scores{$a}} keys (%scores)) {
        my $match = $_;
        $i++;
        if ($i < 50) {
            print "$i: $match\n";
        }
        else {
            last;
        }
    }
}    

1;
