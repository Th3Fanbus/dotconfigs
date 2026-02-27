#!/usr/bin/env perl

use strict;
use warnings;

use builtin qw(true false);
use feature qw(switch);
use File::Basename;
use File::Spec::Functions;
use List::Util qw(min max);

sub clamp
{
	my ($lower, $value, $upper) = @_;
	return max($lower, min($value, $upper));
}

sub read_backlight_value
{
	my ($backlight_dev, $prop_name) = @_;
	my $filename = catfile($backlight_dev, $prop_name);
	open(my $fh, '<', $filename) or die $!;
	my $value = <$fh>;
	chomp $value;
	return $value;
}

sub write_backlight_value
{
	my ($backlight_dev, $prop_name, $value) = @_;
	my $filename = catfile($backlight_dev, $prop_name);
	open(my $fh, '>', $filename) or die $!;
	print $fh $value;
	close $fh or die $!;
}

sub usage
{
	my $prog_name = fileparse($0);
	print "Usage:\n";
	print "    Set brightness:      $prog_name      <percent>\n";
	print "    Change brightness:   $prog_name {+|-}<percent>\n";
}

my ($percent) = @ARGV;
if (not defined $percent) {
	usage();
	exit 22; # EINVAL
}

my $is_delta = $percent =~ m/^(\+|-)/;

foreach my $backlight_dev (glob ("/sys/class/backlight/*")) {
	# TODO: use actual_brightness instead?
	my $current = read_backlight_value($backlight_dev, "brightness");
	my $maximum = read_backlight_value($backlight_dev, "max_brightness");
	my $new_value = $percent * $maximum / 100;
	if ($is_delta) {
		$new_value += $current;
	}
	my $new_brightness = int(clamp(0, $new_value, $maximum));
	write_backlight_value($backlight_dev, "brightness", $new_brightness);
	print fileparse($backlight_dev) . ": $current ---> $new_brightness\n";
}
