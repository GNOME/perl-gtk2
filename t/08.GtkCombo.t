#
# $Header$
#
# Pretty much complete
#
# TODO:
#	GtkList isn't really tested as it's deprecated, should we test it?
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

if (Gtk2->init_check)
{
	plan tests => 11;
}
else
{
	plan skip_all =>
		'Gtk2->init_check failed, probably unable to open DISPLAY';
}

#########################

require './t/ignore_keyboard.pl';

my $win = Gtk2::Window->new;

ok (my $combo = Gtk2::Combo->new, 'Gtk2::Combo->new');
$win->add ($combo);

$combo->set_popdown_strings (qw/str1 str2 str3 str4/);

$combo->list->select_item (0);
is ($combo->entry->get_text, 'str1', 
	'$combo->list->select_item|entry->get_text, 1');
$combo->list->select_item (1);
is ($combo->entry->get_text, 'str2', 
	'$combo->list->select_item|entry->get_text, 2');

$combo->set_value_in_list (1, 0);

$combo->set_use_arrows (0);
is ($combo->get ('enable-arrow-keys'), 0, 
	'$combo->use_arrows, false');
$combo->set_use_arrows (1);
is ($combo->get ('enable-arrow-keys'), 1, 
	'$combo->use_arrows, true');

$combo->set_use_arrows_always (0);
is ($combo->get ('enable-arrows-always'), 0, 
	'$combo->use_arrows_always, false');
$combo->set_use_arrows_always (1);
is ($combo->get ('enable-arrows-always'), 1, 
	'$combo->use_arrows_always, true');

$combo->set_case_sensitive (0);
is ($combo->get ('case-sensitive'), 0, '$combo->set_case_sensitive, false');
$combo->set_case_sensitive (1);
is ($combo->get ('case-sensitive'), 1, '$combo->set_case_sensitive, true');

$combo->set_case_sensitive (0);

ok (my $item = Gtk2::ListItem->new_with_label ('test'), 
	'Gtk2::ListItem->new_with_label');
$combo->set_item_string ($item, 'test-text');
$item->select;

$combo->disable_activate;

Glib::Idle->add (sub
	{
		Gtk2->main_quit;
		0;
	});

$win->show_all;

Gtk2->main;

ok (1, 'all complete');

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
