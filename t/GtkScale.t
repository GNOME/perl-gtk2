#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper tests => 6;

# $Id$

my $adjustment = Gtk2::Adjustment -> new(0, 0, 100, 1, 5, 10);

my $scale = Gtk2::HScale -> new($adjustment);
isa_ok($scale, "Gtk2::Scale");

$scale -> set_digits(5);
is($scale -> get_digits(), 5);

$scale -> set_draw_value(1);
is($scale -> get_draw_value(), 1);

$scale -> set_value_pos("right");
is($scale -> get_value_pos(), "right");

SKIP: {
  skip("get_layout and get_layout_offsets are new in 2.4", 2)
    unless Gtk2->CHECK_VERSION (2, 4, 0);

  isa_ok($scale -> get_layout(), "Gtk2::Pango::Layout");
  is(@{[$scale -> get_layout_offsets()]}, 2);
}

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
