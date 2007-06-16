#!/usr/bin/perl

# $Id$

use Gtk2::TestHelper
	at_least_version => [2, 11, 0, 'GtkRecentAtionc: new in 2.12'], # FIXME: 2.12
	tests => 1;


my $action = Gtk2::RecentAction->new (name => 'one',
                                      label => 'one',
                                      tooltip => 'one',
                                      stock_id => 'gtk-ok',
                                      recent_manager => Gtk2::RecentManager->new);
isa_ok($action, 'Gtk2::RecentAction');

__END__

Copyright (C) 2007 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
