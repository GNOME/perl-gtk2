#!/usr/bin/perl -w
use strict;

use Gtk2;
use Gtk2::TestHelper tests => 2;

my $separator = Gtk2::VSeparator -> new();
isa_ok($separator, "Gtk2::Separator");
isa_ok($separator, "Gtk2::VSeparator");
