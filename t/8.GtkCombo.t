#
# $Header
#

#########################
# GtkCombo Tests
# 	- rm
#########################

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 5;
BEGIN { use_ok('Gtk2') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

ok( Gtk2->init );

ok( $win = Gtk2::Window->new() );

$win->set_title('GtkCombo.t Test Window');

ok( $combo = Gtk2::Combo->new );
$win->add($combo);

$combo->set_popdown_strings( qw/str1 str2 str3 str4/ );

$combo->set_value_in_list(1, 0);

G::Idle->add( sub 
	{
		Gtk2->main_quit;
		0;
	} );

$win->show_all;

ok(1);

Gtk2->main;
