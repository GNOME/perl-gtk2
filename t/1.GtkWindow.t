#
# $Header$
#

#########################
# GtkWindow Tests
# 	- rm
#########################

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 13;
BEGIN { use_ok('Gtk2') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

ok( Gtk2->init );

ok( $win = Gtk2::Window->new('toplevel') );
			
$win->set_has_frame('false');

G::Idle->add(sub { 
		$win2->show;

		$_[0]->move(100, 100);

		$_[0]->resize(480,600);

		ok( eq_array( [ $win->get_size ], [ 640, 480 ] ) );

		ok( eq_array( [ $win->get_frame_dimensions ],
			[ 0, 0, 300, 500 ] ) );

		ok( $_[0]->get_focus() == undef );

		$_[0]->activate_focus;

		$_[0]->activate_default;

		$_[0]->iconify;

		# doesnt work no error message
		$_[0]->deiconify;

		$_[0]->stick;

		$_[0]->unstick;

		# doesnt work no error message
		$_[0]->maximize;

		# doesnt work no error message
		$_[0]->unmaximize;

		# gtk2.2 req
		if( (Gtk2->get_version_info)[1] >= 2 )
		{
			$_[0]->fullscreen;
			$_[0]->unfullscreen;
		}

		ok(1);
		Gtk2->main_quit;
		0;
	}, $win );

$win->set_title('GtkWindow.t Test Window');

$win->set_resizable('true');

ok( $win->get_resizable == 1 );

$win->set_modal('true');

$win->set_default_size(640, 480);

$win->set_position('center');

ok( $win2 = Gtk2::Window->new() );

$win2->set_transient_for($win);

$win2->set_destroy_with_parent('true');

$win2->set_decorated('false');

$win->set_frame_dimensions(0, 0, 300, 500);

ok( $win->get_position );

ok( $win->get_title eq 'GtkWindow.t Test Window' );

# can fail b/c of get_title ???
ok( $win2->get_transient_for->eq($win) );

# need a pixbuf
#$win->set_icon($pixbuf);

$win->show;

$win->present;

ok(1);

Gtk2->main;
