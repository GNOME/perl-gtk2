#!/usr/bin/perl -w
use strict;

use Gtk2;
use Gtk2::TestHelper tests => 9;

my $frame = Gtk2::Frame -> new();
isa_ok($frame, "Gtk2::Frame");
is($frame -> get_label(), undef);

$frame = Gtk2::Frame -> new("Bla");
isa_ok($frame, "Gtk2::Frame");
is($frame -> get_label(), "Bla");

$frame -> set_label();
is($frame -> get_label(), undef);

$frame -> set_label("Bla");
is($frame -> get_label(), "Bla");

$frame -> set_label_align(0.5, 0.5);
is_deeply([$frame -> get_label_align()], [0.5, 0.5]);

$frame -> set_shadow_type("etched-in");
is($frame -> get_shadow_type(), "etched-in");

my $label = Gtk2::Label -> new("Bla");

$frame -> set_label_widget($label);
is($frame -> get_label_widget(), $label);