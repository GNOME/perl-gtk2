#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper tests => 12;

my $entry = Gtk2::Entry -> new();
isa_ok($entry, "Gtk2::Entry");

$entry -> set_text("Bla");
is($entry -> get_text(), "Bla");

$entry -> set_visibility(1);
is($entry -> get_visibility(), 1);

$entry -> set_invisible_char("!");
is($entry -> get_invisible_char(), "!");

$entry -> set_max_length(8);
is($entry -> get_max_length(), 8);

$entry -> set_activates_default(1);
is($entry -> get_activates_default(), 1);

$entry -> set_has_frame(1);
is($entry -> get_has_frame(), 1);

$entry -> set_width_chars(23);
is($entry -> get_width_chars(), 23);

isa_ok($entry -> get_layout(), "Gtk2::Pango::Layout");

my ($x, $y) = $entry -> get_layout_offsets();
like($x, qr/^-?\d+$/);
like($y, qr/^-?\d+$/);

SKIP: {
  skip("[sg]et_completion are new in 2.3", 1)
    if (Gtk2 -> check_version(2, 3, 0));

  my $completion = Gtk2::EntryCompletion -> new();

  $entry -> set_completion($completion);
  is($entry -> get_completion(), $completion);
}

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
