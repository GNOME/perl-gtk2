#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper tests => 14;

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

SKIP: {
  skip '2.12 stuff', 1
    unless Gtk2 -> CHECK_VERSION(2, 12, 0);

  $item -> set_submenu(undef);
  is($item -> get_submenu(), undef);
}

$item -> remove_submenu();
$item -> set_accel_path("<bla/bla/bla>");

$item -> signal_connect(toggle_size_request => sub {
  is (shift, $item);
  is (shift, "bla");
  return 23;
}, "bla");

is ($item -> toggle_size_request(), 23);

$item -> signal_connect(toggle_size_allocate => sub {
  is (shift, $item);
  is (shift, 23);
  is (shift, "bla");
}, "bla");

$item -> toggle_size_allocate(23);

SKIP: {
  skip 'new 2.14 stuff', 1
    unless Gtk2->CHECK_VERSION(2, 13, 6); # FIXME: 2.14

  my $item = Gtk2::MenuItem -> new();
  $item -> set_accel_path('<bla>/bla/bla');
  is ($item -> get_accel_path(), '<bla>/bla/bla');
}

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
