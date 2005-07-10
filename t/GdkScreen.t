#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper
  tests => 21,
  at_least_version => [2, 2, 0, "GdkScreen is new in 2.2"];

# $Header$

my $screen = Gtk2::Gdk::Screen -> get_default();
isa_ok($screen, "Gtk2::Gdk::Screen");

my $colormap = $screen -> get_default_colormap();
isa_ok($colormap, "Gtk2::Gdk::Colormap");

$screen -> set_default_colormap($colormap);

isa_ok($screen -> get_system_colormap(), "Gtk2::Gdk::Colormap");
isa_ok($screen -> get_system_visual(), "Gtk2::Gdk::Visual");
isa_ok($screen -> get_rgb_colormap(), "Gtk2::Gdk::Colormap");
isa_ok($screen -> get_rgb_visual(), "Gtk2::Gdk::Visual");
isa_ok($screen -> get_root_window(), "Gtk2::Gdk::Window");
isa_ok($screen -> get_display(), "Gtk2::Gdk::Display");

like($screen -> get_number(), qr/^\d+$/);
like($screen -> get_width(), qr/^\d+$/);
like($screen -> get_height(), qr/^\d+$/);
like($screen -> get_width_mm(), qr/^\d+$/);
like($screen -> get_height_mm(), qr/^\d+$/);
like($screen -> get_n_monitors(), qr/^\d+$/);
like($screen -> get_monitor_at_point(10, 10), qr/^\d+$/);
like($screen -> get_monitor_at_window($screen -> get_root_window()), qr/^\d+$/);

isa_ok(($screen -> list_visuals())[0], "Gtk2::Gdk::Visual");
$screen -> get_toplevel_windows(); # check retval?

ok(defined($screen -> make_display_name()));

isa_ok($screen -> get_monitor_geometry(0), "Gtk2::Gdk::Rectangle");

# i'm not sure if it's good to do that.
$screen -> broadcast_client_message(Gtk2::Gdk::Event -> new("expose"));

# FIXME: warn $screen -> get_setting("double_click_interval");

SKIP: {
  skip("new 2.8 stuff", 2)
    unless Gtk2->CHECK_VERSION (2, 7, 0); # FIXME: 2.8

  my $visual = $screen -> get_rgba_visual();
  if (defined $visual) {
    isa_ok($visual, "Gtk2::Gdk::Visual");
    isa_ok($screen -> get_rgba_colormap(), "Gtk2::Gdk::Colormap");
  } else {
    ok(1);
    ok(1);
  }
}

__END__

Copyright (C) 2003-2005 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
