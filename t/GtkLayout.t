#!/usr/bin/perl -w
use strict;

use Gtk2;
use Gtk2::TestHelper tests => 6;

my $layout = Gtk2::Layout -> new();
isa_ok($layout, "Gtk2::Layout");

$layout = Gtk2::Layout -> new(undef, undef);
isa_ok($layout, "Gtk2::Layout");

my $adjustment = Gtk2::Adjustment -> new(0, 0, 100, 1, 5, 10);

$layout -> set_hadjustment($adjustment);
is($layout -> get_hadjustment(), $adjustment);

$layout -> set_vadjustment($adjustment);
is($layout -> get_vadjustment(), $adjustment);

$layout = Gtk2::Layout -> new($adjustment, $adjustment);
isa_ok($layout, "Gtk2::Layout");

my $label = Gtk2::Label -> new("Bla");

$layout -> put($label, 23, 42);
$layout -> move($label, 5, 5);

$layout -> set_size(10, 10);
is_deeply([$layout -> get_size()], [10, 10]);
