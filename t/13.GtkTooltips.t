#
# $Header$
#

#########################
# GtkTooltips Tests
# 	- rm
#########################

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 14;
BEGIN { use_ok('Gtk2') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

ok( Gtk2->init );

ok( $win = Gtk2::Window->new('toplevel') );
$win->set_title('GtkTooltips.t Test Window');

ok( $vbox = Gtk2::VBox->new(0, 5) );
$win->add($vbox);

ok( $tips = Gtk2::Tooltips->new );

ok( $btn = Gtk2::Button->new('Button 1') );
$vbox->pack_start($btn, 0, 0, 0);
$tips->set_tip($btn, 'Tip 1', 'Vebose Tip 1');
ok(1);

ok( $btn = Gtk2::Button->new('Button 2') );
$vbox->pack_start($btn, 0, 0, 0);
$tips->set_tip($btn, 'Tip 2', 'Vebose Tip 2');
ok( (Gtk2::Tooltips->data_get($btn))->{tip_text} eq 'Tip 2' );

ok( $btn = Gtk2::Button->new('Button 3') );
$vbox->pack_start($btn, 0, 0, 0);
$tips->set_tip($btn, 'This is a really long, really big tooltip which doesn\'t '
	.'tell you anything worth knowning. There\'s no private tip either',
	undef);
ok(1);

$tips->disable;
ok(1);
$tips->enable;
ok(1);

G::Idle->add( sub {
		Gtk2->main_quit;
		0;
	});

$win->show_all;

Gtk2->main;

ok(1);
