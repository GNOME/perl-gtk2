#!/usr/bin/perl -w
use strict;

use Gtk2;
use Gtk2::TestHelper tests => 1;

my $container = Gtk2::Container -> new(Gtk2::Window::);
my $label = Gtk2::Label -> new("Bla");

$container -> add($label);
is($container -> get_child(), $label);
