#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper tests => 11;

SKIP: {
  skip("get_display_arg_name and notify_startup_complete are new in 2.2")
    if (Gtk2 -> check_version(2, 2, 0));

  Gtk2::Gdk -> get_display_arg_name(); # FIXME: check retval?
  Gtk2::Gdk -> notify_startup_complete();
}

ok(Gtk2::Gdk -> set_locale());
Gtk2::Gdk -> set_sm_client_id();

Gtk2::Gdk -> set_program_class("gtk2perl");
is(Gtk2::Gdk -> get_program_class(), "gtk2perl");

ok(Gtk2::Gdk -> get_display());
Gtk2::Gdk -> flush();

my $number = qr/^\d+$/;
like(Gtk2::Gdk -> screen_width(), $number);
like(Gtk2::Gdk -> screen_height(), $number);
like(Gtk2::Gdk -> screen_width_mm(), $number);
like(Gtk2::Gdk -> screen_height_mm(), $number);

my $window = Gtk2::Window -> new();
$window -> show();

is(Gtk2::Gdk -> pointer_grab($window -> window(), 1, qw(button-press-mask), undef, Gtk2::Gdk::Cursor -> new("arrow"), 0), "success");
is(Gtk2::Gdk -> pointer_is_grabbed(), 1);
Gtk2::Gdk -> pointer_ungrab(0);

# Gtk2::Gdk -> set_double_click_time(20);

is(Gtk2::Gdk -> keyboard_grab($window -> window(), 1, 0), "success");
Gtk2::Gdk -> keyboard_ungrab(0);

Gtk2::Gdk -> beep();

Gtk2::Gdk -> error_trap_push();
is(Gtk2::Gdk -> error_trap_pop(), 0);

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
