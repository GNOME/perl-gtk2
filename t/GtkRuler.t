#!/usr/bin/perl -w
use strict;

use Gtk2;
use Gtk2::TestHelper tests => 3;

my $ruler = Gtk2::VRuler -> new();
isa_ok($ruler, "Gtk2::Ruler");

$ruler -> set_metric("pixels");
is($ruler -> get_metric(), "pixels");

$ruler -> set_range(0, 100, 10, 100);
is_deeply([$ruler -> get_range], [0, 100, 10, 100]);
