#!/usr/bin/perl -w
use strict;

use Gtk2;
use Gtk2::TestHelper tests => 5;

my $dialog = Gtk2::ColorSelectionDialog -> new("Bla");
isa_ok($dialog, "Gtk2::ColorSelectionDialog");
isa_ok($dialog -> colorsel(), "Gtk2::ColorSelection");
isa_ok($dialog -> ok_button(), "Gtk2::Button");
isa_ok($dialog -> cancel_button(), "Gtk2::Button");
isa_ok($dialog -> help_button(), "Gtk2::Button");
