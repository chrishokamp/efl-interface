#!/usr/bin/perl

#This is a client for the LIT SaLSA interface dictionary
#Note that dictServer.pl must be running for the client to work!
#Author: Chris Hokamp
#Fall 2012

use strict;
use warnings;
use IO::Socket;

#print "dictClient was called\n";
	my $word = $ARGV[0];
	my $sock = IO::Socket::INET->new(
        	PeerAddr => 'localhost',
        	PeerPort => '2345',
        	Proto => 'tcp',
        	Reuse => 1,
	);
	die "Could not create socket: $!\n" unless $sock;
	$sock->autoflush(1);
	#my $word = $_;	
	#while (<>) {
		#chomp($_);
	#	my $word = $_;
		#print "sending $_ to server \n";
		print $sock $word."\n";
                last if ($word =~ m/^end/gi);       
        	my $res = <$sock>;
		#chomp($res);
	
		print $res;
	#}

	close($sock);

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


