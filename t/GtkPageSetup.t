#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper
  tests => 11,
  at_least_version => [2, 9, 0, "GtkPageSetup is new in 2.10"]; # FIXME 2.10

# $Header$

my $setup = Gtk2::PageSetup -> new();
isa_ok($setup, "Gtk2::PageSetup");

$setup -> set_orientation("landscape");
is($setup -> get_orientation(), "landscape");

my $size = Gtk2::PaperSize -> new("iso_a4");

$setup -> set_paper_size($size);
isa_ok($setup -> get_paper_size(), "Gtk2::PaperSize");

$setup -> set_top_margin(23, "mm");
is($setup -> get_top_margin("mm"), 23);

$setup -> set_bottom_margin(23, "mm");
is($setup -> get_bottom_margin("mm"), 23);

$setup -> set_left_margin(23, "mm");
is($setup -> get_left_margin("mm"), 23);

$setup -> set_right_margin(23, "mm");
is($setup -> get_right_margin("mm"), 23);

$setup -> set_paper_size_and_default_margins($size);

ok(defined $setup -> get_paper_width("mm"));
ok(defined $setup -> get_paper_height("mm"));
ok(defined $setup -> get_page_width("mm"));
ok(defined $setup -> get_page_height("mm"));

__END__

Copyright (C) 2006 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
