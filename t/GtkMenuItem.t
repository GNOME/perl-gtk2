#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper tests => 6, noinit => 1;

# $Header$

my $item = Gtk2::MenuItem -> new();
isa_ok($item, "Gtk2::MenuItem");

$item = Gtk2::MenuItem -> new("_Bla");
isa_ok($item, "Gtk2::MenuItem");

$item = Gtk2::MenuItem -> new_with_label("Bla");
isa_ok($item, "Gtk2::MenuItem");

$item = Gtk2::MenuItem -> new_with_mnemonic("Bla");
isa_ok($item, "Gtk2::MenuItem");

$item -> select();
$item -> deselect();
$item -> toggle();

$item -> activate();

$item -> set_right_justified(1);
is($item -> get_right_justified(), 1);

my $menu = Gtk2::Menu -> new();

$item -> set_submenu($menu);
is($item -> get_submenu(), $menu);

$item -> remove_submenu();
$item -> set_accel_path("<bla/bla/bla>");

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
