#!/usr/bin/perl -w
use strict;

use Gtk2;
use Gtk2::TestHelper tests => 1;

my $bar = Gtk2::MenuBar -> new();
isa_ok($bar, "Gtk2::MenuBar");
