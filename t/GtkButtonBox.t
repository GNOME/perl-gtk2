#!/usr/bin/perl -w
use strict;

use Gtk2;
use Gtk2::TestHelper tests => 3, noinit => 1;

my $box = Gtk2::VButtonBox -> new();
isa_ok($box, "Gtk2::ButtonBox");

$box -> set_layout("spread"),
is($box -> get_layout(), "spread");

my $button = Gtk2::Button -> new("Bla");

$box -> pack_start_defaults($button);
$box -> set_child_secondary($button, 1);

SKIP: {
  skip("get_child_secondary is new in 2.4", 1)
    if (Gtk2 -> check_version(2, 4, 0));

  is($box -> get_child_secondary(), 1);
}

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
