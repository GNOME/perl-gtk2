#
# $Header$
#

use strict;
use warnings;

#########################
# GtkToolbar Tests
# 	- rm
#########################

#########################

use Gtk2;
use Test::More;

if( Gtk2->init_check )
{
	plan tests => 21;
}
else
{
	plan skip_all =>
		'Gtk2->init_check failed, probably unable to open DISPLAY';
}

#########################

ok( my $dlg = Gtk2::Dialog->new('GtkToolbar.t Test Window', undef,
		[ ], 'gtk-quit', 1 ) );
$dlg->set_default_size(600,300);

# so pixmaps will work?
$dlg->realize;

ok( my $tlbr = Gtk2::Toolbar->new );
$dlg->vbox->pack_start($tlbr, 0, 0, 0);

$tlbr->set_orientation('horizontal');
ok(1);
$tlbr->set_style('both');
ok(1);

ok( $tlbr->insert_stock('gtk-open', 'Open Nothing', 'Verbose Open Nothing',
		undef, undef, 0) );

$tlbr->append_space;

ok( my $quit_btn = $tlbr->append_item('Close', 'Closes this app', 'Private',
	Gtk2::Image->new_from_stock('gtk-quit', $tlbr->get_icon_size),
       	sub { Gtk2->main_quit; }) );

$tlbr->append_space;

sub radio_event
{
	$tlbr->set_style($_[1]);
	ok(1);
	1;
}

ok( my $icons = $tlbr->append_element( 'radiobutton', undef, 'Icons',
	'Only Icons will be shown on the toolbar', 'Private',
	Gtk2::Image->new_from_stock('gtk-go-up', $tlbr->get_icon_size),
	\&radio_event, 'icons' ) );

ok( my $text = $tlbr->append_element( 'radiobutton', $icons, 'Text',
	'Only Text will be shown on the toolbar', 'Private',
	Gtk2::Image->new_from_stock('gtk-go-down', $tlbr->get_icon_size),
	\&radio_event, 'text' ) );

ok( my $both = $tlbr->append_element( 'radiobutton', $icons, 'Icons & Text',
	'Icons & Text will be shown on the toolbar', 'Private',
	Gtk2::Image->new_from_stock('gtk-go-back', $tlbr->get_icon_size),
	\&radio_event, 'both' ) );

$tlbr->append_space;

ok( my $tips = $tlbr->append_element( 'togglebutton', undef, 'Tooltips',
	'A toggle button to turn on/off Tooltips', 'Private',
	Gtk2::Image->new_from_stock('gtk-go-forward', $tlbr->get_icon_size),
	sub {
		$tlbr->set_tooltips($_[0]->get_active);
		ok(1);
		1;
	} ) );

$tlbr->append_space;

ok( my $size = $tlbr->append_element( 'togglebutton', undef, 'Icon Size',
	'A toggle button to change the icon size', 'Private',
	Gtk2::Image->new_from_stock('gtk-go-up', $tlbr->get_icon_size),
	sub {
		if( $_[0]->get_active )
		{
			$tlbr->set_icon_size('small-toolbar');
		}
		else
		{
			$tlbr->set_icon_size('large-toolbar');
		}

		ok(1);
		1;
	} ) );

$tlbr->append_space;

ok( my $entry = Gtk2::Entry->new );
$tlbr->append_widget( $entry, 'This is just an entry', 'Private' );
$entry->set_text('An Entry Widget');

Glib::Idle->add( sub {
		$icons->clicked;
		$text->clicked;
		$both->clicked;
		$tips->clicked;
		$size->clicked;
		$quit_btn->clicked;
		0;
	});

$dlg->show_all;
ok(1);

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
