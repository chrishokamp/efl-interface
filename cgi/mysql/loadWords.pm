#!/usr/bin/perl 

#AUTHOR: CHRIS HOKAMP
#Winter 2013
#This module creates the word tables for online WSD/lexical substitution

#WORD TABLE
#WORD|POS|SYNSET(TODO remember that POS may not be obvious, as text is untokenized 
#Each row must be unique, but none of the columns are unique by themselves

#SYNSET TABLE
#WORD-->SYNSET ID

use strict;
use warnings;

use DBI;
use JSON;
use Data::Dumper;


#RANDOM INDEXING MODULES
use mysqlConnector;
use lib '..';
use loadVectors;

#STEPS:
#Load the JSON file of synonyms
#xbuild the structure word{pos}{synsetID}
sub loadJSONDictionary {
    my $INPUT = shift;
    open my $thesaurus, '<', $INPUT or die "error opening $INPUT: $!";
    my $docsJson = do { local $/; <$thesaurus> }; 
    close $thesaurus;
    my $decoded = decode_json($docsJson);
    my %master = %{$decoded};
    #TEST
    #print Dumper($decoded);
    #END TEST

    #MAKE A SYNSET HASH WITH INT IDs, map each word to its synsets
    my %synsets = ();
    my $synIndex = 0;
    my %wordsToSynsets = ();
    foreach my $word (keys %master) {
        #print "WORD IS: $word\n";
        foreach my $pos (keys %{$master{$word}}) {
            #print "\tPOS: $pos\n";
            my $words = $master{$word}{$pos};
            #UNDERSCORES-->WHITESPACE
            $words =~ s/_/ /g;
            my @wordList = split(';', $words);
            $synsets{$synIndex} = \@wordList;
            foreach my $w (@wordList) {
                #print "\t\t$w\n"; 
                if (exists $wordsToSynsets{$w}{$pos}) {
                    my @idList = @{$wordsToSynsets{$w}{$pos}};
                    push (@idList, $synIndex);
                    $wordsToSynsets{$w}{$pos} = \@idList;
                } else {
                    my @idList = ($synIndex);
                    $wordsToSynsets{$w}{$pos} = \@idList;
                }
            }
            $synIndex++;
        }
   }
   #TEST #tested
   #print Dumper(%wordsToSynsets);
   #print Dumper(%synsets);
   return (\%wordsToSynsets, \%synsets);
}
#TESTING
my ($wRef, $sRef) = &loadJSONDictionary('../test/jsonSynonyms.json');
&buildTables($wRef, $sRef);

sub buildTables {
    my ($wordsRef, $synsetRef) = @_;
    my %wordsToSynsets = %{$wordsRef};
    my %synsets = %{$synsetRef};
    my $db = &openDB('randomVecs', 'root', 'hfrawg826');
    &truncate($db, 'words');
    &truncate($db, 'synsets');
    my $insertWords = $db->prepare("INSERT INTO words (word, pos, synsets) VALUES (?, ?, ?)");
    #INSERT WORDS
    foreach my $word (keys %wordsToSynsets) {
        my $w = $word;
        foreach my $pos (keys %{$wordsToSynsets{$word}}) {
            my @synsets = @{$wordsToSynsets{$word}{$pos}};
            my $asString = join(';', @synsets);
            $insertWords->execute($w, $pos, $asString);
        }
    }  
    #INSERT SYNSETS
    my $insertSyns = $db->prepare("INSERT INTO synsets (synsetID, synList) VALUES (?, ?)");
    foreach my $id (keys %synsets) {
        my @wordList = @{$synsets{$id}}; 
        my $asString = join(';', @wordList);
        $insertSyns->execute($id, $asString);
    }
}

1;


