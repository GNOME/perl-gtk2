#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper tests => 1, noinit => 1;

# $Header$

my $container = Gtk2::Container -> new(Gtk2::Window::);
my $label = Gtk2::Label -> new("Bla");

$container -> add($label);
is($container -> get_child(), $label);

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
