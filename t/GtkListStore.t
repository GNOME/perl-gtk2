#!/usr/bin/perl -w

use Gtk2::TestHelper tests => 69, noinit => 1;

###############################################################################

my $model = Gtk2::ListStore -> new("Glib::String", "Glib::Int");
isa_ok($model, "Gtk2::ListStore");

foreach (qw(bla blee bliii bloooo)) {
	my $iter = $model -> append();
	isa_ok($iter, "Gtk2::TreeIter");

	$model -> set($iter,
		      0 => $_,
		      1 => length($_));

	is($model -> get($iter, 0), $_);
	is($model -> get($iter, 1), length($_));

	is(($model -> get($iter, 0, 1))[0], $_);
	is(($model -> get($iter, 0, 1))[1], length($_));

	is($model -> get_value($iter, 0), $_);
	is($model -> get_value($iter, 1), length($_));
}

my $count = $model -> get_n_columns();
is($count, 2);

is($model -> get_column_type(0), "Glib::String");
is($model -> get_column_type(1), "Glib::Int");

my $flags = $model -> get_flags();
is($flags -> [0], "iters-persist");
is($flags -> [1], "list-only");

###############################################################################

my($path_one, $path_two);

$path_one = Gtk2::TreePath -> new();
isa_ok($path_one, "Gtk2::TreePath");

$path_one = Gtk2::TreePath -> new_from_string("0");
is($path_one -> to_string(), "0");

$path_one = Gtk2::TreePath -> new_first();
is($path_one -> to_string(), "0");

$path_two = $path_one -> copy();
is($path_one -> compare($path_two), 0);

###############################################################################

SKIP: {
	skip("there doesn't seem to be a GType for GtkTreeRowReference in 2.0.x", 4)
		unless ((Gtk2 -> get_version_info())[1] >= 2);

	my ($ref_one, $ref_two, $ref_path);

	$ref_one = Gtk2::TreeRowReference -> new($model, Gtk2::TreePath -> new_from_string("0"));
	isa_ok($ref_one, "Gtk2::TreeRowReference");
	is($ref_one -> valid(), 1);

	$ref_path = $ref_one -> get_path();
	is($ref_path -> to_string(), "0");

	$ref_two = $ref_one -> copy();
	is($ref_two -> valid(), 1);
}

###############################################################################

my $iter;

$iter = $model -> get_iter(Gtk2::TreePath -> new_from_string("0"));
isa_ok($iter, "Gtk2::TreeIter");
is($model -> get_path($iter) -> to_string(), "0");

$iter = $model -> get_iter_from_string("0");
is($model -> get_path($iter) -> to_string(), "0");

$iter = $model -> get_iter_first();
is($model -> get_path($iter) -> to_string(), "0");

my $next = $model -> iter_next($iter);
is($model -> get_path($iter) -> to_string(), "0");
is($model -> get_path($next) -> to_string(), "1");

SKIP: {
	skip("get_string_from_iter is new in 2.2.x", 1)
		unless ((Gtk2 -> get_version_info())[1] >= 2);

	is($model -> get_string_from_iter($iter), "0");
}

###############################################################################

$model -> foreach(sub {
	my ($model, $path, $iter) = @_;

	isa_ok($model, "Gtk2::ListStore");
	isa_ok($path, "Gtk2::TreePath");
	isa_ok($iter, "Gtk2::TreeIter");

	return 1;
});

###############################################################################

my $path_model = Gtk2::TreePath -> new_from_string("0");
my $iter_model;

$model -> remove($model -> get_iter($path_model));
is($model -> get($model -> get_iter($path_model), 0), "blee");

$model -> clear();

$iter_model = $model -> prepend();
$model -> set($iter_model, 0 => "bla", 1 => 3);
is($model -> get($iter_model, 0), "bla");

$iter_model = $model -> insert(1);
$model -> set($iter_model, 0 => "ble", 1 => 3);
is($model -> get($iter_model, 0), "ble");

$iter_model = $model -> insert_before($model -> get_iter_from_string("1"));
$model -> set($iter_model, 0 => "bli", 1 => 3);
is($model -> get($iter_model, 0), "bli");

$iter_model = $model -> insert_after($model -> get_iter_from_string("1"));
$model -> set($iter_model, 0 => "blo", 1 => 3);
is($model -> get($iter_model, 0), "blo");

###############################################################################

SKIP: {
	skip("swap, move_before, move_after and reorder are new in 2.2.x", 10)
		unless ((Gtk2 -> get_version_info())[1] >= 2);


	$model -> swap($model -> get_iter_from_string("1"),
		       $model -> get_iter_from_string("2"));

	is($model -> get($model -> get_iter_from_string("1"), 0), "blo");
	is($model -> get($model -> get_iter_from_string("2"), 0), "bli");

	$model -> move_before($model -> get_iter_from_string("1"),
			      $model -> get_iter_from_string("3"));

	is($model -> get($model -> get_iter_from_string("2"), 0), "blo");

	$model -> move_after($model -> get_iter_from_string("3"),
			     $model -> get_iter_from_string("0"));

	is($model -> get($model -> get_iter_from_string("1"), 0), "ble");

	my $tag = $model->signal_connect("rows_reordered", sub {
		my $new_order = $_[3];
		isa_ok($new_order, "ARRAY", "new index order");
		ok(eq_array($new_order, [3, 2, 1, 0]));
	});
	$model -> reorder(3, 2, 1, 0);
	$model -> signal_handler_disconnect ($tag);

	is($model -> get($model -> get_iter_from_string("0"), 0), "blo");
	is($model -> get($model -> get_iter_from_string("1"), 0), "bli");
	is($model -> get($model -> get_iter_from_string("2"), 0), "ble");
	is($model -> get($model -> get_iter_from_string("3"), 0), "bla");
}

# but the rows_reordered method is always available.
# give it a test-drive, too.
my $tag = $model->signal_connect("rows_reordered", sub {
	my $new_order = $_[3];
	isa_ok($new_order, "ARRAY", "new index order");
	ok(eq_array($new_order, [3, 2, 1, 0]));
});
$model->rows_reordered (Gtk2::TreePath->new, undef, 3, 2, 1, 0);
$model->signal_handler_disconnect ($tag);

###############################################################################

# Ross' 05.GtkListStore-etc.t.  I did not have the heart to simply merge both
# tests.

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

foreach (@data)
{
	my $iter = $store->append;
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
