#!/usr/bin/perl -w
use strict;

use Gtk2;
use Gtk2::TestHelper tests => 31;

my $attributes = {
  title => "Bla",
  event_mask => "button-press-mask",
  x => 10,
  "y" => 10,
  width => 20,
  height => 20,
  wclass => "output",
  visual => Gtk2::Gdk::Screen -> get_default() -> get_system_visual(),
  colormap => Gtk2::Gdk::Colormap -> get_system(),
  window_type => "toplevel",
  cursor => Gtk2::Gdk::Cursor -> new("arrow"),
  override_redirect => 0
};

my $attributes_small = {
  title => "Bla",
  x => 23,
  "y" => 42,
  window_type => "toplevel"
};

my $window = Gtk2::Gdk::Window -> new(undef, $attributes);
my $window_two = Gtk2::Gdk::Window -> new(undef, $attributes_small);
my $window_three = Gtk2::Gdk::Window -> new(Gtk2::Gdk -> get_default_root_window(), $attributes);

isa_ok($window, "Gtk2::Gdk::Window");
isa_ok($window_two, "Gtk2::Gdk::Window");
isa_ok($window_three, "Gtk2::Gdk::Window");

is($window -> get_window_type(), "toplevel");

$window -> show_unraised();
$window -> show();

ok($window -> is_visible());
ok($window -> is_viewable());

$window -> withdraw();
$window -> iconify();
$window -> deiconify();
$window -> stick();
$window -> unstick();
$window -> maximize();
$window -> unmaximize();

SKIP: {
  skip("(un)fullscreen are new in 2.2.0", 0)
    if (Gtk2 -> check_version(2, 2, 0));

  $window -> fullscreen();
  $window -> unfullscreen();
}

is($window -> get_state(), "withdrawn");

$window -> move(20, 20);
$window -> resize(40, 40);
$window -> move_resize(20, 20, 40, 40);
$window -> scroll(5, 5);

$window -> reparent($window_three, 0, 0);

$window -> clear();
$window -> clear_area(0, 0, 5, 5);
$window -> clear_area_e(0, 0, 5, 5);

$window -> raise();
$window -> lower();
$window -> focus(time());
$window -> register_dnd();

# See t/GtkWindow.t for why these are disabled.
# $window -> begin_resize_drag("south-east", 1, 20, 20, 0);
# $window -> begin_move_drag(1, 20, 20, 0);

# FIXME: separate .t?
my $geometry = Gtk2::Gdk::Geometry -> new();
isa_ok($geometry, "Gtk2::Gdk::Geometry");

$geometry -> min_width(10);
$geometry -> max_width(100);
$geometry -> min_height(10);
$geometry -> max_height(100);
$geometry -> base_width(5);
$geometry -> base_height(5);
$geometry -> width_inc(5);
$geometry -> height_inc(5);
$geometry -> min_aspect(0.5);
$geometry -> max_aspect(0.5);
$geometry -> gravity("south-west");
$geometry -> win_gravity("north-east");

is_deeply([$geometry -> min_width(),
           $geometry -> max_width(),
           $geometry -> min_height(),
           $geometry -> max_height(),
           $geometry -> base_width(),
           $geometry -> base_height(),
           $geometry -> width_inc(),
           $geometry -> height_inc(),
           $geometry -> min_aspect(),
           $geometry -> max_aspect(),
           $geometry -> gravity(),
           $geometry -> win_gravity()], [10, 100, 10, 100, 5, 5, 5, 5, 0.5, 0.5, "north-east", "north-east"]);

my $geometry_two = {
  min_width => 10,
  max_width => 100,
  min_height => 10,
  max_height => 100,
  base_width => 5,
  base_height => 5,
  width_inc => 5,
  height_inc => 5,
  min_aspect => 0.5,
  max_aspect => 0.5,
  win_gravity => "north-west"
};

my $mask = [qw(min-size
               max-size
               base-size
               aspect
               resize-inc
               win-gravity)];

is_deeply([$geometry -> constrain_size($mask, 22, 23)], [10, 20]);
is_deeply([$geometry -> constrain_size(22, 23)], [10, 20]);

