#!/usr/bin/perl -w
use strict;

use Gtk2;
use Gtk2::TestHelper tests => 2;

my $fixed = Gtk2::Fixed -> new();
isa_ok($fixed, "Gtk2::Fixed");

my $label = Gtk2::Label -> new("Bla");

$fixed -> put($label, 23, 42);
$fixed -> move($label, 5, 5);

$fixed -> set_has_window(1);
is($fixed -> get_has_window(), 1);
