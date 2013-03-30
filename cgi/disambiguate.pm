#!/usr/bin/perl
#Author: Chris Hokamp
#Winter 2013

use strict;
use warnings;

use lib '/home/chris/perl5/lib/perl5', 'mysql/';
use JSON;
#use Data::Dumper;

use rawTokenize;
use sum_vectors;
use wordVectors;
use cossim;
use mysqlConnector;

#open my $context, '<', 'test/set-tools.txt';
#open my $context, '<', 'test/bat-animal.txt';
#open my $context, '<', 'test/bright-color.txt';
#open my $context, '<', 'test/bright-website.txt';
#open my $context, '<', 'test/bright-smart.txt';
#open my $context, '<', 'test/bright-smart2.txt';
#open my $context, '<', 'test/bright-smart-3.txt';

#my $rawContext = do { local $/; <$context> };
#&parseContext($rawContext);
#TODO: ADD CODE TO TAG A WORD AS HEAD DYNAMICALLY -- SEE SALSA TAGGER

#(1) TAKE A CONTEXT WITH A WORD MARKED AS <head>word</head>
#(2) BUILD A CONTEXT VECTOR BY SUMMING THE VECTORS FOR THE WORDS IN THE HEADWORD's CONTEXT
#(3) RETRIEVE ALL POSSIBLE DISAMBIGUATIONS OF THE WORD
#(4) COMPARE THE CONTEXT VECTOR WITH EACH POSSIBLE DISAMBIGUATION AND RANK

sub parseContext {
    my $context = shift;
    my $hw = "";
    if ($context =~ /<head>(.+)<\/head>/) {
        $hw = $1;
        #print "Head word is: $hw\n";
        $context =~ s/<head>//;
        $context =~ s/<\/head>//;
    } else {
        die "Headwords must be tagged with <head></head>\n";
    }
    my $tokenRef = &tokenizeString($context);
    my %tokens = %{$tokenRef};
    my $db = &openDB('randomVecs', 'root', 'hfrawg826'); 
    my %contextVec = ();
    foreach my $token (keys %tokens) {
        my $count = $tokens{$token};        
        #print "COUNT FOR TOKEN: $token = $count\n";
        my $res = &getWordVector($token, $db);
        if ($res != 0) {
            my $weighted = &weightVector($res, $count);
            my %current = %contextVec;
            my $summedRef = &sumVectors(\%current, $weighted);
            %contextVec = %{$summedRef};
        }
    }
    my $candRef = &getCandidates($hw, $db);
    my @candidates = @{$candRef};
    my %candidateVecs = ();
    foreach my $cand (@candidates) {
        my $res = &getWordVector($cand, $db);
        if ($res != 0) {
            $candidateVecs{$cand} = $res;
        }
    }
    #TEST
    my $results = &bestMatches(\%contextVec, \%candidateVecs, 10);
    return $results;
}

#TODO: add parameter substitution for table name
sub getWordVector {
    my ($word, $db) = @_;
    #print "INSIDE WORD VECTORS, WORD IS $word\n";
    my $q = $db->prepare("SELECT Vector FROM AbstractWordVectors WHERE Word = ?");
    $q->execute($word);
    if ($q->rows > 0) {
        my @row = @{$q->fetchrow_arrayref()};
        #print Dumper($rowRef);

        my $docVecJSON = pop(@row);
        my $docVecRef = decode_json($docVecJSON); #tested
        #print Dumper($docVecRef);
        return $docVecRef;
    } else { 
        return 0;
    }
}

#get all candidate synonyms for a word
#TODO: ADD POS TAGS INFO 
sub getCandidates {
    my ($headWord, $db) = @_;
    #print "GETTING CANDIDATES, headword is $headWord \n";
    my $q = $db->prepare("SELECT synsets FROM words WHERE word=?");
    #NOW ITERATE OVER ROWS, and SPLIT OUT ALL SYNSET IDS, THEN GET ALL WORDS IN ALL SYNSETS    
    $q->execute($headWord); 
    my $synLists;
    $q->bind_columns(undef, \$synLists);
    my @allWords = ();
    my $numRows = $q->rows;
    #print "THE QUERY RETURNED $numRows rows...\n";
    while($q->fetch()) {
        #print "SYNLIST: $synLists\n";
        my @listElements = split(';', $synLists);
        my $synQuery = $db->prepare("SELECT synList FROM synsets WHERE synsetID=?");
        foreach my $list (@listElements) {
            chomp($list);
            #print ("LISTID IS: $list\n"); 
            my $words;
            $synQuery->execute($list);
            $synQuery->bind_columns(undef, \$words);
            while ($synQuery->fetch()) {
                #print "WORDS: $words\n";
                my @wordList = split(';', $words);
                push (@allWords, @wordList);
            }
        }
    }
    #TEST
    #foreach my $cand (@allWords) {
    #    print "CANDIDATE: $cand\n"; 
    #}
    return \@allWords;
}

sub bestMatches {
    my ($wordVecRef, $candidatesRef, $numMatches) = @_;
    #print "WORD VEC REF: \n";
    #print Dumper($wordVecRef);
    my @topMatches = ();
    my %candidates = %$candidatesRef;
    my $topMatch = "";
    my $valBuffer = 0;
    my %scores = ();
    foreach my $key (keys %candidates) {
        #if ($key ne $randWord) {
            #print "TESTING CANDIDATE: $key\n";
            my $candidateVecRef = $candidates{$key};
            #print "CANDIDATE VECTOR: \n";
            #print Dumper($candidateVecRef);
            my $cossim = &cosSim($wordVecRef, $candidateVecRef); 
            #print "COSINE SIM: $cossim\n";
            if ($cossim > $valBuffer) { $topMatch = $key; $valBuffer = $cossim };
            $scores{$key} = $cossim;
#        #}
    }
    #print "TOP MATCH: $topMatch, COSSIM: $valBuffer\n";
    my $i = 0;
    foreach (sort {$scores{$b} <=> $scores{$a}} keys (%scores)) {
        my $match = $_;
        $i++;
        if ($i < $numMatches) {
            push (@topMatches, $match);
            #print "$i: $match\n";
        }
        else {
            last;
        }
    }
    my $best = join(';', @topMatches);
    return $best;
}

1;
