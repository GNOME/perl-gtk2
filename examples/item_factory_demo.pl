#!/usr/bin/perl
#
# $Header$
#

# GTK - The GIMP Toolkit
# Copyright (C) 1995-1997 Peter Mattis, Spencer Kimball and Josh MacDonald
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Library General Public
# License as published by the Free Software Foundation; either
# version 2 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Library General Public License for more details.
#
# You should have received a copy of the GNU Library General Public
# License along with this library; if not, write to the
# Free Software Foundation, Inc., 59 Temple Place - Suite 330,
# Boston, MA 02111-1307, USA.

# based strongly on a script by gavin brown posted on the gtk-perl mailling
# list.

use Gtk2;
use strict;

Gtk2->init;

my $window = Gtk2::Window->new('toplevel');
$window->signal_connect('delete_event', sub { exit });

my @items = (
	[
		'/_Menu',
		undef,
		undef,
		undef,
		'<Branch>',
	],
	[
		'/_Menu/Run Galeon',
		undef,
		\&callback,
		1,
		'<StockItem>',
		'gtk-execute'
	],
	[
		'/_Menu/Run Terminal',
		undef,
		sub { print STDERR "you found the magic menu item\n"; },
		2,
		'<StockItem>',
		'gtk-execute'
	],	[
		'/_Menu/Run GIMP',
		undef,
		\&callback,
		3,
		'<StockItem>',
		'gtk-execute'
	],
	[
		'/_Menu/Editors',
		undef,
		undef,
		undef,
		'<Branch>',
	],
	[
		'/_Menu/Editors/Run Gedit',
		undef,
		\&callback,
		4,
		'<StockItem>',
		'gtk-execute'
	],
	[
		'/_Menu/Editors/Run Emacs',
		undef,
		\&callback,
		5,
		'<StockItem>',
		'gtk-execute'
	],
	[
		'/_Menu/Editors/Run nipples',
		undef,
		\&callback,
		6,
		'<StockItem>',
		'gtk-execute'
	],
);

use Data::Dumper;
sub callback
{
	print STDERR Dumper( @_ );
}

my $factory = Gtk2::ItemFactory->new('Gtk2::MenuBar', '<main>', undef);

$factory->create_items('foo', @items);

my $menu = $factory->get_widget('<main>');

$window->add($menu);

$window->show_all;

Gtk2->main;
