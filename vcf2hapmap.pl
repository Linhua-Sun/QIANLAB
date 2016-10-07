#!/usr/bin/perl -w
##Filename:
##Author: Li Cuiping
##Date: 2016-07-21
##Modified:
##Description: LD decay plot.
my $version=1.00;

use strict;
use Getopt::Long;

my %opts;
GetOptions(\%opts,"i=s","o=s","h");
if (!(defined $opts{i} and defined $opts{o}) || defined $opts{h}) { #necessary arguments
&usage;
}

open OUT,">$opts{o}";
open IN,"<$opts{i}";
my @sample;
while (my $aline=<IN>) {
	next if($aline=~/^\#\#/);
	chomp $aline;
	my @arr=split /\t/,$aline;
	print OUT "$arr[0]\t$arr[1]\t$arr[3]\t$arr[4]";
	if ($aline=~/^\#CHROM/) {
		for (my $i=9;$i<=$#arr ;$i++) {
			push @sample,$arr[$i];
			print OUT "\t$arr[$i]";
		}
		print OUT "\n";
	}else{
		my @allele;
		$allele[0]=$arr[3];
		if ($arr[4]!~/\,/) {
			push @allele,$arr[4];
		}else{
			$arr[4]=~s/\*/-/g;
			my @crr=split /,/,$arr[4];
			push @allele,@crr;
		}
		for (my $i=9;$i<=$#arr ;$i++) {
			my $geno="NN";;
			my @brr=split /:/,$arr[$i];
			if ($brr[0]!~/\.\/\./) {
				my @drr=split /\//,$brr[0];
				$geno="$allele[$drr[0]]$allele[$drr[1]]";
			}
			if ($geno=~/-/) {
				$geno="-";
			}
			print OUT "\t$geno";
		}
		print OUT "\n";
	}
}

sub usage{
print <<"USAGE";
Version $version
Description: LD decay plot.
Usage:
$0 -i -w -o
options:
-i input LD file #haploview output file
-w input window distance #default is 100bp
-h help
USAGE
exit(1);
}
