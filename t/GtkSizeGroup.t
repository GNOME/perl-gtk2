#!/usr/bin/perl -w
use strict;

use Gtk2;
use Gtk2::TestHelper tests => 2;

my $group = Gtk2::SizeGroup -> new("vertical");
isa_ok($group, "Gtk2::SizeGroup");

$group -> set_mode("horizontal");
is($group -> get_mode(), "horizontal");

my $label = Gtk2::Label -> new("Bla");

$group -> add_widget($label);
$group -> remove_widget($label);
