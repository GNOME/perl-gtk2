#
# $Header$
#

#########################
# GtkBoxes Tests
# 	- rm
#########################

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 16;
BEGIN { use_ok('Gtk2') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

ok( Gtk2->init );

ok( $win = Gtk2::Window->new() );
$win->set_border_width(10);

ok( $vbox = Gtk2::VBox->new(0,5) );
$win->add($vbox);

for( $r = 0; $r < 3; $r++ )
{
	ok( $hbox = Gtk2::HBox->new(0, 5) );
	$vbox->pack_start($hbox, 0, 0, 5);
	for( $c = 0; $c < 3; $c++ )
	{
		ok( $label = Gtk2::Label->new("(r,c):($r,$c)") );
		$hbox->pack_start($label, 0, 0, 10);
	}
}

$win->show_all;

Glib::Idle->add( sub {
		Gtk2->main_quit;
		0;
	} );

Gtk2->main;

1;
