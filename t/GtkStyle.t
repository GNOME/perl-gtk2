#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper tests => 97;

# $Header$

my $window = Gtk2::Window -> new();
$window -> realize();

my $style = Gtk2::Style -> new();
isa_ok($style, "Gtk2::Style");
ok(!$style -> attached());

$style = $style -> attach($window -> window());
isa_ok($style, "Gtk2::Style");
ok($style -> attached());

foreach my $state (qw(normal active prelight selected insensitive)) {
  foreach ($style -> fg($state),
           $style -> bg($state),
           $style -> light($state),
           $style -> dark($state),
           $style -> mid($state),
           $style -> text($state),
           $style -> base($state),
           $style -> text_aa($state)) {
    isa_ok($_, "Gtk2::Gdk::Color");
  }

  foreach ($style -> fg_gc($state),
           $style -> bg_gc($state),
           $style -> light_gc($state),
           $style -> dark_gc($state),
           $style -> mid_gc($state),
           $style -> text_gc($state),
           $style -> base_gc($state),
           $style -> text_aa_gc($state)) {
    isa_ok($_, "Gtk2::Gdk::GC");
  }

  # isa_ok($style -> bg_pixmap($state), "Gtk2::Gdk::Pixmap");
}

isa_ok($style -> black(), "Gtk2::Gdk::Color");
isa_ok($style -> white(), "Gtk2::Gdk::Color");
isa_ok($style -> black_gc(), "Gtk2::Gdk::GC");
isa_ok($style -> white_gc(), "Gtk2::Gdk::GC");
isa_ok($style -> font_desc(), "Gtk2::Pango::FontDescription");

$style -> set_background($window -> window(), "normal");
$style -> apply_default_background($window -> window(), 1, "active", Gtk2::Gdk::Rectangle -> new(10, 10, 5, 5), 10, 10, 5, 5);

isa_ok($style -> lookup_icon_set("gtk-quit"), "Gtk2::IconSet");

my $source = Gtk2::IconSource -> new();
my $button = Gtk2::Button -> new("Bla");
my $check = Gtk2::CheckButton -> new("Bla");
my $view = Gtk2::TreeView -> new();

my $pixbuf = Gtk2::Gdk::Pixbuf -> new("rgb", 0, 8, 10, 10);
$source -> set_pixbuf($pixbuf);

isa_ok($style -> render_icon($source, "ltr", "normal", "button", $button, "detail"), "Gtk2::Gdk::Pixbuf");

my $rectangle = Gtk2::Gdk::Rectangle -> new(10, 10, 10, 10);

$style -> paint_arrow($window -> window(), "normal", "none", $rectangle, $button, "detail", "up", 1, 10, 10, 10, 10);
$style -> paint_box($window -> window(), "normal", "none", $rectangle, $button, "detail", 10, 10, 10, 10);
$style -> paint_box_gap($window -> window(), "normal", "none", $rectangle, $button, "detail", 10, 10, 10, 10, "right", 5, 5);
$style -> paint_check($window -> window(), "normal", "none", $rectangle, $button, "detail", 10, 10, 10, 10);
$style -> paint_diamond($window -> window(), "normal", "none", $rectangle, $button, "detail", 10, 10, 10, 10);
$style -> paint_extension($window -> window(), "normal", "none", $rectangle, $button, "detail", 10, 10, 10, 10, "left");
$style -> paint_flat_box($window -> window(), "normal", "none", $rectangle, $button, "detail", 10, 10, 10, 10);
$style -> paint_focus($window -> window(), "normal", $rectangle, $button, "detail", 10, 10, 10, 10);
$style -> paint_handle($window -> window(), "normal", "none", $rectangle, $button, "detail", 10, 10, 10, 10, "horizontal");
$style -> paint_hline($window -> window(), "normal", $rectangle, $button, "detail", 10, 10, 10);
$style -> paint_option($window -> window(), "normal", "none", $rectangle, $button, "detail", 10, 10, 10, 10);
$style -> paint_polygon($window -> window(), "normal", "none", $rectangle, $button, "detail", 1, 2, 2, 4, 4, 6, 6);
$style -> paint_shadow($window -> window(), "normal", "none", $rectangle, $button, "detail", 10, 10, 10, 10);
$style -> paint_shadow_gap($window -> window(), "normal", "none", $rectangle, $button, "detail", 10, 10, 10, 10, "right", 5, 5);
$style -> paint_slider($window -> window(), "normal", "none", $rectangle, $button, "detail", 10, 10, 10, 10, "horizontal");
# $style -> paint_tab($window -> window(), "normal", "none", $rectangle, $check, "detail", 10, 10, 10, 10);
$style -> paint_vline($window -> window(), "normal", $rectangle, $button, "detail", 10, 10, 10);
$style -> paint_expander($window -> window(), "normal", $rectangle, $view, "detail", 10, 10, "collapsed");
# $style -> paint_layout($window -> window(), "normal", "none", $rectangle, $button, "detail", 10, 10, Gtk2::Pango::Layout -> new(Gtk2::Pango::Context -> new()));

# versions of gtk+ prior to 2.2.0 handled only 'south-east', which isn't so
# bad, except that they actually called g_assert_not_reached() in the branch
# of code that you reach by passing other values.  so, eh, never pass anything
# but south-east to old gtk+.
$style -> paint_resize_grip($window -> window(), "normal", $rectangle, $button, "detail", "north-west", 10, 10, 10, 10)
	if Gtk2->CHECK_VERSION (2, 2, 0);
$style -> paint_resize_grip($window -> window(), "normal", $rectangle, $button, "detail", "south-east", 10, 10, 10, 10);

$style -> detach();
isa_ok($style, "Gtk2::Style");
ok(!$style -> attached());

$style = Gtk2::Style -> new() -> attach($window -> window());
isa_ok($style, "Gtk2::Style");
ok($style -> attached());

$style -> detach();
isa_ok($style, "Gtk2::Style");
ok(!$style -> attached());

$style = Gtk2::Style -> new();
$style -> attach($window -> window());
$style -> attach($window -> window());

SKIP: {
  skip("draw_insertion_cursor is new in 2.4", 0)
    unless (Gtk2 -> CHECK_VERSION(2, 3, 5)); # FIXME 2.4

  $window -> add($button);
  Gtk2 -> draw_insertion_cursor($button, $window -> window(), $rectangle, $rectangle, 1, "ltr", 1);
}

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
