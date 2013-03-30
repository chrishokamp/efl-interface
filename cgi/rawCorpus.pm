#!/usr/bin/perl
#Author: Chris Hokamp
#Winter 2013
#iterate over a TSV file where documents are on one line each, initialize one random vector for each doc

use strict;
use warnings;
use Data::Dumper;

#RANDOM INDEXING MODULES
use create_vector;

#####COLLECTION PARAMETERS#########
my $DIMENSIONALITY = 10000;
my $CELLS_PER_VECTOR = 30;
my $OUTPUT = 'docVectors.json';
#my $DOCUMENTS = '/home/chris/data/pig_output/tfidf-json/top250-filter20/tfidf_token_weights-top250-filter20.json';
my $DOCUMENTS = '/home/chris/projects/random_indexing/data/
#######END COLLECTION PARAMETERS####


