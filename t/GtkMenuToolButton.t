#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper
  tests => 5, noinit => 1,
  at_least_version => [2, 6, 0, "GtkMenuToolButton is new in 2.6"];

# $Header$

my $label = Gtk2::Label -> new("Urgs");

my $button = Gtk2::MenuToolButton -> new($label, "Urgs");
isa_ok($button, "Gtk2::MenuToolButton");

$button = Gtk2::MenuToolButton -> new(undef, undef);
isa_ok($button, "Gtk2::MenuToolButton");

$button = Gtk2::MenuToolButton -> new_from_stock("gtk-ok");
isa_ok($button, "Gtk2::MenuToolButton");

my $menu = Gtk2::Menu -> new();

$button -> set_menu($menu);
is($button -> get_menu(), $menu);

$button -> set_menu(undef);
is($button -> get_menu(), undef);

my $tooltips = Gtk2::Tooltips -> new();

$button -> set_arrow_tooltip($tooltips, "Urgs", "Urgs");

__END__

Copyright (C) 2004 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
