#
# $Header$
#

#########################
# GtkToolbar Tests
# 	- rm
#########################

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 23;
BEGIN { use_ok('Gtk2') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

ok( Gtk2->init );

ok( $dlg = Gtk2::Dialog->new('GtkToolbar.t Test Window', undef, 
		[ ], 'gtk-quit', 1 ) );
$dlg->set_default_size(600,300);

# so pixmaps will work?
$dlg->realize;

ok( $tlbr = Gtk2::Toolbar->new );
$dlg->vbox->pack_start($tlbr, 0, 0, 0);

$tlbr->set_orientation('horizontal');
ok(1);
$tlbr->set_style('both');
ok(1);

ok( $tlbr->insert_stock('gtk-open', 'Open Nothing', 'Verbose Open Nothing',
		undef, undef, 0) );

$tlbr->append_space;
	
ok( $quit_btn = $tlbr->append_item('Close', 'Closes this app', 'Private', 
	Gtk2::Image->new_from_stock('gtk-quit', $tlbr->get_icon_size),
       	sub { Gtk2->main_quit; }) );

$tlbr->append_space;

sub radio_event
{
	$tlbr->set_style($_[1]);
	ok(1);
	1;
}

ok( $icons = $tlbr->append_element( 'radiobutton', undef, 'Icons', 
	'Only Icons will be shown on the toolbar', 'Private', 
	Gtk2::Image->new_from_stock('gtk-go-up', $tlbr->get_icon_size),
	\&radio_event, 'icons' ) );

ok( $text = $tlbr->append_element( 'radiobutton', $icons, 'Text', 
	'Only Text will be shown on the toolbar', 'Private', 
	Gtk2::Image->new_from_stock('gtk-go-down', $tlbr->get_icon_size),
	\&radio_event, 'text' ) );

ok( $both = $tlbr->append_element( 'radiobutton', $icons, 'Icons & Text', 
	'Icons & Text will be shown on the toolbar', 'Private', 
	Gtk2::Image->new_from_stock('gtk-go-back', $tlbr->get_icon_size),
	\&radio_event, 'both' ) );

$tlbr->append_space;

ok( $tips = $tlbr->append_element( 'togglebutton', undef, 'Tooltips', 
	'A toggle button to turn on/off Tooltips', 'Private', 
	Gtk2::Image->new_from_stock('gtk-go-forward', $tlbr->get_icon_size),
	sub { 
		$tlbr->set_tooltips($_[0]->get_active); 
		ok(1);
		1;
	} ) );

$tlbr->append_space;

ok( $size = $tlbr->append_element( 'togglebutton', undef, 'Icon Size', 
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

ok( $entry = Gtk2::Entry->new );
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
