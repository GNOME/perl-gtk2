#
# $Header$
#

#########################
# GtkMenu Tests
# 	- rm
#########################

use Gtk2::TestHelper tests => 52;

ok( my $menubar = Gtk2::MenuBar->new );

my ($num, $menu, $accelgroup, $button, $menuitem, $rootmenu, $optmenu);
foreach $num (qw/1 2 3/)
{
	ok( $menu = Gtk2::Menu->new );

	$accelgroup = Gtk2::AccelGroup->new;

	$menu->set_accel_group ($accelgroup);
	is ($menu->get_accel_group, $accelgroup);

	$menu->set_accel_path ("<gtk2perl>/main/menu");

	$menu->set_title ("gtk2perl bla");
	is ($menu->get_title, "gtk2perl bla");

	$menu->set_tearoff_state (0);
	ok (!$menu->get_tearoff_state);

	$menu->reposition;

	$button = Gtk2::Button->new ("Bla");

	$menu->attach_to_widget ($button, sub {
		my ($callback_button, $callback_menu) = @_;

		is ($callback_button, $button);
		is ($callback_menu, $menu);
	});

	is ($menu->get_attach_widget, $button);
	$menu->detach;

	SKIP: {
		skip "set_screen is new in 2.2", 0
			if Gtk2->check_version (2, 2, 0);

		$menu->set_screen (Gtk2::Gdk::Screen->get_default);
	}

	$menuitem = undef;
	foreach (qw/One Two Three Four/)
	{
		ok( $menuitem = Gtk2::MenuItem->new($_.' '.$num) );
		$menu->append( $menuitem );
	}
	ok( $rootmenu = Gtk2::MenuItem->new('_Root Menu '.$num) );
	$menu->reorder_child($menuitem, 1);

	$menu->set_active (1);
	is ($menu->get_active, $menuitem);

	if( $num == 1 )
	{
		$rootmenu->set_submenu($menu);
#		$menu->set_tearoff_state(1);
		$menubar->append($rootmenu);
		ok(1);
	}
	elsif( $num == 2 )
	{
		$rootmenu->set_submenu($menu);
		$rootmenu->set_right_justified(1);
		$menubar->append($rootmenu);
		ok(1);
	}
	elsif( $num == 3 )
	{
		ok(1);
	}

	ok(1);
}

ok( $optmenu = Gtk2::OptionMenu->new );
$optmenu->set_menu($menu);

my $position_callback = sub {
	my ($menu, $x, $y, $data) = @_;

	isa_ok ($menu, "Gtk2::Menu");
	like ($x, qr/^\d+$/);
	like ($y, qr/^\d+$/);
	is ($data, "bla");

	return (10, 10);
};

$menu->popup(undef, undef, $position_callback, "bla", 1, 0);
$menu->popdown;
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
