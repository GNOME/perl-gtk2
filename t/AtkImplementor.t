#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper tests => 2, noinit => 1;

# $Header$

my $label = Gtk2::Label -> new("Bla");
isa_ok($label, "Gtk2::Atk::Implementor");

isa_ok($label -> ref_accessible(), "Gtk2::Atk::Object");

__END__

Copyright (C) 2005 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
