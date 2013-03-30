#!/usr/bin/perl

use tokenize;

open IN, '<', 'test.txt';
while (my $line = <IN>) {
	chomp($line);
	print &tokenize($line);
}
