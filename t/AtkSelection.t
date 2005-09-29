#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper
  tests => 8,
  at_least_version => [2, 6, 0, "Need GtkIconView"];

# $Header$

my $model = Gtk2::ListStore->new (qw(Glib::String));
my $iter = $model -> append();
$model -> set($iter, 0 => "Test");

my $view = Gtk2::IconView -> new_with_model($model);
$view -> set_text_column(0);

my $accessible = $view -> get_accessible();
isa_ok($accessible, "Gtk2::Atk::Selection");

TODO: {
  local $TODO = "this doesn't actually call GtkIconView's action stuff -- why?";

  ok($accessible -> add_selection(0));

  my $selection = $accessible -> ref_selection(0);
  isa_ok($selection, "Gtk2::Atk::Object");

  is($accessible -> get_selection_count(), 1);
  ok($accessible -> is_child_selected(0));
  ok($accessible -> remove_selection(0));
  ok($accessible -> select_all_selection());

  ok($accessible -> clear_selection());
}

__END__

Copyright (C) 2005 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
