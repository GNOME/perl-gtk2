#
# $Header$
#

#########################
# GtkButton Tests
# 	- rm
#########################

#########################

use Gtk2::TestHelper tests => 36, noinit => 1;

ok( my $button = Gtk2::Button->new("Not Yet") );
ok(1);
ok( $button = Gtk2::Button->new_with_label("Not Yet") );
ok(1);
ok( $button = Gtk2::Button->new_with_mnemonic("_Not Yet") );
ok(1);

$button->signal_connect( "clicked" , sub
	{
		if( $_[0]->get_label eq 'Click _Me' )
		{
			$_[0]->set_label("Next");
			ok(1);

			ok( $_[0]->get_label eq 'Next' );
		}
	} );
ok(1);

foreach (qw/normal half none/)
{
	$button->set_relief($_);
	ok(1);

	ok( $button->get_relief eq $_ );
}

$button->set_label('Click _Me');
ok(1);

ok( $button->get_label eq 'Click _Me' );

ok( my $button_stock = Gtk2::Button->new_from_stock('gtk-apply') );

$button_stock->show;
ok(1);

$button_stock->set_use_underline(1);
ok(1);

ok( $button_stock->get_use_underline );

SKIP: {
	skip("[sg]et_focus_on_click and [sg]et_alignment are new in 2.3", 4)
		if (Gtk2->check_version(2, 3, 0));

	$button_stock->set_focus_on_click(0);
	ok(1);

	ok( ! $button_stock->get_focus_on_click() );

	$button_stock->set_alignment(0.7, 0.3);
	ok(1);

	TODO: {
		local $TODO = "get_alignment appears to have precision issues";
		is_deeply([$button_stock->get_alignment()], [0.7, 0.3]);
	}
}

ok( my $button3 = Gtk2::Button->new('gtk-quit') );

$button3->signal_connect( "clicked" , sub
	{
		ok(1);
	} );

$button3->set_use_stock(1);
ok(1);

ok( $button3->get_use_stock );

$button->pressed; ok(1);
$button->released; ok(1);
$button->clicked; ok(1);
$button->enter; ok(1);
$button->leave; ok(1);
$button->clicked; ok(1);
$button3->clicked; ok(1);

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list).  See LICENSE for more information.
