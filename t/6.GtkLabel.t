#
# $Header$
#

#########################
# GtkLabel Tests
# 	- rm
#########################

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 7;
BEGIN { use_ok('Gtk2') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

ok( Gtk2->init );

ok( $win = Gtk2::Window->new() );
$win->set_border_width(10);

ok( $label = Gtk2::Label->new("Hello World!") );
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
