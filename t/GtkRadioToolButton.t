#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper
  at_least_version => [2, 4, 0, "Action-based menus are new in 2.4"],
  tests => 8,
  noinit => 1;

# $Header$

my $item = Gtk2::RadioToolButton -> new();
isa_ok($item, "Gtk2::RadioToolButton");

my $item_two = Gtk2::RadioToolButton -> new(undef);
isa_ok($item_two, "Gtk2::RadioToolButton");

my $item_three = Gtk2::RadioToolButton -> new([$item, $item_two]);
isa_ok($item_three, "Gtk2::RadioToolButton");

$item_two = Gtk2::RadioToolButton -> new_from_stock(undef, "gtk-quit");
isa_ok($item_two, "Gtk2::RadioToolButton");

$item_three = Gtk2::RadioToolButton -> new_from_stock([$item, $item_two], "gtk-quit");
isa_ok($item_three, "Gtk2::RadioToolButton");

$item = Gtk2::RadioToolButton -> new_from_widget($item_two);
isa_ok($item, "Gtk2::RadioToolButton");

$item = Gtk2::RadioToolButton -> new_with_stock_from_widget($item_two, "gtk-quit");
isa_ok($item, "Gtk2::RadioToolButton");

$item = Gtk2::RadioToolButton -> new();

$item -> set_group([$item_two, $item_three]);
is_deeply($item -> get_group(), [$item_two, $item_three]);

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
