#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper tests => 57, noinit => 1;

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
  skip "1.16 stuff", 1
    unless Gtk2::Pango -> CHECK_VERSION(1, 15, 2); # FIXME: 1.16


  isa_ok(Gtk2::Pango::Language -> get_default(), "Gtk2::Pango::Language");
}

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

SKIP: {
  skip "1.16 stuff", 8
    unless Gtk2::Pango -> CHECK_VERSION(1, 15, 2); # FIXME: 1.16

  my $matrix = Gtk2::Pango::Matrix -> new(); # identity

  is_deeply([$matrix -> transform_distance(1.0, 2.0)], [1.0, 2.0]);

  is_deeply([$matrix -> transform_point(1.0, 2.0)], [1.0, 2.0]);

  my $rect = {x => 1.0, y => 2.0, width => 23.0, height => 42.0};
  is_deeply($matrix -> transform_rectangle($rect), $rect);
  is_deeply($matrix -> transform_pixel_rectangle($rect), $rect);

  is(Gtk2::Pango::units_from_double(Gtk2::Pango::units_to_double(23)), 23);

  my ($new_ink, $new_logical) = Gtk2::Pango::extents_to_pixels($rect, $rect);
  isa_ok($new_ink, "HASH");
  isa_ok($new_logical, "HASH");

  is_deeply([Gtk2::Pango::extents_to_pixels(undef, undef)], [undef, undef]);
}

__END__

Copyright (C) 2004 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
