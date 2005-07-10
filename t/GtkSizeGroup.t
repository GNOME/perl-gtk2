#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper tests => 3, noinit => 1;

# $Header$

my $group = Gtk2::SizeGroup -> new("vertical");
isa_ok($group, "Gtk2::SizeGroup");

$group -> set_mode("horizontal");
is($group -> get_mode(), "horizontal");

my $label = Gtk2::Label -> new("Bla");

$group -> add_widget($label);
$group -> remove_widget($label);

SKIP: {
  skip("new 2.8 stuff", 1)
    unless Gtk2->CHECK_VERSION (2, 7, 0); # FIXME: 2.8

  $group -> set_ignore_hidden(TRUE);
  ok($group -> get_ignore_hidden());
}

__END__

Copyright (C) 2003-2005 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
