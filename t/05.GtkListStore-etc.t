#########################
# GtkListStore, GtkTreeView Tests
# 	- rm
#########################
#
# $Header$
#

use strict;
use warnings;

#########################

use Gtk2;
use Test::More;

if( Gtk2->init_check )
{
	plan tests => 3;
}
else
{
	plan skip_all =>
		'Gtk2->init_check failed, probably unable to open DISPLAY';
}

#########################

require './t/ignore_keyboard.pl';

ok( my $win = Gtk2::Window->new );

my @cols = (
		{ title => 'Author', type => 'Glib::String',  },
		{ title => 'Work',   type => 'Glib::String',  },
		{ title => 'Sold',   type => 'Glib::Uint',    },
		{ title => 'Print',  type => 'Glib::Boolean', },
	);

ok( my $store = Gtk2::ListStore->new( map {$_->{type}} @cols ) );

my @data = (
	{ Author => 'John Doe', Work => 'Who am I', Sold => '32', Print => 0 },
	{ Author => 'John Doe', Work => 'Who am I', Sold => '44', Print => 1 },
);

foreach (@data)
{
	my $iter = $store->append;
	$store->set($iter,
		1, $_->{Work},
		0, $_->{Author},
		2, $_->{Sold},
		3, $_->{Print} );
}

ok( my $tree = Gtk2::TreeView->new_with_model($store) );
$win->add($tree);

my $renderer;
my $column;
my $i = 0;
foreach (@cols)
{
	if( $_->{type} =~ /Glib::String/ )
	{
		$renderer = Gtk2::CellRendererText->new;
		$column = Gtk2::TreeViewColumn->new_with_attributes(
			$_->{title}, $renderer, text => $i );
		$tree->append_column($column);
	}
	elsif( $_->{type} =~ /Glib::Uint/ )
	{
		$renderer = Gtk2::CellRendererText->new;
		$column = Gtk2::TreeViewColumn->new_with_attributes(
			$_->{title}, $renderer, text =>  $i );
		$tree->append_column($column);
	}
	elsif( $_->{type} =~ /Glib::Boolean/ )
	{
  		$renderer = Gtk2::CellRendererToggle->new;
		$column = Gtk2::TreeViewColumn->new_with_attributes(
			$_->{title}, $renderer, active =>  $i );
		$tree->append_column($column);
	}
	$i++;
}

$win->show_all;

Glib::Idle->add( sub {
		if( (Gtk2->get_version_info)[1] >= 2 )
		{
			$store->reorder(1, 0);
		}
		Gtk2->main_quit;
	} );

Gtk2->main;

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
