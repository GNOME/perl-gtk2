#!/usr/bin/perl -w
use strict;

use Gtk2;
use Gtk2::TestHelper tests => 1;

my $area = Gtk2::DrawingArea -> new();
isa_ok($area, "Gtk2::DrawingArea");
