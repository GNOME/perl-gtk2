#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper
  tests => 5,
  at_least_version => [2, 6, 0, "Need GtkIconView"];

# $Header$

my $model = Gtk2::ListStore->new (qw(Glib::String));
my $iter = $model -> append();
$model -> set($iter, 0 => "Test");

my $view = Gtk2::IconView -> new_with_model($model);
$view -> set_text_column(0);

my $accessible = $view -> get_accessible();
isa_ok($accessible, "Gtk2::Atk::Image");

TODO: {
  local $TODO = "this doesn't actually call GtkIconView's action stuff -- why?";

  is($accessible -> get_image_description(), undef);

  my @size = $accessible -> get_image_size();
  is(@size, 2);

  my @position = $accessible -> get_image_position("screen");
  is(@position, 2);

  ok(!$accessible -> set_image_description("urgs"));
}

__END__

Copyright (C) 2005 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
