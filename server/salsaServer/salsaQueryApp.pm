#!/usr/bin/perl -w
#This is a test file copied from salsaApp.pl and edited by Chris Hokamp


use ngramModule;

use strict;

use constant HOST_NAME => "lit07.csci.unt.edu";
use constant PORT => 1235;

#&query();

sub query() #pass in the query here
{
	#print "inside the query method\n";	
	my $socket = &connect( HOST_NAME, PORT );

	my $command = $_[0]; #CHRIS# pass the commands as an argment to the &main() method
	chomp( $command );
	my @tokens = split( /\s+/, $command );
	my $method = $tokens[0];
	my $nPlusOne = scalar( @tokens );
	my $n = $nPlusOne - 1;
	my $string = join( " ", @tokens[1..$n] );

		

	if( $method eq "NG" )
	{
		my @results;
		
		&getNgram( $socket, $string, \@results );
		#if( scalar( @results ) == 0 )
		#{
		#	print "$string 0\n" ;
		#}
		#else
		#{
		#	foreach my $result ( @results )
		#	{
		#		print "$result\n" ;
		#	}
		#}


		#TEST
		my $ref = \@results; #Chris - return the results to wordTester.pl
		return $ref;
	}
	elsif( $method eq "CNT" )
	{
		print( &getNgramCount( $socket, $string ), "\n" );
	}
	elsif( $method eq "PRB" )
	{
		print( &getProb( $socket, $string ), "\n" );
	}
	elsif( $method eq "ABS" )
	{
		print( &getAbsDiscountProb( $socket, $string ), "\n" );
	}
	elsif( $method eq "KN" )
	{
		print(  &getKNDiscountProb( $socket, $string ), "\n" );
	}
	elsif( $method eq "KNMC" )
	{
		print(  &getKNMCDiscountProb( $socket, $string ), "\n" );
	}
	elsif( $method eq "DIR" )
	{
		print( &getDirichletProb( $socket, $string ), "\n" );
	}
	elsif( $method eq "DKN" )
	{
		print( &getDKNProb( $socket, $string ), "\n" );
	}
}

1;
