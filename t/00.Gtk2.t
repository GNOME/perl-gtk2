#
# $Header$
#

use strict;
use warnings;

#########################
# Gtk2 Tests
# 	- rm
#########################

#########################

use Test::More tests => 15;
BEGIN { use_ok('Gtk2') };

#########################

ok( Gtk2->get_version_info );
ok( Gtk2->check_version(0,0,0) eq 'Gtk+ version too new (major mismatch)' );
ok( Gtk2->check_version(50,0,0) eq 'Gtk+ version too old (major mismatch)' );

SKIP:
{
	skip 'Gtk2->init_check failed, probably unable to open DISPLAY', 
		11, unless( Gtk2->init_check );

	ok( Gtk2->init );

	ok( Gtk2->events_pending == 0 );

	ok( Gtk2->main_level == 0 );

	Gtk2->init_add( sub { ok(1); } );
	Gtk2->init_add( sub { ok($_[0] eq 'foo'); }, 'foo' );
	ok(1);

	my $q1;
	ok( $q1 = Gtk2->quit_add( 0, sub { Gtk2->quit_remove($q1); ok(1); } ) );
	ok( Gtk2->quit_add( 0, sub { ok($_[0] eq 'bar'); }, 'bar' ) );

	Glib::Idle->add( sub { Gtk2->main_quit; 0 } );
	Gtk2->main;
	ok(1);
}

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
