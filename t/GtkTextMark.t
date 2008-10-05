#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper tests => 7, noinit => 1;

# $Id$

my $buffer = Gtk2::TextBuffer -> new();
my $iter = $buffer -> get_start_iter();

$buffer -> insert($iter, "Lore ipsem dolor.  I think that is misspelled.\n");

my $mark = $buffer -> create_mark("bla", $iter, 1);
is($mark -> get_name(), "bla");
is($mark -> get_buffer(), $buffer);
is($mark -> get_left_gravity(), 1);

$mark -> set_visible(1);
is($mark -> get_visible(), 1);

$buffer -> delete_mark($mark);
is($mark -> get_deleted(), 1);

SKIP: {
  skip 'new 2.12 stuff', 2
    unless Gtk2 -> CHECK_VERSION(2, 12, 0);

  my $mark = Gtk2::TextMark -> new(undef, TRUE);
  isa_ok($mark, 'Gtk2::TextMark');

  $mark = Gtk2::TextMark -> new('bla', TRUE);
  isa_ok($mark, 'Gtk2::TextMark');
}

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
