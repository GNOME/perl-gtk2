#
# $Header$
#

#########################
# GtkRadioButton Tests
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
$win->set_title('GtkRadioButton.t Test Window');
$win->set_border_width(5);

ok( $vbox = Gtk2::VBox->new(0, 5) );
$win->add($vbox);

ok( $rdobtn = Gtk2::RadioButton->new() );
$vbox->pack_start($rdobtn, 0, 0, 0);

ok( $rdobtn = Gtk2::RadioButton->new_from_widget($rdobtn) );
$vbox->pack_start($rdobtn, 0, 0, 0);

ok( $rdobtn = Gtk2::RadioButton->new_from_widget($rdobtn, "label") );
$vbox->pack_start($rdobtn, 0, 0, 0);

ok( $rdobtn = Gtk2::RadioButton->new(undef, "foo") );
$vbox->pack_start($rdobtn, 0, 0, 0);

ok( $rdobtn = Gtk2::RadioButton->new($rdobtn, "bar") );
$vbox->pack_start($rdobtn, 0, 0, 0);

ok( $rdobtn = Gtk2::RadioButton->new([ $rdobtn ], "bar2") );
$vbox->pack_start($rdobtn, 0, 0, 0);

ok( scalar(@{$rdobtn->get_group}) == 3 );

for( $i = 0; $i < 5; $i++ )
{
	$rdobtns[$i] = Gtk2::RadioButton->new(\@rdobtns, $i);
	$vbox->pack_start($rdobtns[$i], 0, 0, 0);
}

ok( scalar(@{$rdobtns[0]->get_group}) == 5 );

Glib::Idle->add( sub 
	{
		Gtk2->main_quit;
		0;
	} );

$win->show_all;

Gtk2->main;

1;
