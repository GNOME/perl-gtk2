#!/usr/bin/perl -w
use strict;

use Gtk2;
use Gtk2::TestHelper tests => 8;

my $button = Gtk2::CheckButton -> new();
isa_ok($button, "Gtk2::CheckButton");
is($button -> get("label"), undef);

$button = Gtk2::CheckButton -> new("_Bla");
isa_ok($button, "Gtk2::CheckButton");
is($button -> get("label"), "_Bla");

$button = Gtk2::CheckButton -> new_with_mnemonic("_Bla");
isa_ok($button, "Gtk2::CheckButton");
is($button -> get("label"), "_Bla");

$button = Gtk2::CheckButton -> new_with_label("Bla");
isa_ok($button, "Gtk2::CheckButton");
is($button -> get("label"), "Bla");
