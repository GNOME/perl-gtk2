#!/usr/bin/perl -w
use strict;

use Gtk2;
use Gtk2::TestHelper tests => 1;

my $dialog = Gtk2::InputDialog -> new();
isa_ok($dialog, "Gtk2::InputDialog");
