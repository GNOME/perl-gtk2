#!/usr/bin/perl -w
use strict;

use Gtk2;
use Gtk2::TestHelper tests => 2;

my $adjustment = Gtk2::Adjustment -> new(0, 0, 100, 1, 5, 10);

my $bar = Gtk2::VScrollbar -> new($adjustment);
isa_ok($bar, "Gtk2::Scrollbar");
isa_ok($bar, "Gtk2::VScrollbar");
