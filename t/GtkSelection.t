#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper tests => 7;

# $Header$

my $list = Gtk2::TargetList -> new();
isa_ok($list, "Gtk2::TargetList");

$list = Gtk2::TargetList -> new(
  { target => "STRING", flags => "same-app", info => 23 },
  { target => "COMPOUND_TEXT", flags => ["same-app", "same-widget"], info => 42 }
);

isa_ok($list, "Gtk2::TargetList");

$list -> add(Gtk2::Gdk->TARGET_BITMAP, ["same-app", "same-widget"], 2);
$list -> add_table({ target => "COLORMAP", flags => ["same-app", "same-widget"], info => 3 });

$list -> remove(Gtk2::Gdk->TARGET_BITMAP);

is($list -> find(Gtk2::Gdk->TARGET_BITMAP), undef);
is($list -> find(Gtk2::Gdk->TARGET_STRING), 23);

my $window = Gtk2::Window -> new();
$window -> realize();

is(Gtk2::Selection -> owner_set($window,
                                Gtk2::Gdk->SELECTION_PRIMARY,
                                0), 1);

SKIP: {
  skip("GdkDisplay is new in 2.2", 1)
    unless Gtk2->CHECK_VERSION (2, 2, 0);

  is(Gtk2::Selection -> owner_set_for_display(Gtk2::Gdk::Display -> get_default(),
                                              $window,
                                              Gtk2::Gdk->SELECTION_SECONDARY,
                                              0), 1);
}

$window -> selection_add_target(Gtk2::Gdk->SELECTION_CLIPBOARD,
                                Gtk2::Gdk->TARGET_BITMAP,
                                5);

$window -> selection_add_targets(Gtk2::Gdk->SELECTION_PRIMARY,
                                 { target => "drawable", info => 7 },
                                 { target => "pixmap", info => 9 });

$window -> selection_clear_targets(Gtk2::Gdk->SELECTION_CLIPBOARD);

is($window -> selection_convert(Gtk2::Gdk->SELECTION_PRIMARY, Gtk2::Gdk->TARGET_PIXMAP, 0), 1);

$window -> selection_remove_all();

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
