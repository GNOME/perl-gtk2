#
# $Header$
#

#########################
# Gtk2 Tests
# 	- rm
#########################

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 5;
BEGIN { use_ok('Gtk2') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

use Data::Dumper;
ok( Gtk2->get_version_info );
ok( Gtk2->check_version(0,0,0) eq 'Gtk+ version too new (major mismatch)' );
ok( Gtk2->check_version(50,0,0) eq 'Gtk+ version too old (major mismatch)' );

ok( Gtk2->init );
