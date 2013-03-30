#!/usr/bin/perl

#This is a client for the LIT SaLSA interface dictionary
#Note that dictServer.pl must be running for the client to work!
#Author: Chris Hokamp
#Fall 2012

use strict;
use warnings;
use IO::Socket;

my $sock = IO::Socket::INET->new(
       		PeerAddr => 'localhost',
       		PeerPort => '2345',
       		Proto => 'tcp',
       		Reuse => 1,
);
die "Could not create socket: $!\n" unless $sock;
$sock->autoflush(1);

sub topSynonyms {
	#print "inside top synonyms\n";
	my $query = $_[0];	
	#to be safe
	chomp($query);
	#print "sending $query to server \n";
	if (length($query) > 0) {
		print $sock $query."\n";
	}
	#TESTING
	#print $sock \0;
	#is this check necessary
        #last if $sock =~ m/^end/gi;       

	#my $res = ();
        #while (my $data = <$sock>) {
	#	$res .= " ".$data;
	#}
	my $res = <$sock>;
	chomp($res);
	#print "res is: $res\n";
	#close($sock); #TODO: for this to work, the socket needs to be created INSIDE the subroutine - fix this in dictClient as well
	
	#my $res = 'test string';
	return $res;
}

1;
