#
# $Header$
#
# TODO: 
#	(set|get)_attributes
#

#########################
# GtkLabel Tests
# 	- rm
#########################

#########################

use Gtk2::TestHelper tests => 22;

my $win = Gtk2::Window->new;
$win->set_border_width (10);

ok (my $label = Gtk2::Label->new ("Hello World!"), 'Gtk2::Label->new');
$win->add ($label);

is ($label->get_text, 'Hello World!', '$label->get_text');
$label->set_text ('Goodbye World!');
is ($label->get_text, 'Goodbye World!', '$label->(set|get)_text');

$label->set_label ('Hello World!');
is ($label->get_label, 'Hello World!', '$label->(set|get)_label');

$label->set_justify ("right");
is ($label->get_justify, 'right', '$label->(set|get)_justify');

$label->set_pattern ('_____');
ok (1, '$label->set_pattern');

$label->set_use_underline (0);
is ($label->get_use_underline, '', '$label->(set|get)_use_underline, false');
$label->set_use_underline (1);
is ($label->get_use_underline, 1, '$label->(set|get)_use_underline, true');

ok ($label->get_selectable == 0, '$label->get_selectable');
$label->set_selectable (1);
ok ($label->get_selectable == 1, '$label->get_selectable');

$label->select_region (2, 8);
ok (eq_array ([$label->get_selection_bounds], [2, 8]), 
	'$label->select_region|selection_region');

is ($label->get_use_markup, '', '$label->get_use_markup, false');
$label->set_markup ('<span size="50000">Hello World!</span>');
ok (1, '$label->set_markup');
$label->set_markup_with_mnemonic ('<span size="50000">_Hello World!</span>');
is ($label->get_mnemonic_keyval , 104, 
	'$label->set_markup_with_mnemonic|get_mnemonic_keyval');
is ($label->get_use_markup, 1, '$label->get_use_markup, true');
$label->set_use_markup (1);
is ($label->get_use_markup, 1, '$label->get_use_markup, true');

$label->set_line_wrap (1);
ok ($label->get_line_wrap, '$label->(set|get)_line_wrap');

ok (eq_array ([$label->get_layout_offsets],  [0, 0]), 
	'$label-get_layout_offsets');

is ($label->get_mnemonic_widget, undef, '$label->get_mnemonic_widget, undef');
my $entry = Gtk2::Entry->new;
$label->set_mnemonic_widget ($entry);
ok ($label->get_mnemonic_widget, '$label->get_mnemonic_widget, entry');

$win->show_all;

Glib::Idle->add ( sub {
		Gtk2->main_quit;

		ok ($label = Gtk2::Label->new (), 'Gtk2::Label->new ()');
		ok ($label = Gtk2::Label->new_with_mnemonic ('test'),
				'Gtk2::Label->new_with_mnemonic (string)');
		
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
