#
# $Header$
#

#########################
# GtkHandleBox Tests
# 	- rm
#########################

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 12;
BEGIN { use_ok('Gtk2') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

ok( Gtk2->init );

ok( $win = Gtk2::Window->new('toplevel') );
$win->set_title('GtkHandleBox.t Test Window');

ok( $hb = Gtk2::HandleBox->new );
$win->add($hb);

$hb->add( Gtk2::Label->new('Just a test label') );

use Data::Dumper;

$hb->set_shadow_type('none');
ok( $hb->get_shadow_type eq 'none' );
$hb->set_shadow_type('etched-in');
ok( $hb->get_shadow_type eq 'etched-in' );

$hb->set_snap_edge('top');
ok( $hb->get_snap_edge eq 'top' );
$hb->set_snap_edge('left');
ok( $hb->get_snap_edge eq 'left' );

$hb->set_handle_position('left');
ok( $hb->get_handle_position eq 'left' );
$hb->set_handle_position('top');
ok( $hb->get_handle_position eq 'top' );

Glib::Idle->add( sub {
		Gtk2->main_quit;
		0;
	});

$win->show_all;
ok(1);

Gtk2->main;
ok(1);
