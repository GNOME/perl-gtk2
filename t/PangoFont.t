#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper tests => 48;

# $Header$

my $description = Gtk2::Pango::FontDescription -> new();
isa_ok($description, "Gtk2::Pango::FontDescription");

is($description -> hash(), 0);
is($description -> equal($description), 1);

$description -> set_family("Sans");
$description -> set_family_static("Sans");
is($description -> get_family(), "Sans");

$description -> set_style("normal");
is($description -> get_style(), "normal");

$description -> set_variant("normal");
is($description -> get_variant(), "normal");

$description -> set_weight("bold");
is($description -> get_weight(), "bold");

$description -> set_stretch("condensed");
is($description -> get_stretch(), "condensed");

$description -> set_size(23);
is($description -> get_size(), 23);

isa_ok($description -> get_set_fields(), "Gtk2::Pango::FontMask");
$description -> unset_fields([qw(size stretch)]);

$description -> merge($description, 1);
$description -> merge_static($description, 1);

ok(!$description -> better_match($description, $description));
ok($description -> better_match(undef, $description));

$description = Gtk2::Pango::FontDescription -> from_string("Sans 12");
isa_ok($description, "Gtk2::Pango::FontDescription");

is($description -> to_string(), "Sans 12");
ok(defined($description -> to_filename()));

###############################################################################

my $label = Gtk2::Label -> new("Bla");
my $context = $label -> create_pango_context();
my $font = $context -> load_font($description);
my $language = Gtk2 -> get_default_language();

my $number = qr/^-?\d+$/;

isa_ok($font -> describe(), "Gtk2::Pango::FontDescription");

foreach my $rectangle ($font -> get_glyph_extents(23)) {
  foreach my $key (qw(x y width height)) {
    like($rectangle -> { $key }, $number);
  }
}

my $metrics = $font -> get_metrics($language);
isa_ok($metrics, "Gtk2::Pango::FontMetrics");

like($metrics -> get_ascent(), $number);
like($metrics -> get_descent(), $number);
like($metrics -> get_approximate_char_width(), $number);
like($metrics -> get_approximate_digit_width(), $number);

###############################################################################

like(int(Gtk2::Pango -> scale()), $number);
like(int(Gtk2::Pango -> scale_xx_small()), $number);
like(int(Gtk2::Pango -> scale_x_small()), $number);
like(int(Gtk2::Pango -> scale_small()), $number);
like(int(Gtk2::Pango -> scale_medium()), $number);
like(int(Gtk2::Pango -> scale_large()), $number);
like(int(Gtk2::Pango -> scale_x_large()), $number);
like(int(Gtk2::Pango -> scale_xx_large()), $number);
like(int(Gtk2::Pango -> PANGO_PIXELS(23)), $number);
like(int(Gtk2::Pango -> pixels(23)), $number);

###############################################################################

my @families = $context->list_families;
ok (@families > 0, 'got a list of families');
isa_ok ($families[0], 'Gtk2::Pango::FontFamily');
ok ($families[0]->get_name, 'get_name works');
SKIP: {
  skip "is_monospace is new in 1.4.0", 1
    unless Gtk2::Pango->CHECK_VERSION (1, 4, 0);
  # we don't really have a way of knowing if this font should actually
  # be monospaced, so just check that the function doesn't die.
  $families[0]->is_monospace;
  ok (1, 'is_monospace works');
}

my @faces = $families[0]->list_faces;
#print "faces @faces\n";
ok (@faces > 0, 'got a list of faces');
isa_ok ($faces[0], 'Gtk2::Pango::FontFace');
my $desc = $faces[0]->describe;
isa_ok ($desc, 'Gtk2::Pango::FontDescription');
ok ($faces[0]->get_face_name);
SKIP: {
  skip "list_sizes is new in 1.4.0", 1
    unless Gtk2::Pango->CHECK_VERSION (1, 4, 0);
  # again, whether we'll get sizes depends on whether this first font and
  # face is a bitmapped font.  we can't know that, so just test that the
  # call does not result in a crash.
  my @sizes = $faces[0]->list_sizes;
  #print "sizes @sizes\n";
  ok (1, 'list_sizes did not crash');
}

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
