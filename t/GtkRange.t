#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper tests => 5;

# $Header$

my $adjustment = Gtk2::Adjustment -> new(0, 0, 100, 1, 5, 10);

my $range = Gtk2::HScale -> new($adjustment);
isa_ok($range, "Gtk2::Range");

$range -> set_adjustment($adjustment);
is($range -> get_adjustment(), $adjustment);

$range -> set_update_policy("continuous");
is($range -> get_update_policy(), "continuous");

$range -> set_inverted(1);
is($range -> get_inverted(), 1);

$range -> set_value(23.42);
is($range -> get_value(), 23.42);

$range -> set_increments(1, 5);
$range -> set_range(0, 100);

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
