#
# $Header$
#

#########################
# Gtk2::ItemFactory Tests
# 	- rm
#########################

use Gtk2::TestHelper tests => 9;

my @actions_used = (qw/1 0 0 0 0/);
my @items = (
	[
		'/_Menu',
		undef,
		undef,
		undef,
		'<Branch>',
	],
	[
		'/_Menu/Test _1',
		undef,
		\&callback,
		1,
		'<StockItem>',
		'gtk-execute'
	],
	{
		path => '/_Menu/Test _2',
		callback => \&callback,
		callback_action => 2,
		item_type => '<StockItem>',
		extra_data => 'gtk-execute'
	},
	{
		path => '/_Menu/Sub _Menu',
		item_type => '<Branch>',
	},
	[
		'/_Menu/Sub Menu/Test _1',
		undef,
		\&callback,
		3,
		'<StockItem>',
		'gtk-execute'
	],
	[
		'/_Menu/Sub Menu/Test _2',
		undef,
		sub { $actions_used[4]++; },
		undef,
		undef,
	],
	[
		'/_Menu/_Quit',
		undef,
		sub { Gtk2->main_quit; },
		5,
		'<StockItem>',
		'gtk-quit'
	],
);

sub callback
{
	shift;
	$actions_used[shift]++;
}

ok( Gtk2->init );

ok( my $win = Gtk2::Window->new );

ok( my $fac = Gtk2::ItemFactory->new('Gtk2::MenuBar', '<main>', undef) );

$fac->create_items(44, @items);

ok( my $menu = $fac->get_widget('<main>') );

$win->add($menu);

$win->show_all;

Glib::Idle->add( sub {
		$fac->get_widget('/Menu/Test 1')->activate;
		$fac->get_widget('/Menu/Test 2')->activate;
		$fac->get_widget('/Menu/Sub Menu/Test 1')->activate;
		$fac->get_widget('/Menu/Sub Menu/Test 2')->activate;
		$fac->get_widget('/Menu/Quit')->activate;
	});

Gtk2->main;

foreach (@actions_used)
{
	ok( $_ );
}

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
