#!/usr/bin/perl -w
use strict;

use Gtk2;
use Gtk2::TestHelper tests => 11;

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
