#!/usr/bin/perl -w
use strict;

use Gtk2;
use Gtk2::TestHelper tests => 1;

my $ruler = Gtk2::HRuler -> new();
isa_ok($ruler, "Gtk2::HRuler");
