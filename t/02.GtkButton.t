#
# $Header$
#

#########################
# GtkButton Tests
# 	- rm
#########################

#########################

use Gtk2;
use Test::More;

#########################

if( Gtk2->init_check )
{
	plan tests => 38;
}
else
{
	plan skip_all =>
		'Gtk2->init_check failed, probably unable to open DISPLAY';
}

$win = Gtk2::Window->new;
$win->set_title('02.Gtkbutton.t');

ok( $button = Gtk2::Button->new("Not Yet") );
ok(1);
ok( $button = Gtk2::Button->new_with_label("Not Yet") );
ok(1);
ok( $button = Gtk2::Button->new_with_mnemonic("_Not Yet") );
ok(1);

$button->show;
ok(1);

$button->signal_connect( "clicked" , sub
	{
		if( $_[0]->get_label eq 'Click _Me' )
		{
			$_[0]->set_label("Next");
			ok(1);

			ok( $_[0]->get_label eq 'Next' );
		}
		else
		{
			$win3->show_all;
		}
	} );
ok(1);

$win->add($button);
ok(1);

$win->show;

foreach (qw/normal half none/)
{
	$button->set_relief($_);
	ok(1);

	ok( $button->get_relief eq $_ );
}

$button->set_label('Click _Me');
ok(1);

ok( $button->get_label eq 'Click _Me' );

$win2 = Gtk2::Window->new;

ok( $button_stock = Gtk2::Button->new_from_stock('gtk-apply') );

$win2->add($button_stock);
ok(1);

$button_stock->show;
ok(1);

$button_stock->set_use_underline(1);
ok(1);

ok( $button_stock->get_use_underline );

$win3 = Gtk2::Window->new;

ok( $button3 = Gtk2::Button->new('gtk-quit') );

$button3->signal_connect( "clicked" , sub
	{
		Gtk2->main_quit;
		ok(1);
	} );

$button3->set_use_stock(1);
ok(1);

ok( $button3->get_use_stock );

$win3->add($button3);

Glib::Idle->add( sub
	{
		$win2->show;
		$button->pressed;
		ok(1);
		$button->released;
		ok(1);
		$button->clicked;
		ok(1);
		$button->enter;
		ok(1);
		$button->leave;
		ok(1);
		Glib::Idle->add( sub
			{
				$button->clicked;
				ok(1);
				$button3->clicked;
				ok(1);
				0;
			} );
		ok(1);
		0;
	} );
ok(1);

Gtk2->main;
ok(1);
