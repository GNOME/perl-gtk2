#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper
  tests => 12,
  at_least_version => [2, 6, 0, "Need GtkIconView"];

# $Header$

my $model = Gtk2::ListStore->new (qw(Glib::String));
my $iter = $model -> append();
$model -> set($iter, 0 => "Test");

my $view = Gtk2::IconView -> new_with_model($model);
$view -> set_text_column(0);

my $accessible = $view -> get_accessible();
isa_ok($accessible, "Gtk2::Atk::Component");

TODO: {
  local $TODO = "this doesn't actually call GtkIconView's action stuff -- why?";

  ok(!$accessible -> contains(0, 0, "screen"));
  is($accessible -> ref_accessible_at_point(0, 0, "screen"), undef);

  my @extents = $accessible -> get_extents("screen");
  is(@extents, 4);

  my @position = $accessible -> get_position("screen");
  is(@position, 2);

  my @size = $accessible -> get_size();
  is(@size, 2);

  is($accessible -> get_layer(), "widget");
  ok(defined $accessible -> get_mdi_zorder());
  ok(!$accessible -> grab_focus());

  ok(!$accessible -> set_extents(1, 2, 3, 4, "screen"));
  ok(!$accessible -> set_position(1, 2, "screen"));
  ok(!$accessible -> set_size(1, 2));
}

__END__

Copyright (C) 2005 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
