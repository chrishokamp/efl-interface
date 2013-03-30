#!/usr/bin/perl

#This is a client for the LIT SaLSA interface dictionary
#Note that dictServer.pl must be running for the client to work!
#Author: Chris Hokamp
#Fall 2012

use strict;
use warnings;
use IO::Socket;

open LOG, '>>', 'clientLog.txt' or die $!;
my $sock = IO::Socket::INET->new(
       		PeerAddr => 'localhost',
       		PeerPort => '3456',
       		Proto => 'tcp',
       		Reuse => 1,
);
die "Could not create socket: $!\n" unless $sock;
$sock->autoflush(1);

sub checkWord {

	#for (@words) {
	#my $word = $_;	
	my $word = $_[0];
	#to be safe
	chomp($word);
	#print "sending $word to server \n";
	print $sock $word."\n";
	
	#is this check necessary
        last if m/^end/gi;       
        my $res = <$sock>;
	chomp($res);
        	
	print LOG "res is: $res for word: $word\n";
	return $res;
}
#close($sock);

#TEST
#while (<>) {
#	print $sock $_;

#	last if m/^end/gi;
#	
#	my $res = <$sock>;
#	print "the response was $res\n";
	#print $sock "rabbit";
	#print $sock "test";
#}
#close($sock);

1;
