#!/usr/bin/perl -w
use strict;

use Gtk2;
use Gtk2::TestHelper tests => 5, noinit => 1;

my $item_one = Gtk2::RadioMenuItem -> new();
isa_ok($item_one, "Gtk2::RadioMenuItem");

my $item_two = Gtk2::RadioMenuItem -> new("_Bla");
isa_ok($item_two, "Gtk2::RadioMenuItem");

my $item_three = Gtk2::RadioMenuItem -> new_with_label("Bla");
isa_ok($item_three, "Gtk2::RadioMenuItem");

my $item_four = Gtk2::RadioMenuItem -> new_with_mnemonic("Bla");
isa_ok($item_four, "Gtk2::RadioMenuItem");

$item_two -> set_group($item_one);
$item_three -> set_group($item_one);
$item_four -> set_group($item_one);

is_deeply($item_one -> get_group(), [$item_one, $item_two, $item_three, $item_four]);

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
