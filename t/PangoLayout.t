#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper tests => 22;

# $Header$

my $label = Gtk2::Label -> new("Bla");
my $context = $label -> create_pango_context();

my $layout = Gtk2::Pango::Layout -> new($context);
isa_ok($layout, "Gtk2::Pango::Layout");
is($layout -> get_context(), $context);

$layout -> context_changed();

$layout -> set_text("Bla bla.");
is($layout -> get_text(), "Bla bla.");

$layout -> set_markup("Bla bla.");
is($layout -> set_markup_with_accel("Bla _bla.", "_"), "b");

SKIP: {
  skip("set_font_description is slightly borken currently", 0)
    unless (0); # FIXME: change that once it's been fixed.

  $layout -> set_font_description(undef);
}

$layout -> set_font_description(Gtk2::Pango::FontDescription -> new());

$layout -> set_width(23);
is($layout -> get_width(), 23);

$layout -> set_wrap("word");
is($layout -> get_wrap(), "word");

$layout -> set_indent(5);
is($layout -> get_indent(), 5);

$layout -> set_spacing(5);
is($layout -> get_spacing(), 5);

$layout -> set_justify(1);
is($layout -> get_justify(), 1);

$layout -> set_alignment("left");
is($layout -> get_alignment(), "left");

$layout -> set_tabs(Gtk2::Pango::TabArray -> new(8, 0));
isa_ok($layout -> get_tabs(), "Gtk2::Pango::TabArray");

$layout -> set_single_paragraph_mode(1);
is($layout -> get_single_paragraph_mode(), 1);

my $attribute = ($layout -> get_log_attrs())[0];
isa_ok($attribute, "HASH");

is_deeply($attribute, {
  is_line_break => 0,
  is_mandatory_break => 0,
  is_char_break => 1,
  is_white => 0,
  is_cursor_position => 1,
  is_word_start => 1,
  is_word_end => 0,
  is_sentence_boundary => 0,
  is_sentence_start => 1,
  is_sentence_end => 0,
  Gtk2::Pango -> check_version(1, 3, 0) ?
    (backspace_deletes_character => 1) :
    ()
});

my ($index, $trailing) = $layout -> xy_to_index(5, 5);
like($index, qr/^\d+$/);
like($trailing, qr/^\d+$/);

is_deeply([$layout -> move_cursor_visually(1, 0, 0, 1)], [1, 0]);

my ($width, $height) = $layout -> get_size();
like($width, qr/^\d+$/);
like($height, qr/^\d+$/);

($width, $height) = $layout -> get_pixel_size();
like($width, qr/^\d+$/);
like($height, qr/^\d+$/);

like($layout -> get_line_count(), qr/^\d+$/);

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
