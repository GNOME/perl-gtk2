#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper tests => 20;

# $Header$

my $window = Gtk2::Window -> new();
$window -> realize();

my $name = Gtk2::Gdk::Atom -> intern("WM_ICON_NAME", 1);
my $strut = Gtk2::Gdk::Atom -> intern("_NET_WM_STRUT", 0);
my $strut_partial = Gtk2::Gdk::Atom -> intern("_NET_WM_STRUT_PARTIAL", 0);

my $string = Gtk2::Gdk::Atom -> new("STRING");
my $cardinal = Gtk2::Gdk::Atom -> new("CARDINAL");

foreach ($name, $strut, $strut_partial, $string, $cardinal) {
  isa_ok($_, "Gtk2::Gdk::Atom");
}

is($name -> name(), "WM_ICON_NAME");
is($strut -> name(), "_NET_WM_STRUT");
is($strut_partial -> name(), "_NET_WM_STRUT_PARTIAL");
is($string -> name(), "STRING");
is($cardinal -> name(), "CARDINAL");

$window -> window() -> property_change($name, $string, Gtk2::Gdk::CHARS, "replace", "Bla Bla Bla");
$window -> window() -> property_change($strut, $cardinal, Gtk2::Gdk::USHORTS, "replace", 0, 0, 26, 0);
$window -> window() -> property_change($strut_partial, $cardinal, Gtk2::Gdk::ULONGS, "replace", 0, 0, 26, 0, 0, 0, 0, 0, 0, 1279, 0, 0);

my ($atom, $format, @data);

($atom, $format, @data) = $window -> window() -> property_get($name, $string, 0, 1024, 0);
is($atom -> name(), "STRING");
is($format, Gtk2::Gdk::CHARS);
is(@data, 1);
is($data[0], "Bla Bla Bla");

($atom, $format, @data) = $window -> window() -> property_get($strut, $cardinal, 0, 1024, 0);
is($atom -> name(), "CARDINAL");
is($format, Gtk2::Gdk::USHORTS);
is_deeply([@data], [0, 0, 26, 0]);

($atom, $format, @data) = $window -> window() -> property_get($strut_partial, $cardinal, 0, 1024, 0);
is($atom -> name(), "CARDINAL");
is($format, Gtk2::Gdk::ULONGS);
is_deeply([@data], [0, 0, 26, 0, 0, 0, 0, 0, 0, 1279, 0, 0]);

$window -> window() -> property_delete($name);
$window -> window() -> property_delete($strut);
$window -> window() -> property_delete($strut_partial);

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
