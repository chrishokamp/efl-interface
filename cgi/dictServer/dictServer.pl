#!/usr/bin/perl

#This is a server for the LIT SaLSA interface
#Author: Chris Hokamp

use strict;
use warnings;
use IO::Socket;

my %words = ();

if (@ARGV != 1) {
	die "the number of arguments is wrong\nUsage: perl dictServer.pl wordlist_file.txt\n";
}

print "Starting server...\n";
my $synListFile = $ARGV[0];

#a file with one word on each line
open SYN, '<', $synListFile or die "Couldn't read synonyms file: $!\n";
while (my $word = <SYN>) {
	chomp($word);
	$words{$word} = 1;
}
close SYN;
	
my $sock = new IO::Socket::INET (
	LocalHost => 'localhost',
	LocalPort => '3456',
	Proto => 'tcp',
	Listen => 100,
	Reuse => 1,
	);
die "Could not create socket: $!\n" unless $sock;
print "Server is running\n";
#$sock->autoflush(1);
my $client;
while($client = $sock->accept()) {
	#my $new_sock = $sock->accept();
	#TODO: ensure that the query is a single word
	print "inside while...\n";
	#my $text = ();
	while(<$client>) {
        	#test
        	#print $_;
	    my $word = $_;
		chomp($word);
		print "Server-side word is $word\n";
	     	#$text .= $word;
	        my $bool = &check($word);	
		print "bool is $bool\n";
        print "returning $bool for word: $word\n";
		print $client "$bool\n";
	 	#chomp();
		#if (m/^end/gi) {        #Chris: this part taken from http://www.conceptsolutionsbc.com/perl-articles-mainmenu-41/25-modules-and-packages/54-writing-client-server-applications-using-iosocket
                #	print $client "$bool\n";          # send the result message
                #	print "Result: $bool\n";        # Display sent message
        	#}
    	
                	                        # to client is closed
       	}
        #my $bool = &check($text);	
	#print $client "$bool";
	print "Closed connection\n";    # Inform that connection 
 	close $client;    # close client	
}
#close($sock);


#Steps
#(1) load the words from a file into a hash 
#(2) open a socket

#returns 1 if we know the word, 0 if we don't
sub check {
	my $word = $_[0];

	if (exists $words{$word}) {
		print "true, I have $word\n";
		return 'true';
	} else {
		return 'false';
		#print "false, I don't have $word\n";
	}
}

#on Exit - how to kill?
