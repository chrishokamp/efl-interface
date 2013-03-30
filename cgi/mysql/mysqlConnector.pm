#!/usr/bin/perl 

#AUTHOR: CHRIS HOKAMP
#Winter 2013
#This module connects to a MySql database and place values into it

use DBI;
use strict;
use warnings;

#pass ($dbName, $tableName, 
sub openDB {
    my ($dbName, $uname, $pwd) = @_;
    my $db = DBI->connect("dbi:mysql:database=$dbName", $uname, $pwd) || die "Cannot connect: $DBI::errstr"; #the password is in plaintext :O
    return $db;
}
1;
