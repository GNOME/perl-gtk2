#!/usr/bin/perl -w
use strict;

use Gtk2;
use Gtk2::TestHelper tests => 2;

my $alignment = Gtk2::Alignment -> new(2.3, 4.2, 7, 13);
isa_ok($alignment, "Gtk2::Alignment");

$alignment -> set(2.3, 4.2, 7, 13);

SKIP: {
  skip("[sg]et_padding are new in 2.4", 1)
    if (Gtk2 -> check_version(2, 4, 0));

  $alignment -> set_padding(1, 2, 3, 4);
  is_deeply([$alignment -> get_padding()], [1, 2, 3, 4]);
}
