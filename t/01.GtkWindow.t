#
# $Header$
#

use strict;
use warnings;

#########################
# GtkWindow Tests
# 	- rm
#########################

#########################

use Gtk2;
use Test::More;

if( Gtk2->init_check )
{
	plan tests => 102;
}
else
{
	plan skip_all =>
		'Gtk2->init_check failed, probably unable to open DISPLAY';
}

#########################

require './t/ignore_keyboard.pl';

use constant TRUE => 1;
use constant FALSE => 0;

ok( my $win = Gtk2::Window->new );
ok( $win = Gtk2::Window->new('popup') );
ok( $win = Gtk2::Window->new('toplevel') );

$win->set_title;
ok(1);
$win->set_title(undef);
ok(1);
$win->set_title('');
ok(1);
$win->set_title('Test Window');
ok(1);

is( $win->get_title, 'Test Window' );

$win->set_resizable(TRUE);
ok(1);

ok( $win->get_resizable );

$win->set_modal(TRUE);
ok(1);

ok( $win->get_modal );

$win->set_default_size(640, 480);
ok(1);

# the window manager needn't honor our request, but the
# widget should be holding the values and the bindings
# should return them correctly.
my @s = $win->get_default_size;
ok( $s[0] == 640 && $s[1] == 480 );

my $geometry = {
	min_width => 10,
	min_height => 10
};

my $label = Gtk2::Label->new("Bla");

$win->set_geometry_hints($label, $geometry);
ok(1);
$win->set_geometry_hints($label, $geometry, undef);
ok(1);
$win->set_geometry_hints($label, $geometry, qw(min-size));
ok(1);

foreach (qw/north-west north north-east west center east
	    south-west south south-east static/)
{
	$win->set_gravity($_);
	ok(1);

	is( $win->get_gravity , $_, "gravity $_" );
}

foreach (qw/none center mouse center-always center-on-parent/)
{
	$win->set_position($_);
	ok(1, "set_position $_");
}

$win->set_position('center');
ok(1);

my @position = $win->get_position;
is(scalar(@position), 2);

ok( my $win2 = Gtk2::Window->new );

$win2->set_transient_for($win);
ok(1);

is( $win2->get_transient_for, $win );

$win2->set_destroy_with_parent(TRUE);
ok(1);

ok( $win2->get_destroy_with_parent );

my @toplvls = Gtk2::Window->list_toplevels;
is(scalar(@toplvls), 4);

use Gtk2::Gdk::Keysyms;
my $mnemonic = $Gtk2::Gdk::Keysyms{ KP_Enter };

$win2->add_mnemonic($mnemonic, $label);
ok(1);

# FIXME: is it correct to assume that it always returns false?
ok( ! $win2->mnemonic_activate($mnemonic, "shift-mask") );

$win2->remove_mnemonic($mnemonic, $label);
ok(1);

$win2->set_mnemonic_modifier("control-mask");
ok(1);

is( $win2->get_mnemonic_modifier, "control-mask");

$win2->set_focus;
ok(1);

$win2->set_focus(Gtk2::Entry->new());
ok(1);

# FIXME: what could be used here?
# $win2->set_default(...);

$win2->set_decorated(TRUE);
ok(1);
ok( $win2->get_decorated );

$win2->set_has_frame(FALSE);
ok(1);

ok( !$win2->get_has_frame );

$win2->set_role('tool');
ok(1);

is( $win2->get_role, 'tool' );

foreach (qw/normal dialog menu toolbar/)
{
	$win2->set_type_hint($_);
	ok(1);

	is( $win2->get_type_hint, $_ );
}

SKIP: {
	skip 'stuff missing in 2.0.x', 6
		unless (Gtk2->get_version_info)[1] >= 2;

	foreach (qw/splashscreen utility dock desktop/)
	{
		$win2->set_type_hint($_);

		is( $win2->get_type_hint, $_ );
	}

	SKIP: {
		skip 'taskbar stuff missing on windows', 1
			if $^O eq 'MSWin32';

		$win2->set_skip_taskbar_hint('true');

		ok( $win2->get_skip_taskbar_hint );
	}

	$win2->set_skip_pager_hint('true');

	ok( $win2->get_skip_pager_hint );
}

ok( ! $win->get_default_icon_list );

# need pixbufs
#$win->set_default_icon_list(...)

# need file
#$win->set_default_icon_from_file(...)

# need a pixbuf
#$win->set_icon($pixbuf);

# doesn't have an icon ^
ok( ! $win->get_icon );

# doesn't have an icon ^
ok( ! $win->get_icon_list );

Glib::Idle->add(sub {
		$win2->show;

		# there are no widgets, so this should fail
		ok( ! $win->activate_focus );

		# there are no widgets, so this should fail
		ok( ! $win->activate_default );

		# there are no widgets, so this should fail
		ok( ! $win->get_focus );

		$win->present;
		ok(1);

		$win->iconify;
		ok(1);

		# doesnt work no error message
		$win->deiconify;
		ok(1);

		$win->stick;
		ok(1);

		$win->unstick;
		ok(1);

		# doesnt work no error message
		$win->maximize;
		ok(1);

		# doesnt work no error message
		$win->unmaximize;
		ok(1);

		# gtk2.2 req
		SKIP: {
			my $reason;
			if ($^O eq 'MSWin32') {
				$reason = 'GdkScreen not available on win32';
			} elsif ((Gtk2->get_version_info)[1] < 2) {
				$reason = 'stuff not available before 2.2.x';
			} else {
				$reason = undef;
			}

			skip $reason, 1 if defined $reason;

			$win->set_screen(Gtk2::Gdk::Screen->get_default());
			is($win->get_screen, Gtk2::Gdk::Screen->get_default());

			$win->fullscreen;
			$win->unfullscreen;
		}

		$win->begin_resize_drag("south-east", 1, 23, 42, 0);
		ok(1);

		$win->begin_move_drag(1, 23, 42, 0);
		ok(1);

		$win->move(100, 100);

		# these are widget methods and not window, but they need 
		# testing and this seemed like a good place to do it
		my $tmp = $win->intersect(Gtk2::Gdk::Rectangle->new(0, 0, 10, 10));
		isa_ok( $tmp, 'Gtk2::Gdk::Rectangle' );
		$tmp = $win->intersect(Gtk2::Gdk::Rectangle->new(-10, -10, 1, 1));
		ok( !$tmp );

		$win->resize(480,600);

		# window managers don't honor our size request exactly,
		# or at least we aren't guaranteed they will
		ok( $win->get_size );
		ok( $win->get_frame_dimensions );

		$win2->reshow_with_initial_size;
		ok(1);

		Gtk2->main_quit;
		ok(1);
		0;
	});


$win->set_frame_dimensions(0, 0, 300, 500);

ok( $win2->parse_geometry("100x100+10+10") );

SKIP: {
	skip 'set_auto_startup_notification is new in 2.2', 1
		if Gtk2->check_version(2, 2, 0);

	$win2->set_auto_startup_notification(FALSE);
}

$win->show;
ok(1);

Gtk2->main;
ok(1);

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list)

This library is free software; you can redistribute it and/or modify it under
the terms of the GNU Library General Public License as published by the Free
Software Foundation; either version 2.1 of the License, or (at your option) any
later version.

This library is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU Library General Public License for more
details.

You should have received a copy of the GNU Library General Public License along
with this library; if not, write to the Free Software Foundation, Inc., 59
Temple Place - Suite 330, Boston, MA  02111-1307  USA.
