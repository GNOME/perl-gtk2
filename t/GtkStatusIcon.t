#!/usr/bin/perl
# vim: set ft=perl :

use strict;
use warnings;
use Gtk2::TestHelper
  tests => 17,
  at_least_version => [2, 9, 0, "Gtk2::StatusIcon is new in 2.10"]; # FIXME: 2.10

# $Header$

my $icon;

$icon = Gtk2::StatusIcon -> new();
isa_ok($icon, "Gtk2::StatusIcon");
is($icon -> get_storage_type(), "empty");

like($icon -> get_size(), qr/^\d+$/);
$icon -> set_tooltip("bla");

$icon -> set_visible(TRUE);
is($icon -> get_visible(), TRUE);

$icon -> set_blinking(TRUE);
is($icon -> get_blinking(), TRUE);

is($icon -> is_embedded(), FALSE);

# --------------------------------------------------------------------------- #

my $pixbuf = Gtk2::Gdk::Pixbuf -> new("rgb", FALSE, 8, 10, 10);
$icon = Gtk2::StatusIcon -> new_from_pixbuf($pixbuf);
isa_ok($icon, "Gtk2::StatusIcon");
is($icon -> get_storage_type(), "pixbuf");

$icon -> set_from_pixbuf($pixbuf);
is($icon -> get_pixbuf(), $pixbuf);

# --------------------------------------------------------------------------- #

$icon = Gtk2::StatusIcon -> new_from_stock("gtk-ok");
isa_ok($icon, "Gtk2::StatusIcon");
is($icon -> get_storage_type(), "stock");

$icon -> set_from_stock("gtk-ok");
is($icon -> get_stock(), "gtk-ok");

# --------------------------------------------------------------------------- #

$icon = Gtk2::StatusIcon -> new_from_icon_name("gtk-ok");
isa_ok($icon, "Gtk2::StatusIcon");
is($icon -> get_storage_type(), "icon-name");

$icon -> set_from_icon_name("gtk-ok");
is($icon -> get_icon_name(), "gtk-ok");

# --------------------------------------------------------------------------- #

my $icon_theme = Gtk2::IconTheme -> new();
my $icon_info = $icon_theme -> lookup_icon('stock_edit', 24, 'use-builtin');
my $icon_file = $icon_info -> get_filename();

$icon = Gtk2::StatusIcon -> new_from_file($icon_file);
isa_ok($icon, "Gtk2::StatusIcon");
is($icon -> get_storage_type(), "pixbuf");

$icon -> set_from_file($icon_file);

__END__

Copyright (C) 2006 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
