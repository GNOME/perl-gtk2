#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper tests => 4;

# $Header$

my $window = Gtk2::Window -> new();
$window -> realize();

SKIP: {
  skip("Doesn't seem to be the X11 backend", 4)
    unless ($window -> window() -> can("get_xid"));

  like($window -> window() -> get_xid(), qr/^\d+$/);
  like($window -> window() -> XID(), qr/^\d+$/);
  like($window -> window() -> XWINDOW(), qr/^\d+$/);

  SKIP: {
    skip("GdkDisplay is new in 2.2", 0)
      unless Gtk2->CHECK_VERSION (2, 2, 0);

    my $display = Gtk2::Gdk::Display -> get_default();

    $display -> grab();
    $display -> ungrab();
  }

  SKIP: {
    skip("2.6 stuff", 0)
      unless Gtk2->CHECK_VERSION (2, 6, 0);

    $window -> window() -> set_user_time(time());
  }

  SKIP: {
    skip("new 2.8 stuff", 1)
      unless Gtk2->CHECK_VERSION (2, 8, 0);

    my $display = Gtk2::Gdk::Display -> get_default();

    $display -> set_cursor_theme("just-testing", 23);
    like($display -> get_user_time(), qr/^\d+$/);
  }
}

__END__

Copyright (C) 2003-2005 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