my $rectangle = Gtk2::Gdk::Rectangle -> new(10, 10, 20, 20);
my $region = Gtk2::Gdk::Region -> rectangle($rectangle);

$window_two -> begin_paint_rect($rectangle);
$window_two -> begin_paint_region($region);
$window_two -> end_paint();

$window_two -> invalidate_rect($rectangle, 1);
$window_two -> invalidate_region($region, 1);

# FIXME: never called?
$window_three -> invalidate_maybe_recurse($region, sub { warn @_; return 0; }, "bla");

$window -> freeze_updates();
$window -> thaw_updates();

# FIXME: when does it return something defined?
is($window_two -> get_update_area(), undef);

$window -> process_all_updates();
$window -> process_updates(0);
$window -> set_debug_updates(0);

my ($drawable, $x_offset, $y_offset) = $window -> get_internal_paint_info();
isa_ok($drawable, "Gtk2::Gdk::Drawable");
is($x_offset, 0);
is($y_offset, 0);

$window -> set_override_redirect(0);

# FIXME
# $window -> add_filter(...);
# $window -> remove_filter(...);

# FIXME
# $window -> shape_combine_mask(...);
$window -> shape_combine_region($region, 1, 1);

$window -> set_child_shapes();
$window -> merge_child_shapes();
$window -> set_static_gravities(0); # FIXME: check retval?
$window -> set_title("Blub");
$window -> set_background(Gtk2::Gdk::Color -> new(255, 255, 255));

# FIXME
# $window -> set_back_pixmap(...);

$window -> set_cursor(Gtk2::Gdk::Cursor -> new("arrow"));

Gtk2 -> main_iteration() while (Gtk2 -> events_pending());
is_deeply([($window -> get_geometry())[0..3]], [20, 20, 40, 40]);

$window -> set_geometry_hints($geometry, $mask);
$window -> set_geometry_hints($geometry_two);

$window -> set_icon_list();
$window -> set_icon_list(Gtk2::Gdk::Pixbuf -> new("rgb", 0, 8, 10, 10),
                         Gtk2::Gdk::Pixbuf -> new("rgb", 0, 8, 10, 10));

$window -> set_modal_hint(0);
$window -> set_type_hint("normal");

SKIP: {
  skip("set_skip_taskbar_hint and set_skip_pager_hint are new in 2.2.0", 0)
    if (Gtk2 -> check_version(2, 2, 0));

  $window -> set_skip_taskbar_hint(0);
  $window -> set_skip_pager_hint(0);
}

is_deeply([$window -> get_position()], [0, 0]);
is_deeply([$window -> get_root_origin()], [20, 20]);
isa_ok($window -> get_frame_extents(), "Gtk2::Gdk::Rectangle");
is_deeply([$window -> get_origin()], [20, 20]);

my ($pointer_window, $relative_x, $relative_y, $pointer_mask) = $window -> get_pointer();
# $pointer_window
like($relative_x, qr/^-?\d+$/);
like($relative_y, qr/^-?\d+$/);
isa_ok($pointer_mask, "Gtk2::Gdk::ModifierType");

is($window -> get_parent(), $window_three);
is($window -> get_toplevel(), $window_three);

is($window_three -> get_children(), $window);
is($window_three -> peek_children(), $window);

$window -> set_events("button-press-mask");
isa_ok($window -> get_events(), "Gtk2::Gdk::EventMask");

$window -> set_icon(undef, undef, undef);
$window -> set_icon_name("Wheeee");
$window -> set_transient_for($window_three);
$window -> set_role("Playa");
$window -> set_group($window_three);

$window -> set_decorations("all");

# We can't do that because not all WM's honor the decorations request.
# is_deeply([$window -> get_decorations()], [1, "all"]);

$window -> set_functions("all");

isa_ok((Gtk2::Gdk::Window -> get_toplevels())[0], "Gtk2::Gdk::Window");

isa_ok(Gtk2::Gdk -> get_default_root_window(), "Gtk2::Gdk::Window");

# FIXME
$window -> set_user_data(123);
is($window -> get_user_data(), 123);

$window -> hide();
