#!/usr/bin/perl -w
# vim: set ft=perl :
use strict;
use Glib qw/TRUE FALSE/;
use Gtk2;
use Test::More;

if (! (UNIVERSAL::can("Gtk2::Gdk::Cairo::Context", "create") &&
       Gtk2 -> CHECK_VERSION(2, 8, 0))) {
  plan skip_all => "Need Cairo";
} elsif (! Gtk2->init_check) {
  plan skip_all => "Gtk2->init_check failed, probably unable to open DISPLAY";
} else {
  plan tests => 2;
}

# $Header$

my $window = Gtk2::Window -> new();
$window -> realize();

my $context = Gtk2::Gdk::Cairo::Context -> create($window -> window);
isa_ok($context, "Gtk2::Gdk::Cairo::Context");
isa_ok($context, "Cairo::Context");

my $color = Gtk2::Gdk::Color -> new(0xffff, 0xffff, 0xffff);
$context -> set_source_color($color);

my $pixbuf = Gtk2::Gdk::Pixbuf -> new("rgb", FALSE, 8, 100, 100);
$context -> set_source_pixbuf($pixbuf, 10, 10);

my $rectangle = Gtk2::Gdk::Rectangle -> new(10, 10, 10, 10);
$context -> rectangle($rectangle);

my $region = Gtk2::Gdk::Region -> new();
$context -> region($region);

# Making sure it's still a valid Cairo::Context ...
$context -> set_operator("clear");
$context -> rectangle(0, 0, 10, 10);

SKIP: {
    skip "set_source_pixmap is new in gtk+ 2.10", 0
        unless Gtk2 -> CHECK_VERSION(2, 10, 0);

    my $pixmap = Gtk2::Gdk::Pixmap -> new($window->window, 20, 20, -1);
    $context -> set_source_pixmap($pixmap, 10, 10);
}

__END__

Copyright (C) 2005-2008 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
