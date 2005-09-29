#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper tests => 10, noinit => 1;

# $Header$

my $list = Gtk2::ListStore -> new("Glib::Int");

$list -> set($list -> append(), 0 => 42);
$list -> set($list -> append(), 0 => 23);

my $sort = Gtk2::TreeModelSort -> new_with_model($list);
isa_ok($sort, "Gtk2::TreeModelSort");
isa_ok($sort, "Gtk2::TreeModel");
isa_ok($sort, "Gtk2::TreeSortable");
is($sort -> get_model(), $list);

SKIP: {
  skip '@ISA check', 1
    unless Gtk2 -> CHECK_VERSION (2, 4, 0);

  isa_ok($sort, "Gtk2::TreeDragSource");
}

my $path = Gtk2::TreePath -> new_from_string("1");
my $iter = $sort -> get_iter($path);

isa_ok($sort -> convert_child_path_to_path($path), "Gtk2::TreePath");
isa_ok($sort -> convert_child_iter_to_iter($iter), "Gtk2::TreeIter");
isa_ok($sort -> convert_path_to_child_path($path), "Gtk2::TreePath");
isa_ok($sort -> convert_iter_to_child_iter($iter), "Gtk2::TreeIter");

$sort -> reset_default_sort_func();
$sort -> clear_cache();

SKIP: {
  skip("iter_is_valid is new in 2.2", 1)
    unless Gtk2->CHECK_VERSION (2, 2, 0);

  is($sort -> iter_is_valid($sort -> get_iter($path)), 1);
}

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
