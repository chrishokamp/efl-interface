#!/usr/bin/perl 

#AUTHOR: CHRIS HOKAMP
#Winter 2013

use DBI;
use strict;
use warnings;

#RANDOM INDEXING MODULES
use documentVectors;
use wordVectors;
use lib 'mysql';
use mysqlConnector;
#END RANDOM INDEXING MODULES
#####COLLECTION PARAMETERS#########
my $TSV = '/home/chris/data/pig_output/uri_to_context/small/from100000_context3to100.TSV';
#my $TSV = '100.out';
#######END COLLECTION PARAMETERS####


#(1) CREATE THE DOCUMENT VECTORS
sub docVectorsToDB {
    #TODO: remember that vectors can currently come from TSV or JSON
    my %docVectors = %{&createRawDocVectors($TSV)};
    my $sql = &openDB('randomVecs', 'root', 'hfrawg826'); 
    &truncate($sql, 'DocVectors'); #TO BE SURE THAT THE TABLE DOESN'T EXIST
    my $insert = $sql->prepare("INSERT INTO DocVectors (Doc_Name, Vector) VALUES ( ?, ?)"); 
    foreach my $doc (keys %docVectors) {
          my $vecRef = $docVectors{$doc};  
          my $jsonVec = to_json($vecRef, {utf8 => 1}); 
          #TEST #tested
          #print "Doc Name: $doc\n";
          #print "test json vec: $jsonVec\n";
          $insert->execute($doc, $jsonVec);
    }
    $sql->disconnect();
}
#DROP and RECREATE the TABLE to be SAFE TODO: everything is currently hard-coded
sub truncate {    
    my ($db, $tableName) = @_;
    $db->do(q{TRUNCATE TABLE } . $tableName); 
}    

sub testDB { #tested
    my $sql = &openDB('randomVecs', 'root', 'hfrawg826');
    my $selectAll = $sql->selectall_arrayref("SELECT * FROM DocVectors");

  	foreach my $row (@$selectAll) 
	{    		
		my ($docName, $vector) = @$row;
        print "docName is: $docName\n vector is: $vector\n";
    }
	$sql->disconnect(); #disconnect from the database
}

sub wordVectorsToDB {
    my $wordVectorsRef = shift;
    my %wordVectors = %{$wordVectorsRef};  
    my $sql = &openDB('randomVecs', 'root', 'hfrawg826'); 
    &truncate($sql, 'WordVectors'); #TO BE SURE THAT THE TABLE DOESN'T EXIST
    my $insert = $sql->prepare("INSERT INTO WordVectors (Word, Vector) VALUES ( ?, ?)"); 
    foreach my $w (keys %wordVectors) {
          my $vecRef = $wordVectors{$w};  
          my $jsonVec = to_json($vecRef, {utf8 => 1}); 
          $insert->execute($w, $jsonVec); 
    }
    $sql->disconnect(); 
}

#&docVectorsToDB();
my $wordVecsRef = &createDBWordVectors();
&wordVectorsToDB($wordVecsRef);
#&testDB();
1;

