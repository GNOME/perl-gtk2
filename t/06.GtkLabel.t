#
# $Header$
#

use strict;
use warnings;

#########################
# GtkLabel Tests
# 	- rm
#########################

#########################

use Gtk2;
use Test::More;

if( Gtk2->init_check )
{
	plan tests => 5;
}
else
{
	plan skip_all =>
		'Gtk2->init_check failed, probably unable to open DISPLAY';
}

#########################

ok( my $win = Gtk2::Window->new() );
$win->set_border_width(10);

ok( my $label = Gtk2::Label->new("Hello World!") );
$win->add($label);

ok( $label->get_text eq 'Hello World!' );
$label->set_justify("right");
ok( $label->get_selectable == 0 );
$label->set_selectable(1);
ok( $label->get_selectable == 1 );
$label->select_region(2, 8);

$win->show_all;

Glib::Idle->add( sub {
		Gtk2->main_quit;
		0;
	} );

Gtk2->main;

1;
