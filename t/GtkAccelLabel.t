#!/usr/bin/perl -w
use strict;

use Gtk2;
use Gtk2::TestHelper tests => 4;

my $button = Gtk2::Button -> new("Blub");

my $label = Gtk2::AccelLabel -> new("Bla");
isa_ok($label, "Gtk2::AccelLabel");

$label -> set_accel_widget($button);
is($label -> get_accel_widget(), $button);

like($label -> get_accel_width(), qr/^\d+$/);
ok(! $label -> refetch());
