#########################
# GtkWindow Tests
# 	- rm
#########################

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 4;
BEGIN { use_ok('Gtk2') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

ok( Gtk2->init );

ok( $win = Gtk2::Window->new("toplevel") );

ok( $gamma = Gtk2::GammaCurve->new() );

$win->add($gamma);
$win->show_all;

$gamma->curve->set_range(0, 255, 0, 255);
$gamma->curve->set_vector(0, 255, 127, 255, 127, 0);
$gamma->curve->set_curve_type('linear'); # causes a gmem alloc error
