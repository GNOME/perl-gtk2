#!/usr/bin/perl -w
use strict;

use Gtk2;
use Gtk2::TestHelper tests => 3;

# Blatantly stolen from Ross' original test.

my $frame = Gtk2::AspectFrame -> new("Label", 1, 1, 3, 0);
isa_ok($frame, "Gtk2::AspectFrame");
is_deeply([$frame -> get(qw/xalign yalign ratio obey-child/)],
          [1, 1, 3, 0], '$aspect->new, verify');

$frame -> set_params(1, 1, 6, 1);
is_deeply([$frame -> get(qw/xalign yalign ratio obey-child/)],
          [1, 1, 6, 1], '$aspect->set_params, verify');
