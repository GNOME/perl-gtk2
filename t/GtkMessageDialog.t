#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper tests => 3, noinit => 1;

# $Header$

my $dialog = Gtk2::MessageDialog -> new(undef,
                                        "destroy-with-parent",
                                        "warning",
                                        "ok-cancel",
                                        "%s, %d", "Bla", 23);
isa_ok($dialog, "Gtk2::MessageDialog");

$dialog = Gtk2::MessageDialog -> new(undef,
                                     "destroy-with-parent",
                                     "warning",
                                     "ok-cancel",
                                     "Bla, 23");
isa_ok($dialog, "Gtk2::MessageDialog");

SKIP: {
  skip("new_with_markup and set_markup are new in 2.3", 1)
    if (Gtk2 -> check_version(2, 3, 0));

  $dialog = Gtk2::MessageDialog -> new_with_markup(undef,
                                                   "destroy-with-parent",
                                                   "warning",
                                                   "ok-cancel",
                                                   "<span>Bla, 23</span>");
  isa_ok($dialog, "Gtk2::MessageDialog");

  $dialog -> set_markup("<span>Bla, 23</span>");
}

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
