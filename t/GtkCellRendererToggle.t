#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper tests => 3, noinit => 1;

# $Header$

my $toggle = Gtk2::CellRendererToggle -> new();
isa_ok($toggle, "Gtk2::CellRendererToggle");

$toggle -> set_radio(1);
is($toggle -> get_radio(), 1);

$toggle -> set_active(1);
is($toggle -> get_active(), 1);

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
