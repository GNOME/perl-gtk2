#########################
# GtkWindow Tests
# 	- rm
#########################

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 9;
BEGIN { use_ok('Gtk2') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

ok( Gtk2->init );

ok( $win = Gtk2::Window->new('toplevel') );

$win->set_title('GtkWindow.t Test Window');

$win->set_resizable('true');

ok( $win->get_resizable == 1 );

$win->activate_focus;

$win->activate_default;

$win->set_modal('true');

$win->set_default_size(640, 480);

$win->set_position('center');

ok( $win2 = Gtk2::Window->new('toplevel') );

$win2->set_transient_for($win);

$win2->set_destroy_with_parent('true');

$win->show;
$win2->show;

# gets a null error, probably have to be in main before this makes sense
#$win->get_focus;

$win->present;

$win2->iconify;

# doesnt work no error message
$win2->deiconify;

$win2->stick;

$win2->unstick;

# doesnt work no error message
$win->maximize;

# doesnt work no error message
$win->unmaximize;

# gtk2.2 req
#$win->fullscreen;

# gtk2.2 req
#$win->unfullscreen;

$win2->set_decorated('false');

$win->set_frame_dimensions(0, 0, 300, 500);

$win->set_has_frame('true');

ok( $win->get_position );

ok( $win->get_size );

ok( $win->get_title eq 'GtkWindow.t Test Window' );

# can fail b/c of get_title ???
ok( $win2->get_transient_for->get_title eq $win->get_title );

$win->move(100, 100);

$win->resize(480,600);

# need a pixbuf
#$win->set_icon($pixbuf);

# test signals?

#Gtk2->main;
