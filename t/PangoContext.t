#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper tests => 9;

# $Header$

my $label = Gtk2::Label -> new("Bla");

my $context = $label -> create_pango_context();
isa_ok($context, "Gtk2::Pango::Context");

my @families = $context->list_families;
ok (@families > 0, 'got a list of somethings');
isa_ok ($families[0], 'Gtk2::Pango::FontFamily');

my $font = Gtk2::Pango::FontDescription -> from_string("Sans 12");
my $language = Gtk2 -> get_default_language();

$context -> set_font_description($font);
isa_ok($context -> get_font_description(), "Gtk2::Pango::FontDescription");

$context -> set_language($language);
isa_ok($context -> get_language(), "Gtk2::Pango::Language");

$context -> set_base_dir("ltr");
is($context -> get_base_dir(), "ltr");

isa_ok($context -> load_font($font), "Gtk2::Pango::Font");
isa_ok($context -> load_fontset($font, $language), "Gtk2::Pango::Fontset");
isa_ok($context -> get_metrics($font, $language), "Gtk2::Pango::FontMetrics");

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
