#!/usr/bin/perl -w
use strict;
use Test::More;
use Gtk2;

# $Header$

Gtk2::Gdk::Threads -> init();

if (Gtk2->init_check )
{
	plan tests => 13;
}
else
{
	plan skip_all => 'Gtk2->init_check failed, probably unable to '
		. 'open DISPLAY';
}

Gtk2::Gdk::Threads -> enter();
Gtk2::Gdk::Threads -> leave();

SKIP: {
  skip("get_display_arg_name and notify_startup_complete are new in 2.2", 0)
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
$window -> show_now();

is(Gtk2::Gdk -> pointer_grab($window -> window(), 1, qw(button-press-mask), undef, Gtk2::Gdk::Cursor -> new("arrow"), 0), "success");
is(Gtk2::Gdk -> pointer_is_grabbed(), 1);
Gtk2::Gdk -> pointer_ungrab(0);

# Gtk2::Gdk -> set_double_click_time(20);

is(Gtk2::Gdk -> keyboard_grab($window -> window(), 1, 0), "success");
Gtk2::Gdk -> keyboard_ungrab(0);

Gtk2::Gdk -> error_trap_push();
is(Gtk2::Gdk -> error_trap_pop(), 0);

my $event = Gtk2::Gdk::Event -> new("client-event");

$event -> window($window -> window());
$event -> message_type(Gtk2::Gdk::Atom -> new("string"));
$event -> data_format(Gtk2::Gdk::CHARS);
$event -> data("01234567890123456789");

is(Gtk2::Gdk::Event -> send_client_message($event, $window -> window() -> get_xid()), 1);
Gtk2::Gdk::Event -> send_clientmessage_toall($event);

SKIP: {
  skip("GdkDisplay is new in 2.2", 1)
    if (Gtk2 -> check_version(2, 2, 0));

  is(Gtk2::Gdk::Event -> send_client_message_for_display(Gtk2::Gdk::Display -> get_default(), $event, $window -> window() -> get_xid()), 1);
}

Gtk2::Gdk -> beep();

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
