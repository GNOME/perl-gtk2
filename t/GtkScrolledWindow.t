#!/usr/bin/perl -w
use strict;

use Gtk2;
use Gtk2::TestHelper tests => 8;

my $window = Gtk2::ScrolledWindow -> new();
isa_ok($window, "Gtk2::ScrolledWindow");

my $adjustment = Gtk2::Adjustment -> new(0, 0, 100, 1, 5, 10);

$window -> set_hadjustment($adjustment);
is($window -> get_hadjustment(), $adjustment);

$window -> set_vadjustment($adjustment);
is($window -> get_vadjustment(), $adjustment);

$window = Gtk2::ScrolledWindow -> new(undef, undef);
isa_ok($window, "Gtk2::ScrolledWindow");

$window = Gtk2::ScrolledWindow -> new($adjustment, $adjustment);
isa_ok($window, "Gtk2::ScrolledWindow");

$window -> set_policy("always", "automatic");
is_deeply([$window -> get_policy()], ["always", "automatic"]);

my $label = Gtk2::Label -> new("Bla");

$window -> add_with_viewport($label);

$window -> set_placement("bottom-right");
is($window -> get_placement(), "bottom-right");

$window -> set_shadow_type("etched-in");
is($window -> get_shadow_type(), "etched-in");
