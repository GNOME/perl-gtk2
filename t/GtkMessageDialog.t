#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper tests => 5;

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

$dialog = Gtk2::MessageDialog -> new(undef,
                                     "destroy-with-parent",
                                     "warning",
                                     "ok-cancel",
                                     undef);
isa_ok($dialog, "Gtk2::MessageDialog");

SKIP: {
  skip("new_with_markup and set_markup are new in 2.4", 2)
    unless Gtk2->CHECK_VERSION (2, 4, 0);

  $dialog = Gtk2::MessageDialog -> new_with_markup(undef,
                                                   "destroy-with-parent",
                                                   "warning",
                                                   "ok-cancel",
                                                   "<span>Bla, 23</span>");
  isa_ok($dialog, "Gtk2::MessageDialog");

  $dialog = Gtk2::MessageDialog -> new_with_markup(undef,
                                                   "destroy-with-parent",
                                                   "warning",
                                                   "ok-cancel",
                                                   undef);
  isa_ok($dialog, "Gtk2::MessageDialog");

  $dialog -> set_markup("<span>Bla, 23</span>");
}

SKIP: {
  skip("new 2.6 stuff", 0)
    unless Gtk2->CHECK_VERSION (2, 6, 0);

  $dialog -> format_secondary_text("%s, %d", "Bla", 23);
  $dialog -> format_secondary_text("Bla, 23");
  $dialog -> format_secondary_text(undef);

  $dialog -> format_secondary_markup("<span>Bla, 23</span>");
  $dialog -> format_secondary_markup(undef);
}

SKIP: {
  skip("new 2.10 stuff", 0)
    unless Gtk2->CHECK_VERSION (2, 10, 0);

  my $image = Gtk2::Label -> new(":-)");
  $dialog -> set_image($image);
}

__END__

Copyright (C) 2003-2006 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
