#
# $Header$
#

#########################
# GtkGammaCurve Tests
# 	- rm
#########################

use Gtk2::TestHelper tests => 3;

ok( my $win = Gtk2::Window->new("toplevel") );

ok( my $gamma = Gtk2::GammaCurve->new() );

$win->add($gamma);

$gamma->curve->set_range(0, 255, 0, 255);

$win->show_all;

Glib::Idle->add( sub
	{
		$gamma->curve->set_vector(0, 255);
		$gamma->curve->set_curve_type('spline');
		ok( eq_array( [ $gamma->curve->get_vector(2) ], [ 0, 255 ] ) );
		Gtk2->main_quit;
		0;
	} );

Gtk2->main;

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
