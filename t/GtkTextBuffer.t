#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper tests => 32;

# $Header$

my $table = Gtk2::TextTagTable -> new();

my $buffer = Gtk2::TextBuffer -> new($table);
isa_ok($buffer, "Gtk2::TextBuffer");
is($buffer -> get_tag_table(), $table);

$buffer = Gtk2::TextBuffer -> new();
isa_ok($buffer, "Gtk2::TextBuffer");

isa_ok($buffer -> get_start_iter(), "Gtk2::TextIter");
isa_ok($buffer -> get_end_iter(), "Gtk2::TextIter");

$buffer -> set_modified(0);

$buffer -> insert($buffer -> get_start_iter(), "Lore ipsem dolor.  I think that is misspelled.\n");
is($buffer -> insert_interactive($buffer -> get_start_iter(), "Lore ipsem dolor.  I think that is misspelled.\n", 1), 1);
$buffer -> insert_at_cursor("Lore ipsem dolor.  I think that is misspelled.\n");
is($buffer -> insert_interactive_at_cursor("Lore ipsem dolor.  I think that is misspelled.\n", 1), 1);
$buffer -> insert_range($buffer -> get_end_iter(), $buffer -> get_iter_at_offset(141), $buffer -> get_end_iter());
is($buffer -> insert_range_interactive($buffer -> get_end_iter(), $buffer -> get_iter_at_offset(188), $buffer -> get_end_iter(), 1), 1);

my @tags = ($buffer -> create_tag("bla", indent => 2),
            $buffer -> create_tag("blub", indent => 2));

$buffer -> create_tag("blaa", indent => 2);
$buffer -> create_tag("bluub", indent => 2);

$buffer -> insert_with_tags($buffer -> get_start_iter(), "Lore ipsem dolor.  I think that is misspelled.\n", @tags);
$buffer -> insert_with_tags_by_name($buffer -> get_start_iter(), "Lore ipsem dolor.  I think that is misspelled.\n", "blaa", "bluub");

is($buffer -> get_line_count(), 9);
is($buffer -> get_char_count(), 376);
is($buffer -> get_modified(), 1);

isa_ok($buffer -> get_iter_at_line_offset(1, 10), "Gtk2::TextIter");
isa_ok($buffer -> get_iter_at_offset(100), "Gtk2::TextIter");
isa_ok($buffer -> get_iter_at_line(6), "Gtk2::TextIter");
isa_ok($buffer -> get_iter_at_line_index(3, 12), "Gtk2::TextIter");

my ($start, $end) = $buffer -> get_bounds();
isa_ok($start, "Gtk2::TextIter");
isa_ok($end, "Gtk2::TextIter");

$buffer -> set_text("Lore ipsem dolor.  I think that is misspelled.\n");
is($buffer -> get_text($buffer -> get_start_iter(), $buffer -> get_end_iter(), 1), "Lore ipsem dolor.  I think that is misspelled.\n");
is($buffer -> get_slice($buffer -> get_start_iter(), $buffer -> get_end_iter(), 1), "Lore ipsem dolor.  I think that is misspelled.\n");

$buffer -> delete($buffer -> get_start_iter(), $buffer -> get_end_iter());
is($buffer -> delete_interactive($buffer -> get_start_iter(), $buffer -> get_end_iter(), 1), 1);

$buffer -> insert_pixbuf($buffer -> get_start_iter(), Gtk2::Gdk::Pixbuf -> new("rgb", 0, 8, 10, 10));

my $anchor = Gtk2::TextChildAnchor -> new();
$buffer -> insert_child_anchor($buffer -> get_start_iter(), $anchor);

isa_ok($buffer -> get_iter_at_child_anchor($anchor), "Gtk2::TextIter");

isa_ok($buffer -> create_child_anchor($buffer -> get_start_iter()), "Gtk2::TextChildAnchor");

my $mark = $buffer -> create_mark("bla", $buffer -> get_start_iter(), 1);
isa_ok($mark, "Gtk2::TextMark");
is($buffer -> get_mark("bla"), $mark);

isa_ok($buffer -> get_iter_at_mark($mark), "Gtk2::TextIter");

$buffer -> move_mark($mark, $buffer -> get_end_iter());
$buffer -> move_mark_by_name("bla", $buffer -> get_start_iter());
$buffer -> delete_mark($mark);

$mark = $buffer -> create_mark("bla", $buffer -> get_start_iter(), 1);
$buffer -> delete_mark_by_name("bla");

isa_ok($buffer -> get_insert(), "Gtk2::TextMark");
isa_ok($buffer -> get_selection_bound(), "Gtk2::TextMark");

$buffer -> place_cursor($buffer -> get_end_iter());

ok(!$buffer -> delete_selection(1, 1));
ok(!$buffer -> get_selection_bounds());

SKIP: {
  skip("select_range is new in 2.4", 0)
    unless Gtk2->CHECK_VERSION (2, 4, 0);

  $buffer -> select_range($buffer -> get_start_iter(), $buffer -> get_end_iter());
}

my $tag_one = $buffer -> create_tag("alb", indent => 2);
isa_ok($tag_one, "Gtk2::TextTag");

$buffer -> apply_tag($tag_one, $buffer -> get_start_iter(), $buffer -> get_end_iter());
$buffer -> apply_tag_by_name("alb", $buffer -> get_start_iter(), $buffer -> get_end_iter());

my $tag_two = $buffer -> create_tag("bulb", indent => 2);
my $tag_three = $buffer -> create_tag(undef, indent => 2);
isa_ok($tag_two, "Gtk2::TextTag");
isa_ok($tag_three, "Gtk2::TextTag");

$buffer -> remove_tag($tag_one, $buffer -> get_start_iter(), $buffer -> get_end_iter());
$buffer -> remove_tag_by_name("bulb", $buffer -> get_start_iter(), $buffer -> get_end_iter());
$buffer -> remove_all_tags($buffer -> get_start_iter(), $buffer -> get_end_iter());

SKIP: {
  skip "GtkClipboard is new in 2.2", 0
    unless Gtk2->CHECK_VERSION (2, 2, 0);

  my $clipboard = Gtk2::Clipboard -> get(Gtk2::Gdk -> SELECTION_CLIPBOARD);

  $buffer -> paste_clipboard($clipboard, $buffer -> get_end_iter(), 1);
  $buffer -> paste_clipboard($clipboard, undef, 1);
  $buffer -> copy_clipboard($clipboard);
  $buffer -> cut_clipboard($clipboard, 1);

  $buffer -> add_selection_clipboard($clipboard);
  $buffer -> remove_selection_clipboard($clipboard);
}

$buffer -> begin_user_action();
$buffer -> end_user_action();

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
