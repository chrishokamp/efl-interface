#!/usr/bin/perl
# this module creates an MD5 hash of URLs and stores into a sql DB;
# given a url, it will retrive the HTML 
# Chris Hokamp 
# WINTER 2013

use strict;
use warnings; 

use DBI;
use mysqlConnector;

#TODO: remember to encode as MD5
#TODO: this script needs different perms since it needs to perform INSERTS
sub storeDoc { #tested
    my ($url, $doc) = @_; 
    my $db = &openDB('randomVecs', 'root', 'hfrawg826'); 
    my $store = $db->prepare("INSERT INTO DocCache (url, html) VALUES (MD5(?), ?) ON DUPLICATE KEY UPDATE html=?");
#TODO: ADD ON DUPLICATE KEY UPDATE
    $store->execute($url, $doc, $doc);
    $db->disconnect();
}

sub getDoc {
    my $url = shift; 
    chomp($url); #to be safe
    my $db = &openDB('randomVecs', 'root', 'hfrawg826'); 
    my $get = $db->prepare("SELECT html FROM DocCache WHERE url = MD5(?)");
#TODO: ADD ON DUPLICATE KEY UPDATE
    $get->execute($url);
    my $ref = $get->fetch;
    my $html = @$ref[0]; #there should be only one cell 
    $db->disconnect();
    return $html;
}
1;
