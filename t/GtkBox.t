#!/usr/bin/perl -w
use strict;

use Gtk2;
use Gtk2::TestHelper tests => 8;

my $box = Gtk2::VBox -> new();
isa_ok($box, "Gtk2::Box");

my $label = Gtk2::Label -> new("Bla");
my $frame = Gtk2::Frame -> new("Bla");
my $button = Gtk2::Button -> new("Bla");
my $entry = Gtk2::Entry -> new();

$box -> pack_start($label, 0, 1, 5);
$box -> pack_end($frame, 1, 0, 10);
$box -> pack_start_defaults($button);
$box -> pack_end_defaults($entry);

is_deeply([$box -> query_child_packing($label)], [undef, 1, 5, "start"]);
is_deeply([$box -> query_child_packing($frame)], [1, undef, 10, "end"]);
is_deeply([$box -> query_child_packing($button)], [1, 1, 0, "start"]);
is_deeply([$box -> query_child_packing($entry)], [1, 1, 0, "end"]);

$box -> set_child_packing($button, 0, 0, 23, "end");
is_deeply([$box -> query_child_packing($button)], [undef, undef, 23, "end"]);

$box -> set_homogeneous(1);
is($box -> get_homogeneous(), 1);

$box -> set_spacing(5);
is($box -> get_spacing(), 5);

$box -> reorder_child($label, -1);
