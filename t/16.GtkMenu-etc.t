#
# $Header$
#

use strict;
use warnings;

#########################
# GtkMenu-etc Tests
# 	- rm
#########################

#########################

use Gtk2;
use Test::More;

if( Gtk2->init_check )
{
	plan tests => 31;
}
else
{
	plan skip_all =>
		'Gtk2->init_check failed, probably unable to open DISPLAY';
}

#########################

ok( my $win = Gtk2::Window->new('toplevel') );
$win->set_title('GtkMenu-etc.t Test Window');

ok( my $vbox = Gtk2::VBox->new(0, 5) );
$win->add($vbox);

ok( my $menubar = Gtk2::MenuBar->new );
$vbox->pack_start($menubar, 0, 0, 0);

my ($num, $menu, $menuitem, $rootmenu, $optmenu);
foreach $num (qw/1 2 3/)
{
	ok( $menu = Gtk2::Menu->new );
	$menuitem = undef;
	foreach (qw/One Two Three Four/)
	{
		ok( $menuitem = Gtk2::MenuItem->new($_.' '.$num) );
		$menu->append( $menuitem );
	}
	ok( $rootmenu = Gtk2::MenuItem->new('_Root Menu '.$num) );
	$menu->reorder_child($menuitem, 1);

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
$vbox->pack_start($optmenu, 0, 0, 0);
$optmenu->set_menu($menu);

Glib::Idle->add( sub {
		$menu->popup(undef, undef, undef, undef, 1, 0);
		ok(1);
		Gtk2->main_quit;
		0;
	});

$win->show_all;
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
