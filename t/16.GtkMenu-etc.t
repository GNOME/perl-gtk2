#
# $Header$
#

#########################
# GtkMenu-etc Tests
# 	- rm
#########################

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 33;
BEGIN { use_ok('Gtk2') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

ok( Gtk2->init );

ok( $win = Gtk2::Window->new('toplevel') );
$win->set_title('GtkMenu-etc.t Test Window');

ok( $vbox = Gtk2::VBox->new(0, 5) );
$win->add($vbox);

ok( $menubar = Gtk2::MenuBar->new );
$vbox->pack_start($menubar, 0, 0, 0);

foreach $num (qw/1 2 3/)
{
	ok( $menu = Gtk2::Menu->new );
	$menuitem = undef;
	foreach (qw/One Two Three Four/)
	{
		ok( $menuitem = Gtk2::MenuItem->new($_.' '.$num) );
		$menu->append( $menuitem );
	}
	ok( $rootmenu = Gtk2::MenuItem->new('_Root Menu '.$num) );
	$menu->reorder_child($menuitem, 1);

	if( $num == 1 )
	{
		$rootmenu->set_submenu($menu);
#		$menu->set_tearoff_state(1);
		$menubar->append($rootmenu);
		ok(1);
	}
	elsif( $num == 2 )
	{
		$rootmenu->set_submenu($menu);
		$rootmenu->set_right_justified(1);
		$menubar->append($rootmenu);
		ok(1);
	}
	elsif( $num == 3 )
	{
		ok(1);
	}

	ok(1);
}

ok( $optmenu = Gtk2::OptionMenu->new );
$vbox->pack_start($optmenu, 0, 0, 0);
$optmenu->set_menu($menu);

Glib::Idle->add( sub {
		$menu->popup(undef, undef, undef, undef, undef, undef);
		ok(1);
		Gtk2->main_quit;
		0;
	});

$win->show_all;
ok(1);

Gtk2->main;
ok(1);
