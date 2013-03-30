#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper;
#TOKENIZATION MODULES
use tokenize;
use reverseTok;

#CORPUS ARGUMENTS
my $STOPLIST = 'stopwords.en.list';


#TEST
#open my $context, '<', 'test/set-tools.txt';
#my $rawContext = do { local $/; <$context> };
#&tokenizeString($rawContext, 'stopwords.en.list');
#open OUT, '<', '100.out';
#&buildRawTokenHash('/home/chris/data/pig_output/uri_to_context/small/from1000min2.TSV', 'stopwords.en.list');
#&buildRawTokenHash('/home/chris/data/pig_output/uri_to_context/small/from100000_context3to100.TSV', 'stopwords.en.list');
#END_TEST
sub getDocNames {
    print "Inside doc names...\n";
    my $input = shift;
    print "INPUT IS: $input\n";
    open IN, '<', $input or die $!;
    my %docNames = ();
    while (my $l = <IN>) {
        chomp($l);
        my ($uri, $context) = split("\t", $l);
        $docNames{$uri} = 1;
    }
    close IN;
    return \%docNames;
}

sub buildRawTokenHash {
    my ($input, $stoplist) = @_;
    print "BUILDING THE TOKEN HASH FOR THE CORPUS AT LOCATION:\t\n $input \n";
    open OUT, '<', $input or die $!;
    my %allDocs = ();
    my %stops = %{&stopHash($stoplist)};
    my $c = 0;
    while (my $l = <OUT>) {
        chomp($l);
        my ($uri, $context) = split("\t", $l);
        my $spaceDelimit = &tokenize($context);
        my $detokenized = &detokenize($spaceDelimit);
        $detokenized =~ s/ [[:punct:]]/ /g;  
        $detokenized =~ s/[[:punct:]] / /g;  
        $detokenized =~ s/ [A-Za-z]{1,2} / /gi;
        $detokenized =~ s/ [^A-Za-z]+ / /g;
        #remove beginning whitespace
        $detokenized =~ s/^\s//;
        $detokenized =~ s/\s$//;

        my @tokens = split(/\s+/, $detokenized);
        #my @noStops = map { !(exists $stops{$_}) ? $_ : () } @tokens;
        my %noStops = ();
        foreach my $key (@tokens){
            if (!exists $stops{$key}) {
                $noStops{$key} += 1;
            }
        }
        $c++;
        if (($c % 100) == 0) {
            print "PARSED $c DOCS...\n";
        }    
        my @subs = split('/', $uri); 
        my $name = pop(@subs);
 
        $allDocs{$name} = \%noStops;
    }
    #TEST
    #print "HERE IS THE RAW CORPUS: \n";
    #print Dumper(%allDocs);
    #END TEST
    return \%allDocs;
}

sub tokenizeString {
    #my ($context, $stoplist) = @_;
    my $context = shift;
    my %stops = %{&stopHash($STOPLIST)};
    chomp($context);
    my $spaceDelimit = &tokenize($context);
    my $detokenized = &detokenize($spaceDelimit);
    $detokenized =~ s/ [[:punct:]]/ /g;  
    $detokenized =~ s/[[:punct:]] / /g;  
    $detokenized =~ s/ [A-Za-z]{1,2} / /gi;
    $detokenized =~ s/ [^A-Za-z]+ / /g;
    #remove beginning whitespace
    $detokenized =~ s/^\s//;
    $detokenized =~ s/\s$//;
    my @tokens = split(/\s+/, $detokenized);
    my %noStops = ();
    foreach my $key (@tokens){
        if (!exists $stops{$key}) {
            $noStops{$key} += 1;
        }
    }
    #TEST
    #print "HERE IS THE TOKENIZED CONTEXT: \n";
    #print Dumper(%noStops);
    #END TEST
    return \%noStops;
}
 

 
sub stopHash {
    my $list = shift;
    open STOPS, '<', $list or die $!;
    my %stophash = ();
    while (my $line = <STOPS>) {
        chomp($line);
        $line =~ s/\s//g;
    #    print "word is: $line\n";
        $stophash{$line} = 1;
    }
    close STOPS;
    return \%stophash;
}

1;
