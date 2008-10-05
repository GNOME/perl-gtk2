#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper tests => 14, noinit => 1;

# $Id$

my $adjustment = Gtk2::Adjustment -> new(0, 0, 100, 1, 5, 10);
isa_ok($adjustment, "Gtk2::Adjustment");

is($adjustment -> lower(1), 0);
is($adjustment -> lower(), 1);

is($adjustment -> upper(99), 100);
is($adjustment -> upper(), 99);

is($adjustment -> value(23), 0);
is($adjustment -> value(), 23);

is($adjustment -> step_increment(2), 1);
is($adjustment -> step_increment(), 2);

is($adjustment -> page_increment(6), 5);
is($adjustment -> page_increment(), 6);

is($adjustment -> page_size(11), 10);
is($adjustment -> page_size(), 11);

$adjustment -> set_value(23);
is($adjustment -> get_value(), 23);

$adjustment -> clamp_page(0, 100);

$adjustment -> changed();
$adjustment -> value_changed();

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
