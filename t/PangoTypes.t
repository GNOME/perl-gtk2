#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper tests => 48, noinit => 1;

# $Header$

SKIP: {
  skip("find_base_dir is new in 1.4", 1)
    unless (Gtk2::Pango -> CHECK_VERSION(1, 4, 0));

is(Gtk2::Pango -> find_base_dir("urgs"), "ltr");
}

my $language = Gtk2::Pango::Language -> from_string("de_DE");
isa_ok($language, "Gtk2::Pango::Language");
is($language -> to_string(), "de-de");
is($language -> matches("*"), 1);

SKIP: {
  skip("PangoMatrix is new in 1.6", 44)
    unless (Gtk2::Pango -> CHECK_VERSION(1, 6, 0));

  my $matrix = Gtk2::Pango::Matrix -> new(2.3, 2.3, 2.3, 2.3, 2.3, 2.3);
  isa_ok($matrix, "Gtk2::Pango::Matrix");
  is($matrix -> xx, 2.3);
  is($matrix -> xy, 2.3);
  is($matrix -> yx, 2.3);
  is($matrix -> yy, 2.3);
  is($matrix -> x0, 2.3);
  is($matrix -> y0, 2.3);

  $matrix = Gtk2::Pango::Matrix -> new();
  isa_ok($matrix, "Gtk2::Pango::Matrix");
  is($matrix -> xx, 1);
  is($matrix -> xy, 0);
  is($matrix -> yx, 0);
  is($matrix -> yy, 1);
  is($matrix -> x0, 0);
  is($matrix -> y0, 0);

  $matrix -> translate(5, 5);
  is($matrix -> xx, 1);
  is($matrix -> xy, 0);
  is($matrix -> yx, 0);
  is($matrix -> yy, 1);
  is($matrix -> x0, 5);
  is($matrix -> y0, 5);

  $matrix -> scale(2, 2);
  is($matrix -> xx, 2);
  is($matrix -> xy, 0);
  is($matrix -> yx, 0);
  is($matrix -> yy, 2);
  is($matrix -> x0, 5);
  is($matrix -> y0, 5);

  $matrix -> rotate(0);
  is($matrix -> xx, 2);
  is($matrix -> xy, 0);
  is($matrix -> yx, 0);
  is($matrix -> yy, 2);
  is($matrix -> x0, 5);
  is($matrix -> y0, 5);

  $matrix -> concat($matrix);
  is($matrix -> xx, 4);
  is($matrix -> xy, 0);
  is($matrix -> yx, 0);
  is($matrix -> yy, 4);
  is($matrix -> x0, 15);
  is($matrix -> y0, 15);

  $matrix -> xx(2.3);
  $matrix -> xy(2.3);
  $matrix -> yx(2.3);
  $matrix -> yy(2.3);
  $matrix -> x0(2.3);
  $matrix -> y0(2.3);
  is($matrix -> xx, 2.3);
  is($matrix -> xy, 2.3);
  is($matrix -> yx, 2.3);
  is($matrix -> yy, 2.3);
  is($matrix -> x0, 2.3);
  is($matrix -> y0, 2.3);
}

__END__

Copyright (C) 2004 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
