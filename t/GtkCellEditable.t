#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper tests => 1;

# $Header$

my $entry = Gtk2::Entry -> new();
isa_ok($entry, "Gtk2::CellEditable");

$entry -> start_editing();
$entry -> start_editing(undef);
$entry -> start_editing(Gtk2::Gdk::Event -> new("button-press"));
$entry -> editing_done();
$entry -> remove_widget();

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
