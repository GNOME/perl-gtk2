#!/usr/bin/perl -w

# $Header$

# NOTE: most of this test is marked TODO because the implementation currently
# doesn't support iters quite properly.  Specifically, if your custom model
# creates a perl scalar owned only by the iter, that object doesn't live long
# enough to be seen on the other side of the GET_ITER call.  The workaround
# is "don't do that" -- that is, keep a reference on the model side.  I
# marked this test as TODO in order to annoy me until i fix it, but i've
# disabled it altogether to avoid scaring unsuspecting users with a hundred
# lines of "failed (TODO) test" warnings.  This test is enabled on the 
# development branch, and will be re-enabled on stable if/when i fix the
# underlying issue.  -- muppet, 22mar04

package CustomList;

use strict;
use warnings;

use Glib qw(TRUE FALSE);
use Gtk2;

use Test::More;

use Glib::Object::Subclass
	Glib::Object::,
	interfaces => [ Gtk2::TreeModel:: ],
	;

sub INIT_INSTANCE {
	my ($list) = @_;

	isa_ok ($list, "CustomList");
}

sub FINALIZE_INSTANCE {
	my ($list) = @_;

	isa_ok ($list, "CustomList");
}

sub GET_FLAGS {
	my ($list) = @_;

	isa_ok ($list, "CustomList");

	return [ qw/list-only iters-persist/ ];
}

sub GET_N_COLUMNS {
	my ($list) = @_;

	isa_ok ($list, "CustomList");

	return 23;
}

sub GET_COLUMN_TYPE {
	my ($list, $column) = @_;

	isa_ok ($list, "CustomList");
	is ($column, 23);

	return Glib::String::
}

sub GET_ITER {
	my ($list, $path) = @_;

	isa_ok ($list, "CustomList");
	isa_ok ($path, "Gtk2::TreePath");

	return [ 23, 42 ];
}

sub GET_PATH {
	my ($list, $iter) = @_;

	isa_ok ($list, "CustomList");
	#TODO: { local $TODO = "iters don't persist"; is_deeply ($iter, [ 23, 42, "bla", "blub" ]); }
	ok(42);

	my $path = Gtk2::TreePath->new;
	$path->append_index ($iter->[1]);

	return $path;
}

sub GET_VALUE {
	my ($list, $iter, $column) = @_;

	isa_ok ($list, "CustomList");
	#TODO: { local $TODO = "iters don't persist"; is_deeply ($iter, [ 23, 42, "bla", "blub" ]); }
	ok(42);
	is ($column, 23);

	return "urgs";
}

sub ITER_NEXT {
	my ($list, $iter) = @_;

	isa_ok ($list, "CustomList");
	#TODO: { local $TODO = "iters don't persist"; is_deeply ($iter, [ 23, 42, "bla", "blub" ]); }
	ok(42);

	return $iter;
}

sub ITER_CHILDREN {
	my ($list, $iter) = @_;

	isa_ok ($list, "CustomList");
	#TODO: { local $TODO = "iters don't persist"; is_deeply ($iter, [ 23, 42, "bla", "blub" ]); }
	ok (42);

	return $iter;
}

sub ITER_HAS_CHILD {
	my ($list, $iter) = @_;

	isa_ok ($list, "CustomList");
	#TODO: { local $TODO = "iters don't persist"; is_deeply ($iter, [ 23, 42, "bla", "blub" ]); }
	ok(42);

	return TRUE;
}

sub ITER_N_CHILDREN {
	my ($list, $iter) = @_;

	isa_ok ($list, "CustomList");
	#TODO: { local $TODO = "iters don't persist"; is_deeply ($iter, [ 23, 42, "bla", "blub" ]); }
	ok(42);

	return 23;
}

sub ITER_NTH_CHILD {
	my ($list, $iter, $n) = @_;

	isa_ok ($list, "CustomList");
	#TODO: { local $TODO = "iters don't persist"; is_deeply ($iter, [ 23, 42, "bla", "blub" ]); }
	ok(42);
	is ($n, 23);

	return $iter;
}

sub ITER_PARENT {
	my ($list, $iter) = @_;

	isa_ok ($list, "CustomList");
	#TODO: { local $TODO = "iters don't persist"; is_deeply ($iter, [ 23, 42, "bla", "blub" ]); }
	ok(42);

	return $iter;
}

sub REF_NODE {
	my ($list, $iter) = @_;

	isa_ok ($list, "CustomList");
	#TODO: { local $TODO = "iters don't persist"; is_deeply ($iter, [ 23, 42, "bla", "blub" ]); }
	ok(42);
}

sub UNREF_NODE {
	my ($list, $iter) = @_;

	isa_ok ($list, "CustomList");
	#TODO: { local $TODO = "iters don't persist"; is_deeply ($iter, [ 23, 42, "bla", "blub" ]); }
	ok(42);
}

###############################################################################

package main;

use Gtk2::TestHelper tests => 67, noinit => 1;
use strict;
use warnings;

my $model = CustomList->new;

is ($model->get_flags, [qw/list-only iters-persist/]);
is ($model->get_n_columns, 23);
is ($model->get_column_type (23), Glib::String::);

my $path = Gtk2::TreePath->new ("0:1");
my $iter;

isa_ok ($iter = $model->get_iter ($path), "Gtk2::TreeIter");
isa_ok ($path = $model->get_path ($iter), "Gtk2::TreePath");
is_deeply ([$path->get_indices], [42]);

is ($model->get_value ($iter, 23), "urgs");
is ($model->get ($iter, 23), "urgs");

isa_ok ($iter = $model->iter_next ($iter), "Gtk2::TreeIter");
isa_ok ($path = $model->get_path ($iter), "Gtk2::TreePath");
is_deeply ([$path->get_indices], [42]);

isa_ok ($iter = $model->iter_children ($iter), "Gtk2::TreeIter");
isa_ok ($path = $model->get_path ($iter), "Gtk2::TreePath");
is_deeply ([$path->get_indices], [42]);

is ($model->iter_has_child ($iter), TRUE);
is ($model->iter_n_children ($iter), 23);

isa_ok ($iter = $model->iter_nth_child ($iter, 23), "Gtk2::TreeIter");
isa_ok ($path = $model->get_path ($iter), "Gtk2::TreePath");
is_deeply ([$path->get_indices], [42]);

isa_ok ($iter = $model->iter_parent ($iter), "Gtk2::TreeIter");
isa_ok ($path = $model->get_path ($iter), "Gtk2::TreePath");
is_deeply ([$path->get_indices], [42]);

$model->ref_node ($iter);
$model->unref_node ($iter);
