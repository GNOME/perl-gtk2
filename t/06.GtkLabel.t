#
# $Header$
#

use strict;
use warnings;

#########################
# GtkLabel Tests
# 	- rm
#########################

#########################

use Gtk2;
use Test::More;

if( Gtk2->init_check )
{
	plan tests => 5;
}
else
{
	plan skip_all =>
		'Gtk2->init_check failed, probably unable to open DISPLAY';
}

#########################

require './t/ignore_keyboard.pl';

ok( my $win = Gtk2::Window->new() );
$win->set_border_width(10);

ok( my $label = Gtk2::Label->new("Hello World!") );
$win->add($label);

ok( $label->get_text eq 'Hello World!' );
$label->set_justify("right");
ok( $label->get_selectable == 0 );
$label->set_selectable(1);
ok( $label->get_selectable == 1 );
$label->select_region(2, 8);

$win->show_all;

Glib::Idle->add( sub {
		Gtk2->main_quit;
		0;
	} );

Gtk2->main;

1;

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
