#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper tests => 15;

# $Header$

my $map = Gtk2::Gdk::Keymap -> get_default();
isa_ok($map, "Gtk2::Gdk::Keymap");

SKIP: {
  skip("GdkDisplay is new in 2.2", 1)
    if (Gtk2 -> check_version(2, 2, 0));

  $map = Gtk2::Gdk::Keymap -> get_for_display (Gtk2::Gdk::Display -> get_default());
  isa_ok($map, "Gtk2::Gdk::Keymap");
}

my ($keyval, $group, $level, $mods) = $map -> translate_keyboard_state(10, [qw(shift-mask lock-mask)], 0);
like($keyval, qr/^\d+$/);
like($keyval, qr/^\d+$/);
like($keyval, qr/^\d+$/);
isa_ok($mods, "Gtk2::Gdk::ModifierType");

ok(defined($map -> get_direction()));

use Gtk2::Gdk::Keysyms;

my $a = $Gtk2::Gdk::Keysyms{ a };
my $A = $Gtk2::Gdk::Keysyms{ A };

is(Gtk2::Gdk -> keyval_name($a), "a");
is(Gtk2::Gdk -> keyval_from_name("a"), $a);

is_deeply([Gtk2::Gdk -> keyval_convert_case($a)],
          [$a, $A]);

is(Gtk2::Gdk -> keyval_to_upper($a), $A);
is(Gtk2::Gdk -> keyval_to_lower($A), $a);
is(Gtk2::Gdk -> keyval_is_upper($A), 1);
is(Gtk2::Gdk -> keyval_is_lower($a), 1);

my $unicode = Gtk2::Gdk -> keyval_to_unicode($a);
is(Gtk2::Gdk -> unicode_to_keyval($unicode), $a);

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
