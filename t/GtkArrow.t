#!/usr/bin/perl -w
use strict;

use Gtk2;
use Gtk2::TestHelper tests => 3;

# From Ross' original test.

my $arrow = Gtk2::Arrow -> new('up', 'none');
isa_ok($arrow, 'Gtk2::Arrow');

is_deeply([$arrow -> get(qw/arrow-type shadow-type/)],
          ['up', 'none'],
          '$arrow->new, verify');

$arrow -> set('down', 'in');

is_deeply([$arrow -> get(qw/arrow-type shadow-type/)],
          ['down', 'in'],
          '$arrow->set, verify');
