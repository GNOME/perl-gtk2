#!/usr/bin/perl -w
use strict;

use Gtk2;
use Gtk2::TestHelper tests => 4;

my $adjustment = Gtk2::Adjustment -> new(0, 0, 100, 1, 5, 10);

my $scale = Gtk2::HScale -> new($adjustment);
isa_ok($scale, "Gtk2::Scale");

$scale -> set_digits(5);
is($scale -> get_digits(), 5);

$scale -> set_draw_value(1);
is($scale -> get_draw_value(), 1);

$scale -> set_value_pos("right");
is($scale -> get_value_pos(), "right");

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
