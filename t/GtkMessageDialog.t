#!/usr/bin/perl -w
use strict;

use Gtk2;
use Gtk2::TestHelper tests => 2;

my $dialog = Gtk2::MessageDialog -> new(undef,
                                        "destroy-with-parent",
                                        "warning",
                                        "ok-cancel",
                                        "%s, %d", "Bla", 23);
isa_ok($dialog, "Gtk2::MessageDialog");

$dialog = Gtk2::MessageDialog -> new(undef,
                                        "destroy-with-parent",
                                        "warning",
                                        "ok-cancel",
                                        "Bla, 23");
isa_ok($dialog, "Gtk2::MessageDialog");
