#!/usr/bin/env perl
use strict;
use warnings;

#use Time::HiRes 'sleep';

my $filename = $ARGV[0] or die "Usage: $0 <file>\n";
my $filename_template = 'template.gp';

#my $geometry = "-geometry 320x240+0+0";
#open my $fh_gnuplot, "|gnuplot $geometry" or die "Can't |gnuplot: $!\n";
#open my $fh_gnuplot, "|gnuplot -gray " or die "Can't |gnuplot: $!\n";
open my $fh_gnuplot, "|gnuplot " or die "Can't |gnuplot: $!\n";

#$SIG{INT} = sub { close $fh_gnuplot; exit; };

#use IO::Handle 'autoflush';
#$fh_gnuplot->autoflush(1);

my $template = -e $filename_template ?
	slurp($filename_template) : '';

print $fh_gnuplot $template;

my $mtime_prev = 123;

for (; 1; sleep 0.5) {
	my $mtime_this = (stat($filename))[9];
	my $is_modified = $mtime_this != $mtime_prev;

	next unless ($is_modified);

	$mtime_prev = $mtime_this;

	my $text = slurp($filename);

	print '-' x 80;
	print "\n$text\n";

	print $fh_gnuplot "$text\n";
}

sub slurp {
	my $filename = shift;
	open my $fh, $filename or die "Can't open $filename: $!\n";
	local $/;
	my $text = <$fh>;
	close $fh;
	return $text;
}
