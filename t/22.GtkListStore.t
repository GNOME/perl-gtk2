#!/usr/bin/perl -w
use strict;
use warnings;
use Gtk2; # init/init_check not necessary, we do no gui stuff
use Test::More tests => 69;

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

Glib::Idle -> add(sub {
	Gtk2 -> main_quit();
	return 0;
});

Gtk2 -> main();

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
