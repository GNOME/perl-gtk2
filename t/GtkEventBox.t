#!/usr/bin/perl -w
use strict;

use Gtk2;
use Gtk2::TestHelper tests => 1;

my $box = Gtk2::EventBox -> new();
isa_ok($box, "Gtk2::EventBox");
