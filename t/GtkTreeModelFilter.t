#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper
  tests => 23,
  noinit => 1,
  at_least_version => [2, 4, 0, "GtkTreeModelFilter is new in 2.4"];

# $Header$

my $list = Gtk2::ListStore -> new("Glib::Int", "Glib::String");

$list -> set($list -> append(), 0 => 42);
$list -> set($list -> append(), 0 => 23);
$list -> set($list -> append(), 0 => 23);
$list -> set($list -> append(), 0 => 23);

my $filter = Gtk2::TreeModelFilter -> new($list);
isa_ok($filter, "Gtk2::TreeModelFilter");

# make sure the GInterfaces are set up correctly
isa_ok($filter, "Gtk2::TreeModel");
isa_ok($filter, "Gtk2::TreeDragSource");
is(Gtk2::TreeModelFilter->can('get'), Gtk2::TreeModel->can('get'),
   ' $filter->get should be Gtk2::TreeModel::get');

$filter = Gtk2::TreeModelFilter -> new($list, undef);
isa_ok($filter, "Gtk2::TreeModelFilter");

is($filter -> get_model(), $list);

my $path = Gtk2::TreePath -> new_from_string("1");
my $iter = $list -> get_iter($path);

isa_ok(my $tmp = $filter -> convert_child_iter_to_iter($iter), "Gtk2::TreeIter");
isa_ok($filter -> convert_iter_to_child_iter($tmp), "Gtk2::TreeIter");

isa_ok($filter -> convert_child_path_to_path($path), "Gtk2::TreePath");
isa_ok($filter -> convert_path_to_child_path($path), "Gtk2::TreePath");

$filter -> set_visible_func(sub {
  my ($model, $iter, $data) = @_;

  is($model, $list);
  isa_ok($iter, "Gtk2::TreeIter");
  is($data, 23);

  return 1;
}, 23);

$filter -> set_modify_func(["Glib::Int", "Glib::String"], sub { warn @_; }, 42);

$filter -> refilter();
$filter -> clear_cache();

$filter = Gtk2::TreeModelFilter -> new($list, Gtk2::TreePath -> new_from_string("1"));
isa_ok($filter, "Gtk2::TreeModelFilter");

$filter -> set_visible_column(0);
$filter -> set_modify_func("Glib::Int", sub { warn @_; }, 42);

__END__

Copyright (C) 2003-2005 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
