#!/usr/bin/perl -w
use strict;

use Gtk2;
use Gtk2::TestHelper tests => 6, noinit => 1;

my $viewport = Gtk2::Viewport -> new();
isa_ok($viewport, "Gtk2::Viewport");

my $adjustment = Gtk2::Adjustment -> new(0, 0, 100, 1, 5, 10);

$viewport -> set_hadjustment($adjustment);
is($viewport -> get_hadjustment(), $adjustment);

$viewport -> set_vadjustment($adjustment);
is($viewport -> get_vadjustment(), $adjustment);

$viewport = Gtk2::Viewport -> new(undef, undef);
isa_ok($viewport, "Gtk2::Viewport");

$viewport = Gtk2::Viewport -> new($adjustment, $adjustment);
isa_ok($viewport, "Gtk2::Viewport");

$viewport -> set_shadow_type("etched-in");
is($viewport -> get_shadow_type(), "etched-in");

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
