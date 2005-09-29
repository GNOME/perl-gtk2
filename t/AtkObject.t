#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper
  tests => 14,
  at_least_version => [2, 6, 0, "Need GtkIconView"];

# $Header$

my $model = Gtk2::ListStore->new (qw(Glib::String));
my $iter = $model -> append();
$model -> set($iter, 0 => "Test");

my $view = Gtk2::IconView -> new_with_model($model);
$view -> set_text_column(0);

my $accessible = $view -> get_accessible();
isa_ok($accessible, "Gtk2::Atk::Object");

Gtk2::Atk::Object::set_name($accessible, "urgs");
is(Gtk2::Atk::Object::get_name($accessible), "urgs");

Gtk2::Atk::Object::set_description($accessible, "Urgs");
is(Gtk2::Atk::Object::get_description($accessible), "Urgs");

$accessible -> set_parent($accessible);
is($accessible -> get_parent(), $accessible);

$accessible -> set_role("invalid");
is($accessible -> get_role(), "invalid");

is($accessible -> get_n_accessible_children(), 0);
is($accessible -> ref_accessible_child(0), undef);
isa_ok($accessible -> ref_relation_set(), "Gtk2::Atk::RelationSet");
is($accessible -> get_layer(), "widget");
ok(defined $accessible -> get_mdi_zorder());
isa_ok($accessible -> ref_state_set(), "Gtk2::Atk::StateSet");
ok(defined $accessible -> get_index_in_parent());

$accessible -> notify_state_change("armed", TRUE);

ok($accessible -> add_relationship("embeds", $accessible));
ok($accessible -> remove_relationship("embeds", $accessible));

__END__

Copyright (C) 2005 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
