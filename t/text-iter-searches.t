
use Test::More tests => 17;
use_ok ('Gtk2');

Gtk2->init;

$model = Gtk2::TextBuffer->new;
$model->insert ($model->get_start_iter, join " ", 'Lore ipsem dolor.  I think that is misspelled.'x80);

$iter = $model->get_iter_at_offset (10);

$end = $iter->copy;

$end->forward_find_char (sub { return 1 if $_[0] eq 'r'; }, undef, undef);

$text = $iter->get_text ($end);
is ($text, ' dolo', 'search forward');
is ($iter->get_offset, 10, 'from');
is ($end->get_offset, 15, 'to');

$begin = $end->copy;

$begin->backward_find_char (sub {return 1 if $_[0] eq 'L'; });

$text = $begin->get_text ($end);
is ($text, 'Lore ipsem dolo', 'search backward');
is ($begin->get_offset, 0, 'from');
is ($end->get_offset, 15, 'to');

($match_start, $match_end) = $iter->forward_search ('that', 'text-only');

isa_ok ($match_start, 'Gtk2::TextIter', 'match start');
isa_ok ($match_end, 'Gtk2::TextIter', 'match end');
$text = $match_start
      ? $match_start->get_text ($match_end)
      : undef;
is ($text, 'that', 'found string match forward');
is ($match_start->get_offset, 27, 'match start offset');
is ($match_end->get_offset, 31, 'match end offset');

($match_start, $match_end) = $model->get_end_iter->backward_search ('Lore', 'text-only');

isa_ok ($match_start, 'Gtk2::TextIter', 'match start');
isa_ok ($match_end, 'Gtk2::TextIter', 'match end');
$text = $match_start
      ? $match_start->get_text ($match_end)
      : undef;
is ($text, 'Lore', 'found string match backward');
is ($match_start->get_offset, 3634, 'match start offset');
is ($match_end->get_offset, 3638, 'match end offset');
