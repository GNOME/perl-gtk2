#
# $Header$
#

#########################
# GtkButton Tests
# 	- rm
#########################

#########################

use Gtk2::TestHelper tests => 38;

my $win = Gtk2::Window->new;
$win->set_title('02.Gtkbutton.t');

ok( my $button = Gtk2::Button->new("Not Yet") );
ok(1);
ok( $button = Gtk2::Button->new_with_label("Not Yet") );
ok(1);
ok( $button = Gtk2::Button->new_with_mnemonic("_Not Yet") );
ok(1);

$button->show;
ok(1);

my $win3;
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

my $win2 = Gtk2::Window->new;

ok( my $button_stock = Gtk2::Button->new_from_stock('gtk-apply') );

$win2->add($button_stock);
ok(1);

$button_stock->show;
ok(1);

$button_stock->set_use_underline(1);
ok(1);

ok( $button_stock->get_use_underline );

$win3 = Gtk2::Window->new;

ok( my $button3 = Gtk2::Button->new('gtk-quit') );

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

__END__

Copyright (C) 2003 by the gtk2-perl team (see the file AUTHORS for the
full list)

This library is free software; you can redistribute it and/or modify it under
the terms of the GNU Library General Public License as published by the Free
Software Foundation; either version 2.1 of the License, or (at your option) any
later version.

This library is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU Library General Public License for more
details.

You should have received a copy of the GNU Library General Public License along
with this library; if not, write to the Free Software Foundation, Inc., 59
Temple Place - Suite 330, Boston, MA  02111-1307  USA.
