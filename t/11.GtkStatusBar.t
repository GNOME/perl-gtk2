#
# $Header$
#

use strict;
use warnings;

#########################
# GtkStatusbar Tests
# 	- rm
#########################

#########################

use Gtk2::TestHelper tests => 10;

ok( my $win = Gtk2::Window->new('toplevel') );
$win->set_title('GtkStatusbar.t Test Window');
$win->set_default_size(120,25);

ok( my $sts = Gtk2::Statusbar->new );
$win->add($sts);

$sts->set_has_resize_grip(1);
is( $sts->get_has_resize_grip, 1 );

ok( my $sts_cid1 = $sts->get_context_id('Main') );
ok( $sts->push($sts_cid1, 'Ready 1-0') );
ok( $sts->push($sts_cid1, 'Ready 1-1') );

ok( my $sts_cid2 = $sts->get_context_id('Not Main') );
ok( my $sts_mid1 = $sts->push($sts_cid2, 'Ready 2-0') );
ok( $sts->push($sts_cid2, 'Ready 2-1') );

$win->show_all;

$sts->pop($sts_cid2);
$sts->pop($sts_cid1);

Glib::Idle->add( sub {
		$sts->pop($sts_cid2);
		$sts->remove($sts_cid2, $sts_mid1);
		Gtk2->main_quit;
		0;
	});

Gtk2->main;

ok(1);

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list)

This library is free software; you can redistribute it and/or modify it under
the terms of the GNU Library General Public License as published by the Free
Software Foundation; either version 2.1 of the License, or (at your option) any
later version.

This library is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU Library General Public License for more
details.

You should have received a copy of the GNU Library General Public License along
with this library; if not, write to the Free Software Foundation, Inc., 59
Temple Place - Suite 330, Boston, MA  02111-1307  USA.
