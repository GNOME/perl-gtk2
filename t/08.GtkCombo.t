#
# $Header
#

use strict;
use warnings;

#########################
# GtkCombo Tests
# 	- rm
#########################

#########################

use Gtk2;
use Test::More;

if( Gtk2->init_check )
{
	plan tests => 3;
}
else
{
	plan skip_all =>
		'Gtk2->init_check failed, probably unable to open DISPLAY';
}

#########################

require './t/ignore_keyboard.pl';

ok( my $win = Gtk2::Window->new() );

$win->set_title('GtkCombo.t Test Window');

ok( my $combo = Gtk2::Combo->new );
$win->add($combo);

$combo->set_popdown_strings( qw/str1 str2 str3 str4/ );

$combo->set_value_in_list(1, 0);

Glib::Idle->add( sub
	{
		Gtk2->main_quit;
		0;
	} );

$win->show_all;

ok(1);

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
