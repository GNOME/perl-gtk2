#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper tests => 5;

my $cursor = Gtk2::Gdk::Cursor -> new("watch");
isa_ok($cursor, "Gtk2::Gdk::Cursor");
is($cursor -> type(), "watch");

# FIXME: new_from_pixmap

SKIP: {
  skip("new_from_pixbuf is new in 2.3", 1)
    if (Gtk2 -> check_version(2, 3, 0));

  my $display = Gtk2::Gdk::Display -> get_default();
  my $pixbuf = Gtk2::Gdk::Pixbuf -> new("rgb", 0, 8, 10, 10);

  $cursor = Gtk2::Gdk::Cursor -> new_from_pixbuf($display, $pixbuf, 5, 5);
  isa_ok($cursor, "Gtk2::Gdk::Cursor");
}

SKIP: {
  skip("new_for_display is new in 2.2", 2)
    if (Gtk2 -> check_version(2, 2, 0));

  my $display = Gtk2::Gdk::Display -> get_default();

  $cursor = Gtk2::Gdk::Cursor -> new_for_display($display, "watch");
  isa_ok($cursor, "Gtk2::Gdk::Cursor");
  is($cursor -> get_display(), $display);
}

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.