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

use Test::More tests => 19;
BEGIN { use_ok('Gtk2') };

#########################

my @version = Gtk2->get_version_info;
is( @version, 3, 'version info is three items long' );
is( Gtk2->check_version(0,0,0), 'Gtk+ version too new (major mismatch)' );
is( Gtk2->check_version(50,0,0), 'Gtk+ version too old (major mismatch)' );

SKIP:
{
	Gtk2 -> disable_setlocale;

	skip 'Gtk2->init_check failed, probably unable to open DISPLAY', 
		15, unless( Gtk2->init_check );

	ok( Gtk2->init );
	ok( Gtk2->set_locale );

	isa_ok( Gtk2->get_default_language, "Gtk2::Pango::Language" );

	TODO: {
	local $TODO = ((Gtk2->get_version_info)[1] > 2)
	            ? "events_pending != 0 on 2.3.x ???"
	            : undef;
	is( Gtk2->events_pending, 0, 'no events pending on initialization' );
	}

	is( Gtk2->main_level, 0, 'main level is zero when there are no loops' );

	# warn Gtk2->main_iteration;
	is( Gtk2->main_iteration_do (0), 1 );

	# warn Gtk2->get_current_event;
	# warn Gtk2->get_current_event_time;
	# warn Gtk2->get_current_event_state;
	# warn Gtk2->get_event_widget;
	# warn $widget->propagate_event;

	my $snooper;
	ok( $snooper = Gtk2->key_snooper_install (sub { warn @_; 0; }, "bla") );
	Gtk2->key_snooper_remove ($snooper);

	Gtk2->init_add( sub { ok(1); } );
	Gtk2->init_add( sub { ok($_[0] eq 'foo'); }, 'foo' );
	ok(1);

	Gtk2->quit_add_destroy (1, Gtk2::Object->new ("Gtk2::Label"));

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
