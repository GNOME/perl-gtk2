#########################
# GtkListStore, GtkTreeView Tests
# 	- rm
#########################
#
# $Header$
#
# Pretty much complete
#
# TODO:
#	accessed as a: GtkTreeDragSource, GtkTreeDragDest and GtkTreeSortable.
#

use strict;
use warnings;

#########################

use Gtk2;
use Test::More;

if( Gtk2->init_check )
{
	plan tests => 19;
}
else
{
	plan skip_all =>
		'Gtk2->init_check failed, probably unable to open DISPLAY';
}

#########################

require './t/ignore_keyboard.pl';

my $win = Gtk2::Window->new;

my @cols = (
		{ title => 'Author', type => 'Glib::String',  },
		{ title => 'Work',   type => 'Glib::String',  },
		{ title => 'Sold',   type => 'Glib::Uint',    },
		{ title => 'Print',  type => 'Glib::Boolean', },
	);

ok (my $store = Gtk2::ListStore->new (map {$_->{type}} @cols), 'new liststore');

$store->set_column_types (map {$_->{type}} @cols);
ok (1, '$store->set_column_types');

my @data = (
	{ Author => 'John Doe', Work => 'Who am I', Sold => '32', Print => 0 },
	{ Author => 'John Doe', Work => 'Who am I', Sold => '44', Print => 1 },
);

my $iter;
foreach (@data)
{
	$iter = $store->append;
	$store->set($iter,
		1, $_->{Work},
		0, $_->{Author},
		2, $_->{Sold},
		3, $_->{Print} );
	ok (eq_array ([$store->get ($iter)], 
		      [$_->{Author}, $_->{Work}, $_->{Sold}, $_->{Print},]),
		'$store->set/get');
}

ok ($iter = $store->insert (0), '$store->insert (5)');
ok ($iter = $store->insert (0), '$store->insert (0)');
ok ($iter = $store->insert_before ($iter), '$store->insert_before');
ok ($iter = $store->insert_after ($iter), '$store->insert_after');
ok ($iter = $store->get_iter_first, '$store->get_iter_first, treemodel');
if ((Gtk2->get_version_info)[1] < 2) {
	# remove had void return in 2.0.x, and the binding for this method
	# always returns false.  remove this special case if that method is
	# ever fixed.
	ok (!$store->remove ($iter), '$store->remove 1');
} else {
	ok ($store->remove ($iter), '$store->remove 1');
}
ok ($iter = $store->prepend, '$store->prepend');
if ((Gtk2->get_version_info)[1] < 2) {
	# remove had void return in 2.0.x, and the binding for this method
	# always returns false.  remove this special case if that method is
	# ever fixed.
	ok (!$store->remove ($iter), '$store->remove 2');
} else {
	ok ($store->remove ($iter), '$store->remove 2');
}
	
ok (my $tree = Gtk2::TreeView->new_with_model($store), 'new treeview');
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
		SKIP: {
			skip 'function only in version > 2.2', 5
				unless ((Gtk2->get_version_info)[1] >= 2);
			$store->reorder(4, 3, 2, 0, 1);
			$iter = $store->get_iter_first;
			ok ($store->iter_is_valid ($iter), 
				'$store->iter_is_valid');
			ok (eq_array ([$store->get ($iter), 
				       $store->get ($store->iter_next($iter))],
				      ['John Doe', 'Who am I', 32, 0,
				       'John Doe', 'Who am I', 44, 1]), 
			       '$store->reorder worked');
			$store->swap ($iter, $store->iter_next($iter));
			$iter = $store->get_iter_first;
			ok (eq_array ([$store->get ($iter), 
				       $store->get ($store->iter_next($iter))],
				      ['John Doe', 'Who am I', 44, 1,
				       'John Doe', 'Who am I', 32, 0]), 
			       '$store->swap worked');
			$iter = $store->get_iter_first;
			$store->move_before ($iter, undef);
			ok (eq_array ([$store->get 
					($store->iter_nth_child(undef, 4))],
				      ['John Doe', 'Who am I', 44, 1]), 
			       '$store->move_before worked');
			$store->move_after ($iter, $store->get_iter_first);
			ok (eq_array ([$store->get 
					($store->iter_nth_child(undef, 1))],
				      ['John Doe', 'Who am I', 44, 1]), 
			       '$store->move_after worked');
		}
		$store->clear;
		ok ($store->iter_n_children == 0, 
			'$store->clear/iter_n_children');
		Gtk2->main_quit;
		0;
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
