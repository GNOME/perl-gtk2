#!/usr/bin/perl -w
use strict;

use Gtk2;
use Gtk2::TestHelper tests => 21;

my $rectangle_one = Gtk2::Gdk::Rectangle -> new(23, 42, 10, 10);
my $rectangle_two = Gtk2::Gdk::Rectangle -> new(23, 42, 15, 15);

isa_ok($rectangle_one -> intersect($rectangle_two), "Gtk2::Gdk::Rectangle");
isa_ok($rectangle_one -> union($rectangle_two), "Gtk2::Gdk::Rectangle");

my $region = Gtk2::Gdk::Region -> new();
isa_ok($region, "Gtk2::Gdk::Region");
ok($region -> empty());

$region = Gtk2::Gdk::Region -> polygon([ 5,  5,
                                        10,  5,
                                         5, 10,
                                        10, 10],
                                       "winding-rule");
isa_ok($region, "Gtk2::Gdk::Region");
is($region -> rect_in(Gtk2::Gdk::Rectangle -> new(7, 7, 1, 1)), "in");
is($region -> rect_in(Gtk2::Gdk::Rectangle -> new(0, 0, 3, 3)), "out");
is($region -> rect_in(Gtk2::Gdk::Rectangle -> new(5, 5, 6, 6)), "part");

$region = Gtk2::Gdk::Region -> rectangle($rectangle_one);
isa_ok($region, "Gtk2::Gdk::Region");
isa_ok($region -> get_clipbox(), "Gtk2::Gdk::Rectangle");
isa_ok(($region -> get_rectangles())[0], "Gtk2::Gdk::Rectangle");
ok($region -> equal($region));
ok($region -> point_in(30, 50));

$region -> spans_intersect_foreach([24, 43, 5,
                                    24, 43, 5],
                                   1,
                                   sub {
  my ($x, $y, $width, $data) = @_;

  is($x, 24);
  is($y, 43);
  is($width, 5);
  is($data, "bla");
}, "bla");

$region -> offset(5, 5);
$region -> shrink(5, 5);
$region -> union_with_rect($rectangle_two);

my $region_two = Gtk2::Gdk::Region -> rectangle($rectangle_two);

$region -> intersect($region_two);
$region -> union($region_two);
$region -> subtract($region_two);
$region -> xor($region_two);
