#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper tests => 9;

# $Header$

my $fs = Gtk2::FontSelection -> new();
isa_ok($fs, "Gtk2::FontSelection");

# FIXME: why doesn't that work just like with the dialog?
# ok($fs -> set_font_name("Sans 12"));
# is($fs -> get_font_name(), "Sans 12");

$fs -> set_preview_text("Quick brown gtk2-perl.");
is($fs -> get_preview_text(), "Quick brown gtk2-perl.");

my $dialog = Gtk2::FontSelectionDialog -> new("Bla");
isa_ok($dialog, "Gtk2::FontSelectionDialog");

isa_ok($dialog -> ok_button, "Gtk2::Button");
isa_ok($dialog -> apply_button, "Gtk2::Button");
isa_ok($dialog -> cancel_button, "Gtk2::Button");

ok($dialog -> set_font_name("Sans 12"));
is(lc($dialog -> get_font_name()), "sans 12");

$dialog -> set_preview_text("Quick brown gtk2-perl.");
is($dialog -> get_preview_text(), "Quick brown gtk2-perl.");

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
