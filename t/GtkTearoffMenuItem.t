#!/usr/bin/perl -w
use strict;

use Gtk2;
use Gtk2::TestHelper tests => 1;

my $item = Gtk2::TearoffMenuItem -> new();
isa_ok($item, "Gtk2::TearoffMenuItem");
