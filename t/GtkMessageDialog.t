#!/usr/bin/perl -w
use strict;
use Gtk2::TestHelper tests => 2, noinit => 1;

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

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
