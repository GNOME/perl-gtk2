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
isa_ok($accessible, "Gtk2::Atk::Action");

TODO: {
  local $TODO = "this doesn't actually call GtkIconView's action stuff -- why?";

  is($accessible -> get_n_actions(), 1);
  is($accessible -> do_action(0), TRUE);

  ok(defined $accessible -> get_description(0));
  ok(defined $accessible -> get_name(0));
  ok(defined $accessible -> get_keybinding(0));

  ok($accessible -> set_description(0, "Test"));

  # This would need a version check for atk 1.1, but we already require gtk+
  # 2.6, so I guess it's ok.
  ok(defined $accessible -> get_localized_name(0));
}

__END__

Copyright (C) 2005 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
